import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ToggleMovieFavoriteState extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleMovieFavoriteEmptyState extends ToggleMovieFavoriteState {}

class ToggleMovieFavoriteTogglingState extends ToggleMovieFavoriteState {
  final int id;

  ToggleMovieFavoriteTogglingState({@required this.id});

  @override
  List<Object> get props => [id];
}

class ToggleMovieFavoriteToggledState extends ToggleMovieFavoriteState {
  final bool toggled;

  ToggleMovieFavoriteToggledState({@required this.toggled});

  @override
  List<Object> get props => [toggled];
}

class ToggleMovieFavoriteNotToggledState extends ToggleMovieFavoriteState {}
