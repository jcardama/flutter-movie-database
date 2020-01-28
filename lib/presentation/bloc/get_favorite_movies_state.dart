import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';

@immutable
abstract class FavoriteMoviesState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyFavoriteMoviesState extends FavoriteMoviesState {}

class LoadingFavoriteMoviesState extends FavoriteMoviesState {}

class LoadedFavoriteMoviesState extends FavoriteMoviesState {
  final List<MovieEntity> movies;

  LoadedFavoriteMoviesState({@required this.movies});

  @override
  List<Object> get props => [movies];
}

class ErrorFavoriteMoviesState extends FavoriteMoviesState {
  final String message;

  ErrorFavoriteMoviesState({@required this.message});

  @override
  List<Object> get props => [message];
}
