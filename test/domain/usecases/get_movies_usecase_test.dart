import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';
import 'package:moviedatabase/domain/usecases/get_movies_usecase.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  GetMoviesUseCase useCase;
  MockMovieRepository repository;

  setUp(() {
    repository = MockMovieRepository();
    useCase = GetMoviesUseCase(repository);
  });

  final List movies = <MovieEntity>[];

  test('Should get movies from the repository', () async {
    //arrange
    when(repository.getMovies()).thenAnswer((_) async => Right(movies));
    //act
    final result = await useCase(EmptyParams());
    //assert
    expect(result, Right(movies));
    verify(repository.getMovies());
    verifyNoMoreInteractions(repository);
  });
}
