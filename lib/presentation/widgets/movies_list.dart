import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moviedatabase/domain/entities/movie_entity.dart';
import 'package:moviedatabase/presentation/widgets/movie_item.dart';

class MoviesList extends StatelessWidget {
  const MoviesList({this.movies});

  final List<MovieEntity> movies;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return StaggeredGridView.count(
          primary: false,
          crossAxisCount: 12,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          children: movies
              .map((it) => MovieItem(
                    movie: it,
                  ))
              .toList(),
          staggeredTiles: movies.map((it) => StaggeredTile.fit((orientation == Orientation.portrait) ? 6 : 3)).toList(),
        );
      },
    );
  }
}
