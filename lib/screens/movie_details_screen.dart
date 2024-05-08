import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_details/models/movie_details.dart';

import '../cubit/movie_details_cubit.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieName;
  final String id;

  const MovieDetailScreen({Key? key, required this.id, required this.movieName})
      : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    context.read<MovieDetailsCubit>().getMovieDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieDetailsSuccess) {
            final movie = state.movieDetailsData;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPosterImage(movie.poster, movie.title),
                  _buildMovieInfo(movie),
                  const SizedBox(height: 8.0),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
        },
      ),
    );
  }

  Widget _buildPosterImage(String imageUrl, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          child: CachedNetworkImage(
            width: double.infinity,
            fit: BoxFit.fitWidth,
            imageUrl: imageUrl,
            placeholder: (context, url) => const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfo(MovieDetailsData movie) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChip('Year', movie.year),
          _buildChip('Rated', movie.rated),
          _buildChip('Released', movie.released),
          _buildChip('Runtime', movie.runtime),
          _buildChip('Genre', movie.genre),
          _buildChip('Director', movie.director),
          _buildChip('Writer', movie.writer),
          _buildChip('Actors', movie.actors),
          _buildChip('Plot', movie.plot),
          _buildChip('Language', movie.language),
          _buildChip('Country', movie.country),
          _buildChip('Awards', movie.awards),
          _buildChip('IMDb Votes: ', movie.imdbVotes)
        ],
      ),
    );
  }

  Widget _buildChip(String label, String text) {
    return Chip(
      label: Text(
        '$label: $text',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
