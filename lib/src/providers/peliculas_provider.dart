import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculasProvider {
  String _apiKey = '50d47eb117d7d2bf5e012055e6d84032';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularsPage = 0;
  bool _loading = false;

  List<Pelicula> _populars = new List();

  final _popularsStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularsSink =>
      _popularsStreamController.sink.add;

  Stream<List<Pelicula>> get popularsStream => _popularsStreamController.stream;

  void dispose() {
    _popularsStreamController?.close();
  }

  Future<List<Pelicula>> _getData(Uri url) async {
    try {
      final res = await http.get(url);
      final data = json.decode(res.body);

      final movies = new Peliculas.fromJsonList(data['results']);

      return movies.items;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Pelicula>> getInCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    return await _getData(url);
  }

  Future<List<Pelicula>> getPopulars() async {
    if (_loading) return [];

    _loading = true;
    _popularsPage += 1;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularsPage.toString()
    });

    final res = await _getData(url);

    _populars.addAll(res);
    popularsSink(_populars);

    _loading = false;
    return res;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });

    try {
      final res = await http.get(url);

      final data = json.decode(res.body);
      final cast = new Cast.fromJsonList(data['cast']);

      return cast.actores;
    } catch (e) {
      print(e);
      return (e);
    }
  }

  Future<List<Pelicula>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    return await _getData(url);
  }
}
