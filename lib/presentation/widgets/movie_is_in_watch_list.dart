import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedatabase/presentation/bloc/bloc.dart';

class MovieIsInWatchList extends StatelessWidget {
  final int id;
  final bool isInWatchList;

  MovieIsInWatchList({this.id, this.isInWatchList});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'is_in_watch_list_$id',
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Icon(
        isInWatchList ? Icons.playlist_add_check : Icons.playlist_add,
        color: Colors.black54,
        semanticLabel: 'In watch list',
      ),
      onPressed: () {
        BlocProvider.of<ToggleMovieWatchListBloc>(context).add(
          DoToggleMovieWatchListEvent(id),
        );
      },
    );
  }
}
