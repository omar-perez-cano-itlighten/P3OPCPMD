import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_login/home/noticias_ext_api/detalle_noticia.dart';
import 'package:google_login/models/new.dart';

import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_login/models/new.dart';
import 'package:share/share.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class ItemNoticia extends StatelessWidget {
  final NewAdapter noticia;
  final bool isApi;
  final Function saveNews;

  ItemNoticia({
    Key key,
    @required this.noticia,
    @required this.isApi,
    @required this.saveNews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
// TODO: Cambiar image.network por Extended Image con place holder en caso de error o mientras descarga la imagen
    return Container(
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetalleNoticia(noticia: noticia),
              ),
            );
          },
          child: Card(
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child:
                        (noticia.urlToImage == null || noticia.urlToImage == "")
                            ? Image.asset(
                                'assets/temp-image.png',
                                fit: BoxFit.fitHeight,
                                width: 200,
                              )
                            : Image.network(
                                noticia.urlToImage,
                                fit: BoxFit.fitHeight,
                                width: 200,
                              ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${noticia.title}",
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${noticia.publishedAt}",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "${noticia.description ?? "Descripcion no disponible"}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "${noticia.author ?? "Autor no disponible"}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (true)
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    share(noticia, context);
                                  },
                                ),
                              IconButton(
                                icon: Icon(
                                  Icons.download_sharp,
                                  size: 35,
                                ),
                                onPressed: saveNews,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void share(NewAdapter noticia, context) async {
    try {
      String urlImage = noticia.urlToImage ??
          "https://www.agora-gallery.com/advice/wp-content/uploads/2015/10/image-placeholder.png";

      var url = await get(Uri.parse(urlImage));

      String path = urlImage.split(".").last.split('?').first;

      Directory temp = await getTemporaryDirectory();

      File imageFile = File('${temp.path}/${noticia.title ?? "exmaple"}.$path');

      imageFile.writeAsBytesSync(url.bodyBytes);

      Share.shareFiles(
        ['${temp.path}/${noticia.title ?? "noticia"}.$path'],
        text:
            '${FirebaseAuth.instance.currentUser.displayName} le comparte la siguiente noticia: ${noticia.title ?? "Título"} \n ${noticia.url ?? ""}',
        subject:
            '${FirebaseAuth.instance.currentUser.displayName} está compartiendo con usted...',
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Ha ocurrido un error al compartir."),
          ),
        );
    }
  }
}
