import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/usecases/get_movie_by_id_usecase.dart';

import 'bloc.dart';

class GetMovieBloc extends Bloc<GetMovieEvent, GetMovieState> {
  final GetMovieByIdUseCase getMovieByIdUseCase;

  GetMovieBloc({
    @required GetMovieByIdUseCase getMovieByIdUseCase,
  })  : assert(getMovieByIdUseCase != null),
        getMovieByIdUseCase = getMovieByIdUseCase;

  @override
  GetMovieState get initialState => GetMovieEmptyState();

  @override
  Stream<GetMovieState> mapEventToState(
    GetMovieEvent event,
  ) async* {
    if (event is GetMovieByIdEvent) {
      yield GetMovieByIdLoadingState();
      developer.log('getting movie by id...', name: 'BLOC');
      final failureOrMovie =
          await getMovieByIdUseCase(GetMovieByIdParams(event.id));
      developer.log('movie: $failureOrMovie', name: 'BLOC');
      yield* _eitherLoadedOrErrorState(failureOrMovie);
    }
  }

  Stream<GetMovieState> _eitherLoadedOrErrorState(
    Either<Failure, MovieEntity> failureOrMovie,
  ) async* {
    yield failureOrMovie.fold(
      (failure) => GetMovieByIdErrorState(
        message: _mapFailureToMessage(failure),
      ),
      (movie) => GetMovieByIdLoadedState(
        movie: movie,
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
