import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:moviedatabase/core/error/exception.dart';
import 'package:moviedatabase/data/models/movie_model.dart';
import 'package:moviedatabase/data/sources/local/movie_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MovieLocalDataSourceImpl movieLocalDataSourceImpl;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    movieLocalDataSourceImpl = MovieLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getMovies', () {
    final List<MovieModel> movies = (json.decode(fixture('movies_cached.json')) as List)
        .map((it) => MovieModel.fromJson(it))
        .toList();

    test('Should return List<MovieEntity> from SharedPreferences when there is locally stored data', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('movies_cached.json'));
      // act
      final result = await movieLocalDataSourceImpl.getMovies();
      // assert
      verify(mockSharedPreferences.getString(CACHED_MOVIES));
      expect(result, equals(movies));
    });

    test('Should throw a CacheException when there is no cached movies', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = movieLocalDataSourceImpl.getMovies;
      // assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheMovies', () {
    final List<MovieModel> movieModels = [MovieModel(id: 1, title: 'Test')];

    test('Should call SharedPreferences to cache the data', () async {
      // act
      movieLocalDataSourceImpl.cacheMovies(movieModels);
      // assert
      final expectedJsonString = json.encode(movieModels.map((it) => it.toJson()).toList());
      verify(mockSharedPreferences.setString(CACHED_MOVIES, expectedJsonString));
    });
  });
}
