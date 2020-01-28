import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedatabase/presentation/bloc/bloc.dart';

class MovieIsFavorite extends StatelessWidget {
  final int id;
  final bool isFavorite;

  MovieIsFavorite({this.id, this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'is_favorite_$id',
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.black54,
        semanticLabel: 'Favorite',
      ),
      onPressed: () {
        BlocProvider.of<ToggleMovieFavoriteBloc>(context).add(
          DoToggleMovieFavoriteEvent(id),
        );
      },
    );
  }
}
