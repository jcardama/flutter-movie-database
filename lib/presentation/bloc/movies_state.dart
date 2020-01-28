import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';

@immutable
abstract class MoviesState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyMoviesState extends MoviesState {}

class LoadingMoviesState extends MoviesState {}

class LoadedMoviesState extends MoviesState {
  final List<MovieEntity> movies;

  LoadedMoviesState({@required this.movies});

  @override
  List<Object> get props => [movies];
}

class ErrorMoviesState extends MoviesState {
  final String message;

  ErrorMoviesState({@required this.message});

  @override
  List<Object> get props => [message];
}
