import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MovieEntity extends Equatable {
  final int id;
  final int voteCount;
  final bool video;
  final num voteAverage;
  final String title;
  final String posterPath;
  final String backdropPath;
  final String overview;
  final String releaseDate;
  final bool isFavorite;
  final bool isInWatchList;

  MovieEntity({
    @required this.id,
    this.voteCount,
    this.video,
    this.voteAverage,
    @required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.releaseDate,
    this.isFavorite: false,
    this.isInWatchList: false,
  });

  @override
  List<Object> get props => [
        id,
        voteCount,
        video,
        voteAverage,
        title,
        posterPath,
        backdropPath,
        overview,
        releaseDate,
        isFavorite,
        isInWatchList,
      ];
}
