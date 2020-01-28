import 'package:dartz/dartz.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';

class GetFavoriteMoviesUseCase
    implements UseCase<List<MovieEntity>, EmptyParams> {
  final MovieRepository repository;

  GetFavoriteMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(EmptyParams empty) async =>
      await repository.getFavoriteMovies();
}
