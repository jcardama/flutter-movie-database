import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedatabase/di/dependency_injection.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/presentation/bloc/bloc.dart';
import 'package:moviedatabase/presentation/bloc/toggle_movie_favorite_bloc.dart';
import 'package:moviedatabase/presentation/bloc/toggle_movie_favorite_state.dart';
import 'package:moviedatabase/presentation/bloc/toggle_movie_watch_list_bloc.dart';
import 'package:moviedatabase/presentation/pages/movie_page.dart';
import 'package:moviedatabase/presentation/widgets/movie_is_favorite.dart';
import 'package:moviedatabase/presentation/widgets/movie_is_in_watch_list.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({this.movie});

  final MovieEntity movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoviePage(
                  id: movie.id,
                  title: movie.title,
                ),
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                height: 290,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://image.tmdb.org/t/p/w342/${movie.posterPath}",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: null /* add child content here */,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 36,
                child: Center(
                  child: Text(
                    movie.title,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.subhead,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BlocProvider(
                    create: (_) => serviceLocator<ToggleMovieFavoriteBloc>(),
                    child: BlocBuilder<ToggleMovieFavoriteBloc,
                        ToggleMovieFavoriteState>(
                      builder: (context, state) {
                        if (state is ToggleMovieFavoriteEmptyState) {
                          return MovieIsFavorite(
                            id: movie.id,
                            isFavorite: movie.isFavorite,
                          );
                        } else if (state is ToggleMovieFavoriteToggledState) {
                          return MovieIsFavorite(
                            id: movie.id,
                            isFavorite: state.toggled,
                          );
                        } else if (state
                            is ToggleMovieFavoriteNotToggledState) {
                          return MovieIsFavorite(isFavorite: movie.isFavorite);
                        }
                        return Text('');
                      },
                    ),
                  ),
                  BlocProvider(
                    create: (_) => serviceLocator<ToggleMovieWatchListBloc>(),
                    child: BlocBuilder<ToggleMovieWatchListBloc,
                        ToggleMovieWatchListState>(
                      builder: (context, state) {
                        if (state is ToggleMovieWatchListEmptyState) {
                          return MovieIsInWatchList(
                            id: movie.id,
                            isInWatchList: movie.isInWatchList,
                          );
                        } else if (state is ToggleMovieWatchListToggledState) {
                          return MovieIsInWatchList(
                            id: movie.id,
                            isInWatchList: state.toggled,
                          );
                        } else if (state
                            is ToggleMovieWatchListNotToggledState) {
                          return MovieIsInWatchList(
                              isInWatchList: movie.isInWatchList);
                        }
                        return Text('');
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
