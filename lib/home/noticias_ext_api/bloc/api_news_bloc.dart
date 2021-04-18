import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/utils/news_repository.dart';
import 'package:hive/hive.dart';
import 'package:connectivity/connectivity.dart';

part 'api_news_event.dart';
part 'api_news_state.dart';

class ApiNewsBloc extends Bloc<ApiNewsEvent, ApiNewsState> {
  ApiNewsBloc() : super(ApiNewsInit());
  Box _newsBox = Hive.box("News");

  @override
  Stream<ApiNewsState> mapEventToState(
    ApiNewsEvent event,
  ) async* {
    if (event is GetApiNewsEvent) {
      try {
        //Cargando...
        yield LoadingState();

        //Revisando conectividad a ainternet
        var connectivityResult = await (Connectivity().checkConnectivity());

        //Si hay internet, guardar las noticias en Hive, si no hay conexión, muestra las guardadas previamente
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          //Obteniendo las noticias del repositorio
          List<NewAdapter> newsList =
              await NewsRepository().getAvailableNoticias(event.query);

          //Guardando la lista de noticias en almacenamiento local
          List<NewAdapter> localNewsList = newsList
              .map((NewAdapter e) => e.copyWith(urlToImage: ""))
              .toList();
          await _newsBox.put('articles', localNewsList);

          //Estado de noticias cargadas
          yield LoadNewsState(noticiasList: newsList);
        } else {
          //Mostrando noticias locales
          List<NewAdapter> newsList = List<NewAdapter>.from(
            _newsBox.get("articles", defaultValue: []),
          );

          yield LoadSavedNewsState(noticiasList: newsList);
        }
      } catch (error) {
        print(error);
        yield ErrorState(errorMsg: "Hubo un error al cargar las noticias");
      }
    } else if (event is SaveNewsEvent) {}
  }
}
