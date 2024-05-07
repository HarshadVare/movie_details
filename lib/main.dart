import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences? prefs;
  const MyApp({super.key, this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => MoviesCubit(prefs!)..fetchMovies(),
        child: const MoviesScreen(),
      ),
    );
  }
}

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: BlocBuilder<MoviesCubit, List<Movie>>(
        builder: (context, movies) {
          if (movies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  title: Text(movie.title),
                  leading: Image.network(movie.imageUrl),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(movie: movie)),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(movie.imageUrl),
            const SizedBox(height: 20),
            const Text('Movie Details'),
          ],
        ),
      ),
    );
  }
}

enum MoviesState { loading, loaded, error }

class MoviesCubit extends Cubit<List<MovieData>> {
  final SharedPreferences prefs;
  MoviesCubit(this.prefs) : super([]);

  Future<void> fetchMovies() async {
    final dio = Dio();
    List<MovieData> cachedMovies = _getCachedMovies();
    if (cachedMovies.isNotEmpty) {
      emit(cachedMovies);
      return;
    }

    final response = await dio
        .get("https://www.omdbapi.com/?apikey=3d277ae5&s=movie")
        
    if (response.statusCode == 200) {
      // final List<Movie> movies = (jsonDecode(response.body)['Search'] as List)
      //     .map((data) => Movie.fromJson(data))
      //     .toList();
      _saveToCache(movies);
      emit(movies);
    } else {
      // Fetch movies from cache if API request fails
      if (cachedMovies.isNotEmpty) {
        emit(cachedMovies);
      } else {
        emit([]);
      }
    }
  }

  List<Movie> _getCachedMovies() {
    final String? cachedData = prefs.getString('movies');
    if (cachedData != null) {
      final List<dynamic> decodedData = json.decode(cachedData);
      return decodedData.map((data) => Movie.fromJson(data)).toList();
    }
    return [];
  }

  void _saveToCache(List<Movie> movies) {
    final encodedData = json.encode(movies);
    prefs.setString('movies', encodedData);
  }
}

MovieData movieDataFromJson(String str) => MovieData.fromJson(json.decode(str));

String movieDataToJson(MovieData data) => json.encode(data.toJson());

class MovieData {
  List<Search> search;
  String totalResults;
  String response;

  MovieData({
    required this.search,
    required this.totalResults,
    required this.response,
  });

  factory MovieData.fromJson(Map<String, dynamic> json) => MovieData(
        search:
            List<Search>.from(json["Search"].map((x) => Search.fromJson(x))),
        totalResults: json["totalResults"],
        response: json["Response"],
      );

  Map<String, dynamic> toJson() => {
        "Search": List<dynamic>.from(search.map((x) => x.toJson())),
        "totalResults": totalResults,
        "Response": response,
      };
}

class Search {
  String title;
  String year;
  String imdbId;
  Type type;
  String poster;

  Search({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.type,
    required this.poster,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        title: json["Title"],
        year: json["Year"],
        imdbId: json["imdbID"],
        type: typeValues.map[json["Type"]]!,
        poster: json["Poster"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Year": year,
        "imdbID": imdbId,
        "Type": typeValues.reverse[type],
        "Poster": poster,
      };
}

enum Type { MOVIE }

final typeValues = EnumValues({"movie": Type.MOVIE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
