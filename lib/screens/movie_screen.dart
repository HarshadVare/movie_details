import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_details/screens/movie_details_screen.dart';

import '../cubit/movie_cubit.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  void initState() {
    context.read<MovieCubit>().getMovies();
    super.initState();
  }

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
              padding: const EdgeInsets.all(12),
              itemCount: movieState.movieData.length,
              itemBuilder: (context, index) {
                final movie = movieState.movieData[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(
                              id: movie.imdbId,
                              movieName: movie.title,
                            )));
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: CachedNetworkImage(
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            imageUrl: movie.poster,
                            placeholder: (context, url) => const SizedBox(
                              height: 150,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie.title,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Chip(
                                label: Text(movie.year),
                                shape: const StadiumBorder(),
                              ),
                              const SizedBox(width: 10),
                              Chip(
                                label: Text(movie.type.name),
                                shape: const StadiumBorder(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
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
