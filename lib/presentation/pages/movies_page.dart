import 'package:flutter/material.dart';
import 'package:moviedatabase/presentation/pages/favorite_movies_page.dart';
import 'package:moviedatabase/presentation/pages/recent_movies_page.dart';
import 'package:moviedatabase/presentation/pages/watch_list_movies_page.dart';
import 'package:moviedatabase/presentation/widgets/colored_tab_bar.dart';

class MoviesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text('Movie Database'),
            bottom: ColoredTabBar(
              Theme.of(context).primaryColorDark,
              TabBar(
                tabs: <Widget>[Tab(text: 'Movies'), Tab(text: 'Favorites')],
                indicatorColor: Theme.of(context).accentColor,
                labelColor: Theme.of(context).accentColor,
              ),
            ),
          ),
          drawer: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Theme.of(context).primaryColorDark,
                textTheme: Theme.of(context).textTheme.copyWith(
                      body2: TextStyle(color: Colors.white),
                    )),
            child: Drawer(
              child: ListView(
                children: <Widget>[
                  Ink(
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      highlightColor: Theme.of(context).accentColor,
                      child: ListTile(
                        title: Text(
                          'Watch List',
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WatchListMoviesPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              RecentMoviesPage(),
              FavoriteMoviesPage(),
            ],
          ),
        ),
      ),
    );
  }
}
