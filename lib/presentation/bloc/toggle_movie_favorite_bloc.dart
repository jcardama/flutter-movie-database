import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/domain/usecases/toggle_movie_favorite_usecase.dart';

import 'bloc.dart';

class ToggleMovieFavoriteBloc
    extends Bloc<ToggleMovieFavoriteEvent, ToggleMovieFavoriteState> {
  final ToggleMovieFavoriteUseCase toggleMovieFavoriteUseCase;

  ToggleMovieFavoriteBloc({
    @required ToggleMovieFavoriteUseCase toggleMovieFavoriteUseCase,
  })  : assert(toggleMovieFavoriteUseCase != null),
        toggleMovieFavoriteUseCase = toggleMovieFavoriteUseCase;

  @override
  ToggleMovieFavoriteState get initialState => ToggleMovieFavoriteEmptyState();

  @override
  Stream<ToggleMovieFavoriteState> mapEventToState(
    ToggleMovieFavoriteEvent event,
  ) async* {
    if (event is DoToggleMovieFavoriteEvent) {
      developer.log('Is going to toggle ${event.id} favorite', name: 'BLOC');
      final toggled =
          await toggleMovieFavoriteUseCase(ToggleMovieFavoriteParams(event.id));
      developer.log('Toggled: $toggled', name: 'BLOC');
      yield* _eitherToggledOrErrorState(toggled);
    }
  }

  Stream<ToggleMovieFavoriteState> _eitherToggledOrErrorState(
    Either<Failure, bool> failureOrToggled,
  ) async* {
    yield failureOrToggled.fold(
      (_) => ToggleMovieFavoriteNotToggledState(),
      (toggled) => ToggleMovieFavoriteToggledState(toggled: toggled),
    );
  }
}
