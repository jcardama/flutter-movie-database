import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ToggleMovieWatchListState extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleMovieWatchListEmptyState extends ToggleMovieWatchListState {}

class ToggleMovieWatchListTogglingState extends ToggleMovieWatchListState {
  final int id;

  ToggleMovieWatchListTogglingState({@required this.id});

  @override
  List<Object> get props => [id];
}

class ToggleMovieWatchListToggledState extends ToggleMovieWatchListState {
  final bool toggled;

  ToggleMovieWatchListToggledState({@required this.toggled});

  @override
  List<Object> get props => [toggled];
}

class ToggleMovieWatchListNotToggledState extends ToggleMovieWatchListState {}
