import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_movies/models/movie.dart';
import 'package:flutter_movies/services/movie_service.dart';
import 'package:flutter_movies/widgets/movie_widget.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoviesPage();
}

class _MoviesPage extends State<MoviesPage> {
  final MovieService _movieService = MovieService();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var latestMovieBuilder = FutureBuilder(
        future: _movieService.getLastMovieAsync(),
        builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // } else {
          if (snapshot.hasData) {
            return MovieWidget(movie: snapshot.data ?? Movie.emptyMovie());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Une erreur est survenue',
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          // }
        });

    var upcomingMovies = FutureBuilder(
        future: _movieService.getUpcomingMoviesAsync(1),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          final PageController controller = PageController();

          if (snapshot.hasData) {
            if (snapshot.data != null) {
              var movieWidgets = <MovieWidget>[];

              for (var movie in snapshot.data as List<Movie>) {
                movieWidgets.add(MovieWidget(movie: movie));
              }

              return PageView(
                controller: controller,
                children: movieWidgets,
              );
            } else {
              return const Center(
                child: Text('Pas de films!'),
              );
            }
          } else {
            return const Center(
              child: Text('Pas de films!'),
            );
          }
        });

    var widgets = <Widget>[latestMovieBuilder, upcomingMovies];

    return Scaffold(
      appBar: AppBar(title: const Text('Films')),
      body: widgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.theaters_outlined),
            label: 'Latest',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.theaters),
            label: 'Upcoming',
          )
        ],
        selectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onTapItem,
      ),
    );
  }

  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Stream<Movie> _generateLatestMovieStream() {
    late final StreamController<Movie> controller;

    controller = StreamController<Movie>(
      onListen: () => _movieService.getLastMovieAsync(),
    );

    return controller.stream;
  }

  Stream<List<Movie>> _generateUpcomingMoviesStream() {
    late final StreamController<List<Movie>> controller;

    controller = StreamController<List<Movie>>(
        onListen: () => _movieService.getUpcomingMoviesAsync(1));

    return controller.stream;
  }
}