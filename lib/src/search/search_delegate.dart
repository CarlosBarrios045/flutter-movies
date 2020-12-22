import 'package:flutter/material.dart';

// Provider
import 'package:peliculas/src/providers/peliculas_provider.dart';

// Models
import 'package:peliculas/src/models/pelicula_model.dart';

class DataSearch extends SearchDelegate {
  final peliculasProvider = new PeliculasProvider();
  String selected = '';

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones para nuestro AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
        child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.indigoAccent,
            child: Text(selected)));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: peliculasProvider.searchMovie(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            final peliculas = snapshot.data;

            return ListView(
                children: peliculas.map((pelicula) {
              return ListTile(
                  leading: FadeInImage(
                      image: NetworkImage(pelicula.getPosterImg()),
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      width: 50.0,
                      fit: BoxFit.contain),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: () {
                    close(context, null);
                    Navigator.pushNamed(context, 'detalle',
                        arguments: pelicula);
                  });
            }).toList());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  /* 
   final peliculas = [
    'Spiderman',
    'Capitán América',
    'Capitán América: El Soldado Del Invierno',
    'Capitán América: Civil War',
    'Batman',
    'Iron Man',
    'Iron Man 2',
    'Iron Man 3',
    'Avengers',
    'Ant Man',
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitán América',
  ];

  
  
  
  
   @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            selected = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  } */
}
