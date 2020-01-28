import 'package:meta/meta.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  MovieModel({
    @required id,
    voteCount,
    video,
    voteAverage,
    @required title,
    posterPath,
    backdropPath,
    overview,
    releaseDate,
    isFavorite,
    isInWatchList,
  }) : super(
          id: id,
          voteCount: voteCount,
          video: video,
          voteAverage: voteAverage,
          title: title,
          posterPath: posterPath,
          backdropPath: backdropPath,
          overview: overview,
          releaseDate: releaseDate,
          isFavorite: isFavorite,
          isInWatchList: isInWatchList,
        );

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

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json['id'],
        voteCount: json['vote_count'],
        video: json['video'],
        voteAverage: json['vote_average'],
        title: json['title'],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        overview: json['overview'],
        releaseDate: json['release_date'],
        isFavorite: json['is_favorite'] != null && json['is_favorite'],
        isInWatchList:
            json['is_in_watch_list'] != null && json['is_in_watch_list'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'vote_count': voteCount,
        'video': video,
        'vote_average': voteAverage,
        'title': title,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'overview': overview,
        'release_date': releaseDate,
        'is_favorite': isFavorite ? true : false,
        'is_in_watch_list': isInWatchList ? true : false,
      };
}
