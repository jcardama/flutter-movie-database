import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:moviedatabase/core/error/exception.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/network/network_info.dart';
import 'package:moviedatabase/data/sources/local/movie_local_data_source.dart';
import 'package:moviedatabase/data/sources/remote/movie_remote_data_source.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';

typedef Future<List<MovieEntity>> _Chooser();

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies() async {
    return await _getMovies(() {
      developer.log('getting movies...', name: 'REPOSITORY');
      final movies = remoteDataSource.getMovies();
      developer.log('movies: $movies', name: 'REPOSITORY');
      return remoteDataSource.getMovies();
    });
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getMoviesByTitle(
    String title,
  ) async {
    return await _getMovies(() {
      return remoteDataSource.getMoviesByTitle(title);
    });
  }

  @override
  Future<Either<Failure, MovieEntity>> getMovieById(
    int id,
  ) async {
    try {
      final local = await localDataSource.getMovieById(id);
      return Right(local);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies() async =>
      await _getLocalMovies(
        () => localDataSource.getFavoriteMovies(),
      );

  @override
  Future<Either<Failure, bool>> toggleMovieFavorite(
    int id,
  ) async {
    try {
      final toggled = await localDataSource.toggleMovieFavorite(id);
      developer.log('Toggled: $toggled', name: 'REPO_IMPL');
      return Right(toggled);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getWatchListMovies() async =>
      await _getLocalMovies(
        () => localDataSource.getWatchListMovies(),
      );

  @override
  Future<Either<Failure, bool>> toggleMovieWatchList(
      int id,
      ) async {
    try {
      final toggled = await localDataSource.toggleMovieWatchList(id);
      developer.log('Toggled: $toggled', name: 'REPO_IMPL');
      return Right(toggled);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, List<MovieEntity>>> _getLocalMovies(
    _Chooser chooser,
  ) async {
    try {
      final local = await chooser();
      return Right(local);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, List<MovieEntity>>> _getMovies(
    _Chooser chooser,
  ) async {
    List<MovieEntity> localMovies = await localDataSource.getMovies();
    if (await networkInfo.isConnected && localMovies.length == 0) {
      try {
        final removeMovies = await chooser();
        localDataSource.cacheMovies(removeMovies);
        return Right(removeMovies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Right(localMovies);
    }
  }
}
