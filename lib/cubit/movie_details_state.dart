part of 'movie_details_cubit.dart';

@immutable
sealed class MovieDetailsState {}

final class MovieDetailsInitial extends MovieDetailsState {}

final class MovieDetailsLoading extends MovieDetailsState {}

final class MovieDetailsError extends MovieDetailsState {
  final String error;

  MovieDetailsError({required this.error});
}

final class MovieDetailsSuccess extends MovieDetailsState {
  final MovieDetailsData movieDetailsData;

  MovieDetailsSuccess({required this.movieDetailsData});
}
