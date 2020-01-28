import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/core/error/exception.dart';
import 'package:moviedatabase/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getMovies();

  Future<List<MovieModel>> getMoviesByTitle(String title);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({@required this.dio});

  @override
  Future<List<MovieModel>> getMovies() => _getMoviesFromUrl(
      'https://api.themoviedb.org/3/movie/popular?api_key=d9fcca2a76026c8951371375f5bcce23&language=en-US&page=1');

  @override
  Future<List<MovieModel>> getMoviesByTitle(String title) => _getMoviesFromUrl(
      'https://api.themoviedb.org/3/search/movie?api_key=d9fcca2a76026c8951371375f5bcce23&language=en-US&query=$title&page=1&include_adult=false');

  Future<List<MovieModel>> _getMoviesFromUrl(String url) async {
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      return (response.data['results'] as List)
          .map((it) => MovieModel.fromJson(it))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
