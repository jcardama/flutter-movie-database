import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';
import 'package:moviedatabase/domain/usecases/get_movie_by_id_usecase.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  GetMovieByIdUseCase useCase;
  MockMovieRepository repository;

  setUp(() {
    repository = MockMovieRepository();
    useCase = GetMovieByIdUseCase(repository);
  });

  final id = 1;
  final movie = MovieEntity(id: 1, title: 'Test');

  test('Should get movie by id from the repository', () async {
    //arrange
    when(repository.getMovieById(any)).thenAnswer((_) async => Right(movie));
    //act
    final result = await useCase(GetMovieByIdParams(id));
    //assert
    expect(result, Right(movie));
    verify(repository.getMovieById(id));
    verifyNoMoreInteractions(repository);
  });
}
