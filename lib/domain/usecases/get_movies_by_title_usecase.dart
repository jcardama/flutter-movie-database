import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';

class GetMoviesByTitleUseCase implements UseCase<List<MovieEntity>, GetMoviesByTitleParams> {
  final MovieRepository repository;

  GetMoviesByTitleUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(GetMoviesByTitleParams params) async => await repository.getMoviesByTitle(params.title);
}

class GetMoviesByTitleParams extends Equatable {
  final String title;
  GetMoviesByTitleParams(this.title);

  @override
  List<Object> get props => [title];
}
