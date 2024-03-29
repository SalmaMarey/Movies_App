import 'package:films_app/provider/actor_details.dart';
import 'package:films_app/provider/movie_cast.dart';
import 'package:films_app/provider/movie_details.dart';
import 'package:films_app/provider/page_view.dart';

import 'package:films_app/provider/popular_movies.dart';
import 'package:films_app/provider/top_rated_movies.dart';
import 'package:films_app/screens/home_screen.dart';
import 'package:films_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageViewProvider()),
        ChangeNotifierProvider(create: (_) => PageViewDetailsProvider()),
        ChangeNotifierProvider(create: (_) => TopRatedMoviesProvider()),
        ChangeNotifierProvider(create: (_) => PopularMoviesProvider()),
        ChangeNotifierProvider(create: (_) => MovieCastProvider()),
        ChangeNotifierProvider(create: (_) => ActorDetailsProvider()),
      ],
      child: MaterialApp(
        routes: {
          '/home': (context) => const HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: const Color.fromARGB(255, 40, 40, 40)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
