part of 'movie_cubit.dart';

@immutable
sealed class MovieState {}

final class MovieInitial extends MovieState {}

final class MovieLoading extends MovieState {}

final class MovieError extends MovieState {
  final String error;

  MovieError({required this.error});
}

final class MovieSuccess extends MovieState {
  final List<MovieData> movieData;

  MovieSuccess({required this.movieData});
}
