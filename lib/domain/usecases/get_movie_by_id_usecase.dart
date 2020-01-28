import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';

class GetMovieByIdUseCase implements UseCase<MovieEntity, GetMovieByIdParams> {
  final MovieRepository repository;

  GetMovieByIdUseCase(this.repository);

  @override
  Future<Either<Failure, MovieEntity>> call(GetMovieByIdParams params) async =>
      await repository.getMovieById(params.id);
}

class GetMovieByIdParams extends Equatable {
  final int id;

  GetMovieByIdParams(this.id);

  @override
  List<Object> get props => [id];
}
