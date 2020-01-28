import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/usecases/get_movies_usecase.dart';

import 'bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMoviesUseCase getMoviesUseCase;

  MoviesBloc({
    @required GetMoviesUseCase getMoviesUseCase,
  })  : assert(getMoviesUseCase != null),
        getMoviesUseCase = getMoviesUseCase;

  @override
  MoviesState get initialState => EmptyMoviesState();

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    if (event is GetMoviesEvent) {
      yield LoadingMoviesState();
      developer.log('getting movies...', name: 'BLOC');
      final failureOrMovies = await getMoviesUseCase(EmptyParams());
      developer.log('movies: $failureOrMovies', name: 'BLOC');
      yield* _eitherLoadedOrErrorState(failureOrMovies);
    }
  }

  Stream<MoviesState> _eitherLoadedOrErrorState(
    Either<Failure, List<MovieEntity>> failureOrMovies,
  ) async* {
    yield failureOrMovies.fold(
      (failure) => ErrorMoviesState(message: _mapFailureToMessage(failure)),
      (movies) => LoadedMoviesState(movies: movies),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
