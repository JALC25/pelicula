import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieList(),
    );
  }
}

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(
        Uri.parse("https://api.themoviedb.org/3/movie/popular?api_key=2269a1eba89a3ebb433de8c2d23888f4"));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('fallo en la pelicula');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas Populares Las Mejores que se Encuentran Hasta el Momento'),
        
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(
            title: movies[index]['title'],
            overview: movies[index]['overview'],
            posterPath: movies[index]['poster_path'],
          );
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final String overview;
  final String posterPath;

  MovieCard({
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = "https://image.tmdb.org/t/p/w185$posterPath";

    return Card(
      child: Column(
        children: <Widget>[
          Image.network(imageUrl, fit: BoxFit.cover),
          ListTile(
            title: Text(title),
            subtitle: Text(overview),
          ),
        ],
      ),
    );
  }
}