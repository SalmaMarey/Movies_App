import 'package:cached_network_image/cached_network_image.dart';
import 'package:films_app/widgets/actor_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movies_model.dart';

import '../provider/movie_details.dart';

class PageViewDetsils extends StatefulWidget {
  final int movieId;

  const PageViewDetsils({
    Key? key,
    required this.movieId,
    required Results film,
  }) : super(key: key);

  @override
  State<PageViewDetsils> createState() => _PageViewDetsilsState();
}

class _PageViewDetsilsState extends State<PageViewDetsils> {
  Color getRateBackgroundColor(double rate) {
    if (rate < 5.0) {
      return Colors.red;
    } else if (rate < 6.8) {
      return Colors.purple;
    } else if (rate < 7.3) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<PageViewDetailsProvider>(context, listen: false)
        .fetchMovieDetails(widget.movieId);
  }

  String getImagePath(String name) {
    return 'http://image.tmdb.org/t/p/w500/$name';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final movieDetails =
                Provider.of<PageViewDetailsProvider>(context).movieDetails;
            final genres = Provider.of<PageViewDetailsProvider>(context).genres;

            return CustomScrollView(
              slivers: [
                if (movieDetails!.posterPath != null)
                  SliverAppBar(
                    snap: false,
                    pinned: false,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 250,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: 'movie_${widget.movieId}',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: (movieDetails.posterPath != null)
                                ? getImagePath(movieDetails.posterPath!)
                                : "https://cdn-icons-png.flaticon.com/512/15393/15393096.png",
                            height: 350,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size(double.infinity, 250),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Container(
                          width: 390,
                          // height: 90,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                            color: Color.fromARGB(255, 61, 61, 61),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      movieDetails.releaseDate ?? 'no',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Release Date',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      movieDetails.popularity.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Popularity',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 35,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: getRateBackgroundColor(
                                            movieDetails.voteAverage ?? 0.0),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Center(
                                          child: Text(
                                            movieDetails.voteAverage.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Rate',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          movieDetails.title ?? 'no',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: genres.map((genre) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                genre['name'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Overview',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          movieDetails.overview ?? 'no',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Cast',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      ActorWidget(movieId: widget.movieId)
                    ],
                  ),
                ),
              ],
            );
          }
        },
        future: null,
      ),
    );
  }
}
