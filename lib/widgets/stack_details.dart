import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/page_view_details.dart';

class StackDetaills extends StatelessWidget {
  const StackDetaills({super.key});

  @override
  Widget build(BuildContext context) {
    String getImagePath(String name) {
      return 'http://image.tmdb.org/t/p/w500/$name';
    }

    return Scaffold(body: Consumer<PageViewDetailsProvider>(
        builder: (context, pageViewDetailsProvider, _) {
      final movieDetails = pageViewDetailsProvider.movieDetails;
      return SizedBox(
        height: 400,
        child: Stack(
          children: [
            if (movieDetails.posterPath != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: getImagePath(movieDetails.posterPath!),
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            if (movieDetails.posterPath == null)
              const Column(
                children: [
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error),
                      SizedBox(width: 5),
                      Text('Image not available')
                    ],
                  ),
                ],
              ),
            Positioned(
              left: 20,
              top: 305,
              child: Container(
                width: 390,
                height: 90,
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(7)),
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
          ],
        ),
      );
    }));
  }
}
