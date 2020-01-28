import 'package:dartz/dartz.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getMovies();

  Future<Either<Failure, List<MovieEntity>>> getMoviesByTitle(String title);

  Future<Either<Failure, MovieEntity>> getMovieById(int id);

  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies();

  Future<Either<Failure, void>> toggleMovieFavorite(int id);

  Future<Either<Failure, List<MovieEntity>>> getWatchListMovies();

  Future<Either<Failure, void>> toggleMovieWatchList(int id);
}
