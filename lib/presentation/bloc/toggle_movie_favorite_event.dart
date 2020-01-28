import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ToggleMovieFavoriteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DoToggleMovieFavoriteEvent extends ToggleMovieFavoriteEvent {
  final int id;

  DoToggleMovieFavoriteEvent(this.id);

  @override
  List<Object> get props => [id];
}
