import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FavoriteMoviesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetFavoriteMoviesEvent extends FavoriteMoviesEvent {}
