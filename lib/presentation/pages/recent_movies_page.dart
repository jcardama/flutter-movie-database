import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedatabase/di/dependency_injection.dart';
import 'package:moviedatabase/presentation/bloc/bloc.dart';
import 'package:moviedatabase/presentation/widgets/error_message.dart';
import 'package:moviedatabase/presentation/widgets/movies_list.dart';

class RecentMoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecentMoviesState();
  }
}

class _RecentMoviesState extends State<RecentMoviesPage> {
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<MoviesBloc> buildBody(BuildContext context) {
    final blocProvider = BlocProvider(
      create: (_) => serviceLocator<MoviesBloc>(),
      child: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is EmptyMoviesState) {
            BlocProvider.of<MoviesBloc>(context).add(GetMoviesEvent());
          } else if (state is LoadingMoviesState) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          } else if (state is LoadedMoviesState) {
            if (state.movies.length > 0) {
              return MoviesList(
                movies: state.movies,
              );
            } else {
              return ErrorMessage(
                message: 'There are no movies at this moment',
                icon: Icons.local_movies,
              );
            }
          } else if (state is ErrorMoviesState) {
            return ErrorMessage(
              message: 'Could not retrieve movies. ${state.message}',
              icon: Icons.local_movies,
              onTryAgain: () => BlocProvider.of<MoviesBloc>(context).add(
                GetMoviesEvent(),
              ),
            );
          }
          return Container();
        },
      ),
    );
    return blocProvider;
  }
}
