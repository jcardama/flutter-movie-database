import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:moviedatabase/core/error/exception.dart';
import 'package:moviedatabase/data/models/movie_model.dart';
import 'package:moviedatabase/data/sources/remote/movie_remote_data_source.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements Dio {}

void main() {
  MovieRemoteDataSourceImpl remoteDataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl = MovieRemoteDataSourceImpl(dio: mockHttpClient);
  });

  void mockHttpClientSuccess() {
    when(mockHttpClient.get(any))
        .thenAnswer((_) async => http.Response(fixture('movies.json'), 200));
  }

  void mockHttpClientError() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('', 404));
  }

  group('getMovies', () {
    final List<MovieModel> movieModels =
        (json.decode(fixture('movies.json')) as List).map((it) => MovieModel.fromJson(it)).toList();

    test('Should perform a GET request on an URL with headers', () async {
      // arrange
      mockHttpClientSuccess();
      // act
      remoteDataSourceImpl.getMovies();
      // assert
      verify(mockHttpClient.get(
          'https://api.themoviedb.org/3/movie/now_playing?api_key=d9fcca2a76026c8951371375f5bcce23&language=en-US&page=1',
          headers: {'Content-Type': 'application/json'}));
    });

    test('Should return Moves when the response code is 200', () async {
      // arrange
      mockHttpClientSuccess();
      // act
      final result = await remoteDataSourceImpl.getMovies();
      // assert
      expect(result, equals(movieModels));
    });

    test('Should throw a ServerException when the response code is other than 200', () async {
      // arrange
      mockHttpClientError();
      // act
      final call = remoteDataSourceImpl.getMovies;
      // assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getMoviesByTitle', () {
    final String title = 'Ad Astra';
    final List<MovieModel> movieModels =
        (json.decode(fixture('movies.json')) as List).map((it) => MovieModel.fromJson(it)).toList();

    test('Should perform a GET request on an URL with headers', () async {
      // arrange
      mockHttpClientSuccess();
      // act
      remoteDataSourceImpl.getMoviesByTitle(title);
      // assert
      verify(mockHttpClient.get(
          'https://api.themoviedb.org/3/search/movie?api_key=d9fcca2a76026c8951371375f5bcce23&language=en-US&query=$title&page=1&include_adult=false',
          headers: {'Content-Type': 'application/json'}));
    });

    test('Should return Moves when the response code is 200', () async {
      // arrange
      mockHttpClientSuccess();
      // act
      final result = await remoteDataSourceImpl.getMoviesByTitle(title);
      // assert
      expect(result, equals(movieModels));
    });

    test('Should throw a ServerException when the response code is other than 200', () async {
      // arrange
      mockHttpClientError();
      // act
      final call = remoteDataSourceImpl.getMoviesByTitle;
      // assert
      expect(() => call(title), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
