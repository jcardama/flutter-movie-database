import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:moviedatabase/core/network/network_info.dart';
import 'package:moviedatabase/data/repositories/movie_repository_impl.dart';
import 'package:moviedatabase/data/sources/local/movie_local_data_source.dart';
import 'package:moviedatabase/data/sources/remote/movie_remote_data_source.dart';
import 'package:moviedatabase/domain/repositories/movie_repository.dart';
import 'package:moviedatabase/domain/usecases/get_favorite_movies_usecase.dart';
import 'package:moviedatabase/domain/usecases/get_movie_by_id_usecase.dart';
import 'package:moviedatabase/domain/usecases/get_movies_by_title_usecase.dart';
import 'package:moviedatabase/domain/usecases/get_movies_usecase.dart';
import 'package:moviedatabase/domain/usecases/get_watch_list_movies_usecase.dart';
import 'package:moviedatabase/domain/usecases/toggle_movie_favorite_usecase.dart';
import 'package:moviedatabase/domain/usecases/toggle_movie_watch_list_usecase.dart';
import 'package:moviedatabase/presentation/bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Bloc
  serviceLocator.registerFactory(
    () => MoviesBloc(
      getMoviesUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetMovieBloc(
      getMovieByIdUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => FavoriteMoviesBloc(
      getFavoriteMoviesUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => ToggleMovieFavoriteBloc(
      toggleMovieFavoriteUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetWatchListMoviesBloc(
      getWatchListMoviesUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => ToggleMovieWatchListBloc(
      toggleMovieWatchListUseCase: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator.registerLazySingleton(
    () => GetMoviesUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetMovieByIdUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetMoviesByTitleUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetFavoriteMoviesUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetWatchListMoviesUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ToggleMovieFavoriteUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ToggleMovieWatchListUseCase(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Data sources
  serviceLocator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );

  //! Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => Dio());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
