import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  // final Movie movie;

  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("movie.title"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.network(movie.imageUrl),
            SizedBox(height: 20),
            Text('Movie Details'),
          ],
        ),
      ),
    );
  }
}
