// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:films_app/provider/top_rated_movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../screens/movies_details_screen.dart';

class TopRatedMovies extends StatefulWidget {
  const TopRatedMovies({Key? key}) : super(key: key);

  @override
  State<TopRatedMovies> createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
  String getImagePath(String name) {
    return 'http://image.tmdb.org/t/p/w500/$name';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<TopRatedMoviesProvider>(context, listen: false).fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TopRatedMoviesProvider>(
      builder: (context, topRatedMoviesProvider, _) {
        return SizedBox(
          height: 255,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topRatedMoviesProvider.movies.length,
            itemBuilder: (context, index) {
              final topMovies = topRatedMoviesProvider.movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FadeTransition(
                        opacity: animation,
                        child: PageViewDetsils(
                          movieId: topMovies.id ?? 0,
                          film: topMovies,
                        ),
                      ),
                      transitionDuration: const Duration(milliseconds: 800),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Hero(
                      tag: 'movie_${topMovies.id}',
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 3.0, top: 8, right: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (topMovies.posterPath != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        getImagePath(topMovies.posterPath!),
                                    height: 200,
                                    width: 150,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              if (topMovies.posterPath == null)
                                const Column(
                                  children: [
                                    SizedBox(height: 80),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error),
                                        SizedBox(width: 5),
                                        Text('Image not available')
                                      ],
                                    ),
                                  ],
                                ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, top: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topMovies.title != null &&
                                    topMovies.title!.length > 15
                                ? '${topMovies.title!.substring(0, 15)} ...'
                                : topMovies.title ?? 'no',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          // const SizedBox(height: 5),
                          RatingBar.builder(
                            initialRating:
                                topMovies.voteAverage! / 2, // Scale of 0 to 5
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
