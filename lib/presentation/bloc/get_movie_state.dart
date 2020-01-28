import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';

@immutable
abstract class GetMovieState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMovieEmptyState extends GetMovieState {}

class GetMovieByIdLoadingState extends GetMovieState {}

class GetMovieByIdLoadedState extends GetMovieState {
  final MovieEntity movie;

  GetMovieByIdLoadedState({@required this.movie});

  @override
  List<Object> get props => [movie];
}

class GetMovieByIdErrorState extends GetMovieState {
  final String message;

  GetMovieByIdErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
