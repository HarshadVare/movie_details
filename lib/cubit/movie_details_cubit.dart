import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_details/models/movie_details.dart';
import 'package:movie_details/service/dio_client.dart';

import '../service/shared_preference.dart';

part 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final CacheManager prefs;

  MovieDetailsCubit(this.prefs) : super(MovieDetailsInitial());

  Future<void> getMovieDetails(String id) async {
    try {
      emit(MovieDetailsLoading());

      final url = "https://www.omdbapi.com/?i=$id&apikey=3d277ae5";
      final (isValid, cached) = await prefs.getValidCache(url);
      if (isValid) {
        final movieDetails =
            MovieDetailsData.fromJson(json.decode(cached!.data));
        emit(MovieDetailsSuccess(movieDetailsData: movieDetails));
        return;
      }

      debugPrint("From API -------------------------->");
      final response = await DioClient.dio.get(url);

      if (response.statusCode == 200) {
        final movieDetails = MovieDetailsData.fromJson(response.data);
        await prefs.saveCache(url, json.encode(response.data));
        emit(MovieDetailsSuccess(movieDetailsData: movieDetails));
      } else {
        throw Exception("Cannot fetch the required record");
      }
    } catch (e, s) {
      print(e);
      print(s);
      emit(MovieDetailsError(error: e.toString()));
    }
  }
}
