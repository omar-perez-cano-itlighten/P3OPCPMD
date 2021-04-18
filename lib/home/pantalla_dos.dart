import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/pantalla_uno.dart';
import 'package:google_login/models/articles.dart';
import 'package:google_login/models/new.dart';

import 'noticias_firebase/bloc/my_news_bloc.dart';

class PantallaDos extends StatefulWidget {
  const PantallaDos({Key key}) : super(key: key);

  @override
  _PantallaDosState createState() => _PantallaDosState();
}

class _PantallaDosState extends State<PantallaDos> {
  @override
  void initState() {
    BlocProvider.of<MyNewsBloc>(context).add(RequestAllNewsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyNewsBloc, MyNewsState>(
      listener: (context, state) {
        if (state is ErrorMessageState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("${state.errorMsg}"),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is LoadedNewsState) {
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<MyNewsBloc>(context).add(RequestAllNewsEvent());
              return getNoticias();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.noticiasList.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemNoticia(
                  noticia: state.noticiasList[index],
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

Future<List<NewAdapter>> getNoticias() async {
  var noticias = await FirebaseFirestore.instance.collection('noticias').get();
  List<NewAdapter> la = noticias.docs
      .map((element) => NewAdapter(
          author: element['author'],
          title: element['title'],
          urlToImage: element['urlToImage'],
          description: element['description']))
      // source: element['source'],
      //publishedAt: element['publishedAT'].toDate()))
      .toList();

  return la;
}
