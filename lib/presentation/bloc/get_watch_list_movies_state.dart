import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';

@immutable
abstract class GetWatchListMoviesState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetWatchListMoviesEmptyState extends GetWatchListMoviesState {}

class GetWatchListMoviesLoadingState extends GetWatchListMoviesState {}

class GetWatchListMoviesLoadedState extends GetWatchListMoviesState {
  final List<MovieEntity> movies;

  GetWatchListMoviesLoadedState({@required this.movies});

  @override
  List<Object> get props => [movies];
}

class GetWatchListMoviesErrorState extends GetWatchListMoviesState {
  final String message;

  GetWatchListMoviesErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
