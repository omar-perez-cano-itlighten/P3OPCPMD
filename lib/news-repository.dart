import 'dart:convert';
import 'dart:io';

import 'package:google_login/models/new.dart';
import 'package:http/http.dart';

import 'models/articles.dart';

class NewRepository {
  List<NewAdapter> _noticiasList;

  static final NewRepository _NewRepository = NewRepository._internal();
  factory NewRepository() {
    return _NewRepository;
  }

  NewRepository._internal();
  Future<List<NewAdapter>> getAvailableNoticias(String query) async {
    var queryParams = {
      "apiKey": "c7e1facf4e5a4df4b3beafd4f402d4ba",
    };

    if (query == "") {
      queryParams["category"] = "sports";
      queryParams["country"] = "mx";
    } else {
      queryParams["q"] = query;
    }

    final _uri = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/top-headlines',
      queryParameters: queryParams,
    );
    // TODO: completar request y deserializacion
    try {
      final response = await get(_uri);
      if (response.statusCode == HttpStatus.ok) {
        List<dynamic> data = jsonDecode(response.body)["articles"];
        _noticiasList =
            ((data).map((element) => NewAdapter.fromJson(element))).toList();
        return _noticiasList;
      }
      return [];
    } catch (e) {
      //arroje un error
      throw "Ha ocurrido un error: $e";
    }
  }
}
