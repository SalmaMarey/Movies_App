import 'package:films_app/widgets/actor_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movies_model.dart';

import '../provider/movie_details.dart';
import '../widgets/stack_details.dart';

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
  @override
  void initState() {
    super.initState();
    Provider.of<PageViewDetailsProvider>(context, listen: false)
        .fetchMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
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
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  expandedHeight: 390,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'movie_${widget.movieId}',
                      child: const StackDetaills(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieDetails.title ?? 'no',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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
                        const Text(
                          'Overview',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          movieDetails.overview ?? 'no',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Cast',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        ActorWidget(movieId: widget.movieId)
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
