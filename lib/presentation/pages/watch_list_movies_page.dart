import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedatabase/di/dependency_injection.dart';
import 'package:moviedatabase/presentation/bloc/bloc.dart';
import 'package:moviedatabase/presentation/widgets/error_message.dart';
import 'package:moviedatabase/presentation/widgets/movies_list.dart';

class WatchListMoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WatchListMoviesState();
  }
}

class _WatchListMoviesState extends State<WatchListMoviesPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Watch list'),
        ),
        body: buildBody(context),
      ),
    );
  }

  BlocProvider<GetWatchListMoviesBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<GetWatchListMoviesBloc>(),
      child: BlocBuilder<GetWatchListMoviesBloc, GetWatchListMoviesState>(
        builder: (context, state) {
          if (state is GetWatchListMoviesEmptyState) {
            BlocProvider.of<GetWatchListMoviesBloc>(context).add(
              GetWatchListMoviesEvent(),
            );
          } else if (state is GetWatchListMoviesLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          } else if (state is GetWatchListMoviesLoadedState) {
            if (state.movies.length > 0) {
              return MoviesList(
                movies: state.movies,
              );
            } else {
              return ErrorMessage(
                message: 'Your watch list movies will appear here',
                icon: Icons.playlist_add,
              );
            }
          } else if (state is GetWatchListMoviesErrorState) {
            return ErrorMessage(
              message:
                  'Could not retreive your watch list movies. ${state.message}',
              icon: Icons.playlist_add,
              onTryAgain: () =>
                  BlocProvider.of<GetWatchListMoviesBloc>(context).add(
                GetWatchListMoviesEvent(),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
