import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moviedatabase/data/models/movie_model.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final movieModel = MovieModel(id: 419704, title: 'Ad Astra');

  test('Should be a subclass of MovieEntity', () async {
    // assert
    expect(movieModel, isA<MovieEntity>());
  });

  group('fromJson', () {
    test('Should return a valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('movie.json'));
      // act
      final result = MovieModel.fromJson(jsonMap);
      // assert
      expect(result, movieModel);
    });
  });

  group('toJson', () {
    test('Should return a JSON map with valid data', () async {
      // act
      final result = movieModel.toJson();
      // assert
      final expected = {"id": 419704, "title": "Ad Astra"};
      expect(result, expected);
    });
  });
}
