import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';
import 'package:moviedatabase/domain/usecases/get_movies_by_title_usecase.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  GetMoviesByTitleUseCase useCase;
  MockMovieRepository repository;

  setUp(() {
    repository = MockMovieRepository();
    useCase = GetMoviesByTitleUseCase(repository);
  });

  final String title = '';
  final List movies = <MovieEntity>[];

  test('Should get movies by title from the repository', () async {
    //arrange
    when(repository.getMoviesByTitle(any)).thenAnswer((_) async => Right(movies));
    //act
    final result = await useCase(GetMoviesByTitleParams(title));
    //assert
    expect(result, Right(movies));
    verify(repository.getMoviesByTitle(title));
    verifyNoMoreInteractions(repository);
  });
}
