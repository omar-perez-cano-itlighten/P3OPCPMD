import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/bloc/auth_bloc.dart';
import 'package:google_login/home/noticias_firebase/mis_noticias.dart';
import 'package:google_login/home/pantalla_dos.dart';
import 'noticias_ext_api/noticias_deportes.dart';
import 'package:google_login/home/noticias_firebase/pantalla_tres.dart';

import 'noticias_firebase/bloc/my_news_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final _titulosList = [
    "Noticias",
    "Mis noticias",
    "Nueva noticia",
  ];
  final _pagesList = [
    NoticiasDeportes(),
    PantallaDos(),
    PantallaTres(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyNewsBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_titulosList[_currentPageIndex]}"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(
                  SignOutAuthenticationEvent(),
                );
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentPageIndex,
          children: _pagesList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_kabaddi),
              label: "${_titulosList[0]}",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "${_titulosList[1]}",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "${_titulosList[2]}",
            ),
          ],
        ),
      ),
    );
  }
}
