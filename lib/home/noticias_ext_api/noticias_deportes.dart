import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/utils/news_repository.dart';
import 'package:google_login/home/noticias_ext_api/bloc/api_news_bloc.dart';
import 'package:google_login/home/noticias_firebase/bloc/my_news_bloc.dart'
    as Bloc;
import 'bloc/api_news_bloc.dart';
import 'item_noticia.dart';

class NoticiasDeportes extends StatefulWidget {
  const NoticiasDeportes({Key key}) : super(key: key);

  @override
  _NoticiasDeportesState createState() => _NoticiasDeportesState();
}

class _NoticiasDeportesState extends State<NoticiasDeportes> {
  ApiNewsBloc _bloc;
  String _query = "";
  final _firebaseInst = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _bloc = ApiNewsBloc();
        _bloc..add(GetApiNewsEvent(query: this._query));
        return _bloc;
      },
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(65),
                ),
                hintText: "Buscar noticias",
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.cyan[600],
                ),
                contentPadding: EdgeInsets.all(8.0),
              ),
              onSubmitted: (String query) {
                _bloc.add(GetApiNewsEvent(query: query));
              },
            ),
          ),
          BlocConsumer<ApiNewsBloc, ApiNewsState>(listener: (context, state) {
            if (state is ErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.errorMsg),
                  ),
                );
            } else if (state is LoadSavedNewsState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text("No hay conexión a Internet."),
                  ),
                );
            }
          }, builder: (context, state) {
            if (state is LoadNewsState) {
              return NewsQuery(
                noticiasList: state.noticiasList,
                function: _saveNews,
              );
            } else if (state is LoadSavedNewsState) {
              return NewsQuery(
                noticiasList: state.noticiasList,
                function: _saveNews,
              );
            } else if (state is ErrorState) {
              return Center(
                child: Text("Ha ocurrido un error",
                    style: TextStyle(fontSize: 26, color: Colors.red)),
              );
            }
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }),
        ],
      )),
    );
  }

  Future<void> _saveNews(
    NewAdapter noticia,
  ) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi)
        throw Exception("Offline");

      await _firebaseInst.collection("noticias").add(noticia.toJson());

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("La noticia se ha descargado."),
          ),
        );
      BlocProvider.of<Bloc.MyNewsBloc>(context).add(Bloc.RequestAllNewsEvent());
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Hubo un error al descargar la noticia."),
          ),
        );
    }
  }
}

class NewsQuery extends StatelessWidget {
  final List<NewAdapter> noticiasList;
  final Function function;
  const NewsQuery({
    @required this.noticiasList,
    Key key,
    @required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: noticiasList.length == 0
          ? Center(
              child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Text(
                "No hay noticias que mostrar.",
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
            ))
          : ListView.builder(
              itemCount: noticiasList.length,
              itemBuilder: (context, index) {
                return ItemNoticia(
                  noticia: noticiasList[index],
                  isApi: true,
                  saveNews: () {
                    function(noticiasList[index]);
                  },
                );
              },
            ),
    );
  }
}
