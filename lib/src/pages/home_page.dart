import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

// DelegateS
import 'package:peliculas/src/search/search_delegate.dart';

// Widgets
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  PeliculasProvider peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulars();

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Películas en cines'),
          centerTitle: false,
          backgroundColor: Colors.indigoAccent,
          toolbarHeight: 68.0,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            )
          ],
        ),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [_swiperCards(), _footer(context)],
        )),
      ),
    );
  }

  Widget _swiperCards() {
    return FutureBuilder(
        future: peliculasProvider.getInCines(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(movies: snapshot.data);
          } else {
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 15.0),
                child: Text('Populares',
                    style: Theme.of(context).textTheme.subtitle1)),
            SizedBox(height: 8.0),
            StreamBuilder(
                stream: peliculasProvider.popularsStream,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    return MovieHorizontal(
                        movies: snapshot.data,
                        nextPage: peliculasProvider.getPopulars);
                  } else {
                    return Container(
                        child: Center(child: CircularProgressIndicator()));
                  }
                })
          ]),
    );
  }
}
