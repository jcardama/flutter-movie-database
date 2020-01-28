import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedatabase/di/dependency_injection.dart';
import 'package:moviedatabase/presentation/bloc/bloc.dart';
import 'package:moviedatabase/presentation/widgets/error_message.dart';

class MoviePage extends StatefulWidget {
  final int id;
  final String title;

  MoviePage({this.id, this.title});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<GetMovieBloc> buildBody(BuildContext context) {
    final blocProvider = BlocProvider(
      create: (_) => serviceLocator<GetMovieBloc>(),
      child:
          BlocBuilder<GetMovieBloc, GetMovieState>(builder: (context, state) {
        if (state is GetMovieEmptyState) {
          BlocProvider.of<GetMovieBloc>(context).add(
            GetMovieByIdEvent(widget.id),
          );
        } else if (state is GetMovieByIdLoadingState) {
          return Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is GetMovieByIdLoadedState) {
          return Builder(
            builder: (context) => Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    expandedHeight: 200,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(state.movie.title),
                      titlePadding:
                          EdgeInsetsDirectional.only(start: 72, bottom: 16),
                      background: Image.network(
                        'https://image.tmdb.org/t/p/w342/${state.movie.backdropPath}',
                        fit: BoxFit.cover,
                      ),
                      collapseMode: CollapseMode.parallax,
                    ),
                  ),
                  SliverFillRemaining(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 125,
                                height: 175,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w342/${state.movie.posterPath}",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: null /* add child content here */,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      state.movie.title,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Release date:',
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(state.movie.releaseDate),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'User score:',
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height: 38,
                                      width: 38,
                                      child: Stack(
                                        children: <Widget>[
                                          CircularProgressIndicator(
                                            value:
                                                state.movie.voteAverage * 0.1,
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                Theme.of(context).primaryColor),
                                          ),
                                          Center(
                                            child: Text(
                                              '${state.movie.voteAverage}/10',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .apply(
                                                    fontSizeFactor: 0.8,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Overview',
                            style: Theme.of(context).textTheme.title,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(state.movie.overview),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is GetMovieByIdErrorState) {
          return Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Container(
                child: Center(
                  child: ErrorMessage(
                    message: 'Couldn\'t retrieve movie. ${state.message}',
                    icon: Icons.warning,
                    onTryAgain: () =>
                        BlocProvider.of<GetMovieBloc>(context).add(
                      GetMovieByIdEvent(widget.id),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      }),
    );

    return blocProvider;
  }
}
