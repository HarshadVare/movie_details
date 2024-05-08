import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/movie.dart';
import '../service/shared_preference.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MySharedPreferences prefs;
  MovieCubit(this.prefs) : super(MovieInitial());

  Future<void> getMovies() async {
    try {
      emit(MovieLoading());
      final dio = Dio();
      const url = "https://www.omdbapi.com/?apikey=3d277ae5&s=avenger";

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final List<MovieData> movies = (response.data['Search'] as List)
            .map((data) => MovieData.fromJson(data))
            .toList();
        prefs.put(url, json.encode(response.data['Search']));

        emit(MovieSuccess(movieData: movies));
      } else {
        // Fetch movies from cache if API request fails
        if (await prefs.has(url)) {
          final cached = await prefs.get(url);

          if (cached == null) {
            return emit(MovieError(error: "No Cache Data Found"));
          }

          final List<MovieData> movies = (jsonDecode(cached) as List)
              .map((data) => MovieData.fromJson(data))
              .toList();
          emit(MovieSuccess(movieData: movies));
        } else {
          emit(MovieError(error: response.data['Response']));
        }
      }
    } catch (e) {
      emit(MovieError(error: e.toString()));
    }
  }
}
