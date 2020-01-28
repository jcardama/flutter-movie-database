import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedatabase/di/dependency_injection.dart';
import 'package:moviedatabase/presentation/bloc/bloc.dart';
import 'package:moviedatabase/presentation/widgets/error_message.dart';
import 'package:moviedatabase/presentation/widgets/movies_list.dart';

class FavoriteMoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoriteMoviesState();
  }
}

class _FavoriteMoviesState extends State<FavoriteMoviesPage> {
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<FavoriteMoviesBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<FavoriteMoviesBloc>(),
      child: BlocBuilder<FavoriteMoviesBloc, FavoriteMoviesState>(
        builder: (context, state) {
          if (state is EmptyFavoriteMoviesState) {
            BlocProvider.of<FavoriteMoviesBloc>(context).add(
              GetFavoriteMoviesEvent(),
            );
          } else if (state is LoadingFavoriteMoviesState) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          } else if (state is LoadedFavoriteMoviesState) {
            if (state.movies.length > 0) {
              return MoviesList(
                movies: state.movies,
              );
            } else {
              return ErrorMessage(
                message: 'Your favorite movies will appear here',
                icon: Icons.favorite_border,
              );
            }
          } else if (state is ErrorFavoriteMoviesState) {
            return ErrorMessage(
              message:
                  'Could not retreive your favorite movies. ${state.message}',
              icon: Icons.favorite_border,
              onTryAgain: () =>
                  BlocProvider.of<FavoriteMoviesBloc>(context).add(
                GetFavoriteMoviesEvent(),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
