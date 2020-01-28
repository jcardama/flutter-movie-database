import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviedatabase/core/error/failure.dart';
import 'package:moviedatabase/core/usecases/usecase.dart';
import 'package:moviedatabase/data/models/movie_model.dart';
import 'package:moviedatabase/domain/usecases/get_favorite_movies_usecase.dart';
import 'package:moviedatabase/domain/usecases/get_movies_usecase.dart';
import 'package:moviedatabase/presentation/bloc/bloc.dart';

class MockGetMoviesUseCase extends Mock implements GetMoviesUseCase {}

class MockGetFavoriteMoviesUseCase extends Mock implements GetFavoriteMoviesUseCase {}

void main() {
  MoviesBloc bloc;
  MockGetMoviesUseCase mockGetMoviesUseCase;
  MockGetFavoriteMoviesUseCase mockGetFavoriteMoviesUseCase;

  setUp(() {
    mockGetMoviesUseCase = MockGetMoviesUseCase();
    mockGetFavoriteMoviesUseCase = MockGetFavoriteMoviesUseCase();

    bloc = MoviesBloc(
      getMoviesUseCase: mockGetMoviesUseCase,
      getFavoriteMoviesUseCase: mockGetFavoriteMoviesUseCase,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(EmptyState()));
  });

  group('getMovies', () {
    final movies = [
      MovieModel(id: 1, title: 'Test')
    ];

    test('Should get data from the get movies use case', () async {
      // arrange
      when(mockGetMoviesUseCase(any)).thenAnswer((_) async => Right(movies));
      // act
      bloc.add(GetMoviesEvent());
      await untilCalled(mockGetMoviesUseCase(any));
      // assert
      verify(mockGetMoviesUseCase(any));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully', () async {
      // arrange
      when(mockGetMoviesUseCase(any)).thenAnswer((_) async => Right(movies));
      // assert later
      final expected = [
        EmptyState(),
        LoadingState(),
        LoadedState(movies: movies),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetMoviesEvent());
    });

    test('Should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetMoviesUseCase(any)).thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        EmptyState(),
        LoadingState(),
        ErrorState(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetMoviesEvent());
    });

    test('Should emit [Loading, Error] with a proper message for the error when getting data fails', () async {
      // arrange
      when(mockGetMoviesUseCase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        EmptyState(),
        LoadingState(),
        ErrorState(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetMoviesEvent());
    });
  });

  group('getFavoriteMovies', () {
    final movies = [
      MovieModel(id: 1, title: 'Test')
    ];

    test('Should get data from the get favorite movies use case', () async {
      // arrange
      when(mockGetFavoriteMoviesUseCase(any)).thenAnswer((_) async => Right(movies));
      // act
      bloc.add(GetFavoriteMoviesEvent());
      await untilCalled(mockGetFavoriteMoviesUseCase(any));
      // assert
      verify(mockGetFavoriteMoviesUseCase(any));
    });

    test(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetFavoriteMoviesUseCase(any)).thenAnswer((_) async => Right(movies));
        // assert later
        final expected = [
          EmptyState(),
          LoadingState(),
          LoadedState(movies: movies),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetFavoriteMoviesEvent());
      },
    );

    test(
      'Should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetFavoriteMoviesUseCase(any)).thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          EmptyState(),
          LoadingState(),
          ErrorState(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetFavoriteMoviesEvent());
      },
    );

    test(
      'Should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetFavoriteMoviesUseCase(any)).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          EmptyState(),
          LoadingState(),
          ErrorState(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetFavoriteMoviesEvent());
      },
    );
  });
}
