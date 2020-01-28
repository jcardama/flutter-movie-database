import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/domain/usecases/toggle_movie_watch_list_usecase.dart';

import './bloc.dart';

class ToggleMovieWatchListBloc
    extends Bloc<ToggleMovieWatchListEvent, ToggleMovieWatchListState> {
  final ToggleMovieWatchListUseCase toggleMovieWatchListUseCase;

  ToggleMovieWatchListBloc({
    @required ToggleMovieWatchListUseCase toggleMovieWatchListUseCase,
  })  : assert(toggleMovieWatchListUseCase != null),
        toggleMovieWatchListUseCase = toggleMovieWatchListUseCase;

  @override
  ToggleMovieWatchListState get initialState =>
      ToggleMovieWatchListEmptyState();

  @override
  Stream<ToggleMovieWatchListState> mapEventToState(
    ToggleMovieWatchListEvent event,
  ) async* {
    if (event is DoToggleMovieWatchListEvent) {
      final toggled = await toggleMovieWatchListUseCase(
          ToggleMovieWatchListParams(event.id));
      yield* _eitherToggledOrErrorState(toggled);
    }
  }

  Stream<ToggleMovieWatchListState> _eitherToggledOrErrorState(
    Either<Failure, bool> failureOrToggled,
  ) async* {
    yield failureOrToggled.fold(
      (_) => ToggleMovieWatchListNotToggledState(),
      (toggled) => ToggleMovieWatchListToggledState(toggled: toggled),
    );
  }
}
