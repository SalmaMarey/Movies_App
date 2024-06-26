// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:films_app/provider/popular_movies.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../screens/movies_details_screen.dart';

class PopularMovies extends StatefulWidget {
  const PopularMovies({Key? key}) : super(key: key);

  @override
  State<PopularMovies> createState() => _PopularMoviesState();
}

class _PopularMoviesState extends State<PopularMovies> {
  String getImagePath(String name) {
    return 'http://image.tmdb.org/t/p/w500/$name';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<PopularMoviesProvider>(context, listen: false)
        .fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PopularMoviesProvider>(
      builder: (context, popularMoviesProvider, _) {
        return SizedBox(
          height: 255,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularMoviesProvider.views.length,
            itemBuilder: (context, index) {
              final topMovies = popularMoviesProvider.views[index];
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
                                    imageUrl: (topMovies.posterPath != null)
                                        ? getImagePath(topMovies.posterPath!)
                                        : "https://cdn-icons-png.flaticon.com/512/15393/15393096.png",
                                    height: 200,
                                    width: 150,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Center(
                                        child: Image.asset('assets/5.png')),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
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
