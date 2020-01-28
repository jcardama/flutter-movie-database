import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/usecases/get_watch_list_movies_usecase.dart';

import './bloc.dart';

class GetWatchListMoviesBloc
    extends Bloc<GetWatchListMoviesEvent, GetWatchListMoviesState> {
  final GetWatchListMoviesUseCase getWatchListMoviesUseCase;

  GetWatchListMoviesBloc({
    @required GetWatchListMoviesUseCase getWatchListMoviesUseCase,
  })  : assert(getWatchListMoviesUseCase != null),
        getWatchListMoviesUseCase = getWatchListMoviesUseCase;

  @override
  GetWatchListMoviesState get initialState => GetWatchListMoviesEmptyState();

  @override
  Stream<GetWatchListMoviesState> mapEventToState(
    GetWatchListMoviesEvent event,
  ) async* {
    if (event is GetWatchListMoviesEvent) {
      yield GetWatchListMoviesLoadingState();
      final failureOrMovies = await getWatchListMoviesUseCase(EmptyParams());
      yield* _eitherLoadedOrErrorState(failureOrMovies);
    }
  }

  Stream<GetWatchListMoviesState> _eitherLoadedOrErrorState(
    Either<Failure, List<MovieEntity>> failureOrMovies,
  ) async* {
    yield failureOrMovies.fold(
      (failure) => GetWatchListMoviesErrorState(
        message: _mapFailureToMessage(failure),
      ),
      (movies) => GetWatchListMoviesLoadedState(
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
