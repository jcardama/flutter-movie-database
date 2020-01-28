import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ToggleMovieWatchListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DoToggleMovieWatchListEvent extends ToggleMovieWatchListEvent {
  final int id;

  DoToggleMovieWatchListEvent(this.id);

  @override
  List<Object> get props => [id];
}
