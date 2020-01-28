import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';

class ToggleMovieWatchListUseCase
    implements UseCase<void, ToggleMovieWatchListParams> {
  final MovieRepository repository;

  ToggleMovieWatchListUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    ToggleMovieWatchListParams params,
  ) async {
    final toggled = await repository.toggleMovieWatchList(params.id);
    return toggled;
  }
}

class ToggleMovieWatchListParams extends Equatable {
  final int id;

  ToggleMovieWatchListParams(this.id);

  @override
  List<Object> get props => [id];
}
