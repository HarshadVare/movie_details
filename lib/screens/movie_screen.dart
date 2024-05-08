import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/movie_cubit.dart';
import 'movie_details.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: BlocConsumer<MovieCubit, MovieState>(
        listener: (context, state) {
          if (state is MovieError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (BuildContext context, MovieState movieState) {
          if (movieState is MovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (movieState is MovieSuccess) {
            return ListView.builder(
              itemCount: movieState.movieData.length,
              itemBuilder: (context, index) {
                final movie = movieState.movieData[index];
                return ListTile(
                  title: Text(movie.title),
                  leading: Text(movie.imdbId),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MovieDetailScreen()),
                    );
                  },
                );
              },
            );
          } else {
            return const Text("Something went wrong");
          }
        },
      ),
    );
  }
}
