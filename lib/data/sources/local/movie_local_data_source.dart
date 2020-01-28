import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:meta/meta.dart';
import 'package:moviedatabase/data/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MovieLocalDataSource {
  /// Gets the cached [List<MovieModel>]
  ///
  /// Throws a [NoLocalDataException] for all error codes.
  Future<List<MovieModel>> getMovies();

  /// Gets the cached [List<MovieModel>]
  ///
  /// Throws a [NoLocalDataException] for all error codes.
  Future<List<MovieModel>> getMoviesByTitle(String title);

  /// Gets a [MovieModel] by its id
  ///
  /// Throws a [NoLocalDataException] for all error codes.
  Future<MovieModel> getMovieById(int id);

  Future<void> cacheMovies(List<MovieModel> movies);

  /// Gets the favorites [List<MovieModel>]
  ///
  /// Throws a [NoLocalDataException] for all error codes.
  Future<List<MovieModel>> getFavoriteMovies();

  Future<bool> toggleMovieFavorite(int id);

  /// Gets [List<MovieModel>] added to watch list
  ///
  /// Throws a [NoLocalDataException] for all error codes.
  Future<List<MovieModel>> getWatchListMovies();

  Future<bool> toggleMovieWatchList(int id);
}

const CACHED_MOVIES = 'CACHED_MOVIES';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final SharedPreferences sharedPreferences;

  MovieLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<bool> toggleMovieFavorite(int id) async {
    bool added = false;
    final movies = await getMovies();
    await cacheMovies(movies.map((it) {
      final jsonMovie = it.toJson();
      if (it.id == id) {
        jsonMovie['is_favorite'] = !jsonMovie['is_favorite'];
        added = jsonMovie['is_favorite'];
      }
      return MovieModel.fromJson(jsonMovie);
    }).toList());
    developer.log('Toggled: $added', name: 'LOCAL');
    return added;
  }

  @override
  Future<bool> toggleMovieWatchList(int id) async {
    bool added = false;
    final movies = await getMovies();
    await cacheMovies(movies.map((it) {
      final jsonMovie = it.toJson();
      if (it.id == id) {
        jsonMovie['is_in_watch_list'] = !jsonMovie['is_in_watch_list'];
        added = jsonMovie['is_in_watch_list'];
      }
      return MovieModel.fromJson(jsonMovie);
    }).toList());
    developer.log('Toggled: $added', name: 'LOCAL');
    return added;
  }

  @override
  Future<void> cacheMovies(List<MovieModel> movies) {
    return sharedPreferences.setString(
        CACHED_MOVIES, json.encode(movies.map((it) => it.toJson()).toList()));
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies() {
    final jsonString = sharedPreferences.getString(CACHED_MOVIES);
    if (jsonString != null) {
      return Future.value((json.decode(jsonString) as List)
          .map((it) => MovieModel.fromJson(it))
          .toList()
          .where((it) => it.isFavorite)
          .toList());
    } else {
      return Future.value(List<MovieModel>());
    }
  }

  @override
  Future<MovieModel> getMovieById(int id) {
    final jsonString = sharedPreferences.getString(CACHED_MOVIES);
    if (jsonString != null) {
      return Future.value((json.decode(jsonString) as List)
          .map((it) => MovieModel.fromJson(it))
          .toList()
          .firstWhere((it) => it.id == id));
    } else {
      return Future.value(MovieModel(id: 0, title: ''));
    }
  }

  @override
  Future<List<MovieModel>> getMovies() {
    final jsonString = sharedPreferences.getString(CACHED_MOVIES);
    if (jsonString != null) {
      return Future.value((json.decode(jsonString) as List)
          .map((it) => MovieModel.fromJson(it))
          .toList());
    } else {
      return Future.value(List<MovieModel>());
    }
  }

  @override
  Future<List<MovieModel>> getMoviesByTitle(String title) {
    // TODO: implement getMoviesByTitle
    throw UnimplementedError();
  }

  @override
  Future<List<MovieModel>> getWatchListMovies() {
    final jsonString = sharedPreferences.getString(CACHED_MOVIES);
    if (jsonString != null) {
      return Future.value((json.decode(jsonString) as List)
          .map((it) => MovieModel.fromJson(it))
          .toList()
          .where((it) => it.isInWatchList)
          .toList());
    } else {
      return Future.value(List<MovieModel>());
    }
  }
}
