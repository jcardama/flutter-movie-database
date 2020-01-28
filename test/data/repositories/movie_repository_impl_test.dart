import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviedatabase/core/error/exception.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/network/network_info.dart';
import 'package:moviedatabase/data/models/movie_model.dart';
import 'package:moviedatabase/data/repositories/movie_repository_impl.dart';
import 'package:moviedatabase/data/sources/local/movie_local_data_source.dart';
import 'package:moviedatabase/data/sources/remote/movie_remote_data_source.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';

class MockRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockLocalDataSource extends Mock implements MovieLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MovieRepositoryImpl repositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = MovieRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getMovies', () {
    final movieModels = List<MovieModel>();
    final List<MovieEntity> movieEntities = movieModels;

    test('Should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl.getMovies();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('Should return remote data when call to remote data sources is successful', () async {
        // arrange
        when(mockRemoteDataSource.getMovies()).thenAnswer((_) async => movieModels);
        // act
        final result = await repositoryImpl.getMovies();
        // assert
        verify(mockRemoteDataSource.getMovies());
        expect(result, equals(Right(movieEntities)));
      });

      test('Should cache the data locally when call to remote data sources is successful', () async {
        // arrange
        when(mockRemoteDataSource.getMovies()).thenAnswer((_) async => movieModels);
        // act
        await repositoryImpl.getMovies();
        // assert
        verify(mockRemoteDataSource.getMovies());
        verify(mockLocalDataSource.cacheMovies(movieModels));
      });

      test('Should return ServerFailure when call to remote data sources is unsuccessful', () async {
        // arrange
        when(mockRemoteDataSource.getMovies()).thenThrow(ServerException());
        // act
        final result = await repositoryImpl.getMovies();
        // assert
        verify(mockRemoteDataSource.getMovies());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('Should return locally cached movies when cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getMovies()).thenAnswer((_) async => movieModels);
        // act
        final result = await repositoryImpl.getMovies();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getMovies());
        expect(result, equals(Right(movieEntities)));
      });

      test('Should return CacheFailure when no cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getMovies()).thenThrow(CacheException());
        // act
        final result = await repositoryImpl.getMovies();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getMovies());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getMoviesByTitle', () {
    final title = 'Test';
    final movieModels = List<MovieModel>();
    final List<MovieEntity> movieEntities = movieModels;

    test('Should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl.getMoviesByTitle(title);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('Should return remote data when call to remote data sources is successful', () async {
        // arrange
        when(mockRemoteDataSource.getMoviesByTitle(title)).thenAnswer((_) async => movieModels);
        // act
        final result = await repositoryImpl.getMoviesByTitle(title);
        // assert
        verify(mockRemoteDataSource.getMoviesByTitle(title));
        expect(result, equals(Right(movieEntities)));
      });

      test('Should cache the data locally when call to remote data sources is successful', () async {
        // arrange
        when(mockRemoteDataSource.getMoviesByTitle(title)).thenAnswer((_) async => movieModels);
        // act
        await repositoryImpl.getMoviesByTitle(title);
        // assert
        verify(mockRemoteDataSource.getMoviesByTitle(title));
        verify(mockLocalDataSource.cacheMovies(movieModels));
      });

      test('Should return ServerFailure when call to remote data sources is unsuccessful', () async {
        // arrange
        when(mockRemoteDataSource.getMoviesByTitle(title)).thenThrow(ServerException());
        // act
        final result = await repositoryImpl.getMoviesByTitle(title);
        // assert
        verify(mockRemoteDataSource.getMoviesByTitle(title));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('Should return locally cached movies when cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getMoviesByTitle(title)).thenAnswer((_) async => movieModels);
        // act
        final result = await repositoryImpl.getMoviesByTitle(title);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getMoviesByTitle(title));
        expect(result, equals(Right(movieEntities)));
      });

      test('Should return CacheFailure when no cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getMoviesByTitle(title)).thenThrow(CacheException());
        // act
        final result = await repositoryImpl.getMoviesByTitle(title);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getMoviesByTitle(title));
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getMovieById', () {
    final id = 1;
    final movieModel = MovieModel(id: 1, title: 'Test');
    final MovieEntity movieEntity = movieModel;

    runTestsOffline(() {
      test('Should return locally cached movie by id when cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getMovieById(id)).thenAnswer((_) async => movieModel);
        // act
        final result = await repositoryImpl.getMovieById(id);
        // assert
        verify(mockLocalDataSource.getMovieById(id));
        expect(result, equals(Right(movieEntity)));
      });

      test('Should return CacheFailure when no cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getMovieById(id)).thenThrow(CacheException());
        // act
        final result = await repositoryImpl.getMovieById(id);
        // assert
        verify(mockLocalDataSource.getMovieById(id));
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getFavoriteMovies', () {
    final movieModels = List<MovieModel>();
    final List<MovieEntity> movieEntities = movieModels;

    runTestsOffline(() {
      test('Should return favorite movies when cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getFavoriteMovies()).thenAnswer((_) async => movieModels);
        // act
        final result = await repositoryImpl.getFavoriteMovies();
        // assert
        verify(mockLocalDataSource.getFavoriteMovies());
        expect(result, equals(Right(movieEntities)));
      });

      test('Should return CacheFailure when no cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getFavoriteMovies()).thenThrow(CacheException());
        // act
        final result = await repositoryImpl.getFavoriteMovies();
        // assert
        verify(mockLocalDataSource.getFavoriteMovies());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getWatchListMovies', () {
    final movieModels = List<MovieModel>();
    final List<MovieEntity> movieEntities = movieModels;

    runTestsOffline(() {
      test('Should return movies added to watch list when cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getWatchListMovies()).thenAnswer((_) async => movieModels);
        // act
        final result = await repositoryImpl.getWatchListMovies();
        // assert
        verify(mockLocalDataSource.getWatchListMovies());
        expect(result, equals(Right(movieEntities)));
      });

      test('Should return CacheFailure when no cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getWatchListMovies()).thenThrow(CacheException());
        // act
        final result = await repositoryImpl.getWatchListMovies();
        // assert
        verify(mockLocalDataSource.getWatchListMovies());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
