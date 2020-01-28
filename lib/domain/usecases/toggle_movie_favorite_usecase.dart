import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';

class ToggleMovieFavoriteUseCase
    implements UseCase<void, ToggleMovieFavoriteParams> {
  final MovieRepository repository;

  ToggleMovieFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    ToggleMovieFavoriteParams params,
  ) async {
    final toggled = await repository.toggleMovieFavorite(params.id);
    developer.log('Toggled: $toggled', name: 'USECASE');
    return toggled;
  }
}

class ToggleMovieFavoriteParams extends Equatable {
  final int id;

  ToggleMovieFavoriteParams(this.id);

  @override
  List<Object> get props => [id];
}
