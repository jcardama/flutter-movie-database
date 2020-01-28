import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/usecases/get_favorite_movies_usecase.dart';
import 'package:moviedatabase/presentation/bloc/get_favorite_movies_event.dart';

import 'bloc.dart';
import 'get_favorite_movies_state.dart';

class FavoriteMoviesBloc extends Bloc<FavoriteMoviesEvent, FavoriteMoviesState> {
  final GetFavoriteMoviesUseCase getFavoriteMoviesUseCase;

  FavoriteMoviesBloc({
    @required GetFavoriteMoviesUseCase getFavoriteMoviesUseCase,
  })  : assert(getFavoriteMoviesUseCase != null),
        getFavoriteMoviesUseCase = getFavoriteMoviesUseCase;

  @override
  FavoriteMoviesState get initialState => EmptyFavoriteMoviesState();

  @override
  Stream<FavoriteMoviesState> mapEventToState(
    FavoriteMoviesEvent event,
  ) async* {
    if (event is GetFavoriteMoviesEvent) {
      yield LoadingFavoriteMoviesState();
      developer.log('getting movies...', name: 'BLOC');
      final failureOrMovies = await getFavoriteMoviesUseCase(EmptyParams());
      developer.log('movies: $failureOrMovies', name: 'BLOC');
      yield* _eitherLoadedOrErrorState(failureOrMovies);
    }
  }

  Stream<FavoriteMoviesState> _eitherLoadedOrErrorState(
    Either<Failure, List<MovieEntity>> failureOrMovies,
  ) async* {
    yield failureOrMovies.fold(
      (failure) => ErrorFavoriteMoviesState(
        message: _mapFailureToMessage(failure),
      ),
      (movies) => LoadedFavoriteMoviesState(
        movies: movies,
      ),
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
