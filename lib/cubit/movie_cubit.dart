import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_details/service/dio_client.dart';

import '../models/movie.dart';
import '../service/shared_preference.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final CacheManager prefs;
  MovieCubit(this.prefs) : super(MovieInitial());

  Future<void> getMovies() async {
    try {
      emit(MovieLoading());

      const url = "https://www.omdbapi.com/?apikey=3d277ae5&s=avenger";
      final (isValid, cached) = await prefs.getValidCache(url);
      if (isValid) {
        debugPrint("From Cache -------------------------->");
        final List<MovieData> movies = (json.decode(cached!.data) as List)
            .map((data) => MovieData.fromJson(data))
            .toList();
        emit(MovieSuccess(movieData: movies));
        return;
      }

      debugPrint("From API -------------------------->");

      final response = await DioClient.dio.get(url);

      if (response.statusCode == 200) {
        final List<MovieData> movies = (response.data['Search'] as List)
            .map((data) => MovieData.fromJson(data))
            .toList();
        await prefs.saveCache(url, json.encode(response.data['Search']));

        emit(MovieSuccess(movieData: movies));
      } else {
        throw Exception("Cannot fetch the required record");
      }
    } catch (e, s) {
      debugPrint(s.toString());
      emit(MovieError(error: e.toString()));
    }
  }
}
