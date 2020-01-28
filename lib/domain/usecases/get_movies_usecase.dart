import 'package:dartz/dartz.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';
import 'dart:developer' as developer;

class GetMoviesUseCase implements UseCase<List<MovieEntity>, EmptyParams> {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(EmptyParams empty) async {
    developer.log('getting movies...', name: 'USECASE');
    final movies = await repository.getMovies();
    developer.log('movies: $movies', name: 'USECASE');
    return movies;
  }
}
