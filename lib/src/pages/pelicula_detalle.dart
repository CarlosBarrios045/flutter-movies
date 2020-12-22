import 'package:flutter/material.dart';

// Models
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

// Providers
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    final peliProvider = new PeliculasProvider();

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _createAppbar(pelicula),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 10.0,
          ),
          _posterTitle(context, pelicula),
          SizedBox(
            height: 30.0,
          ),
          _description(pelicula),
          _description(pelicula),
          _description(pelicula),
          _description(pelicula),
          _description(pelicula),
          SizedBox(
            height: 10.0,
          ),
          _createCasting(pelicula, peliProvider),
          SizedBox(
            height: 20.0,
          ),
        ]))
      ],
    ));
  }

  Widget _createAppbar(Pelicula pelicula) {
    return SliverAppBar(
        elevation: 2.0,
        backgroundColor: Colors.indigoAccent,
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          /*  centerTitle: true,
          title: ClipRRect(
            borderRadius: BorderRadius.circular(3.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              color: Colors.white24,
              child: Text(pelicula.title,
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
          ), */
          background: FadeInImage(
              image: NetworkImage(pelicula.getBackgroundImg()),
              placeholder: AssetImage('assets/img/loading.gif'),
              fit: BoxFit.cover),
        ));
  }

  Widget _posterTitle(BuildContext context, Pelicula pelicula) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                      height: 150.0,
                      image: NetworkImage(pelicula.getPosterImg()))),
            ),
            SizedBox(width: 20.0),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  pelicula.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.0),
                Row(
                  children: [
                    Icon(Icons.star_border),
                    SizedBox(width: 5.0),
                    Text(
                      pelicula.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                )
              ],
            ))
          ],
        ));
  }

  Widget _description(Pelicula pelicula) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          children: [
            Text(
              pelicula.overview,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 14.0,
            ),
          ],
        ));
  }

  Widget _createCasting(Pelicula pelicula, PeliculasProvider peliProvider) {
    return FutureBuilder(
        future: peliProvider.getCast(pelicula.id.toString()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _createActorsPageView(snapshot.data);
          } else {
            return Container(
                height: 60.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _createActorsPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
          pageSnapping: false,
          controller: PageController(viewportFraction: 0.3, initialPage: 1),
          itemCount: actores.length,
          itemBuilder: (BuildContext context, int i) => _cardActor(actores[i])),
    );
  }

  Widget _cardActor(Actor actor) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              image: NetworkImage(actor.getPhoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 170.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
