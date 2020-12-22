import 'package:flutter/material.dart';

// Classes
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> movies;
  final Function nextPage;

  MovieHorizontal({@required this.movies, @required this.nextPage});

  final _pageController = PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (BuildContext ctx, int i) {
          return _card(ctx, movies[i]);
        },
        // children: _cards(context),
      ),
    );
  }

  Widget _card(BuildContext context, Pelicula movie) {
    movie.uniqueId = '${movie.id}-poster';

    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(children: [
        Hero(
          tag: movie.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 135.0),
          ),
        ),
        SizedBox(height: 5.0),
        Text(movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption)
      ]),
    );

    return GestureDetector(
        child: card,
        onTap: () => Navigator.pushNamed(context, 'detalle', arguments: movie));
  }
}
