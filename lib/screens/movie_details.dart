import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/movie_details_cubit.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieName;
  final String id;

  const MovieDetailScreen(
      {super.key, required this.id, required this.movieName});

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
      appBar: AppBar(
        title: Text(widget.movieName),
      ),
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
          builder: ((context, state) {
        if (state is MovieDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieDetailsSuccess) {
          return Text(state.movieDetailsData.imdbId);
        } else {
          return const Text("Something went wrong");
        }
      })),
    );
  }
}
