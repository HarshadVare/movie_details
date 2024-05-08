import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_details/cubit/movie_cubit.dart';
import 'package:movie_details/cubit/movie_details_cubit.dart';

import 'screens/movie_screen.dart';
import 'service/shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieCubit>(
            create: (BuildContext context) => MovieCubit(CacheManager()),
          ),
          BlocProvider<MovieDetailsCubit>(
            create: (BuildContext context) => MovieDetailsCubit(CacheManager()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MoviesScreen(),
        ));
  }
}
