import 'package:cached_network_image/cached_network_image.dart';
import 'package:films_app/models/cast_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/actor_details.dart';

class ActorDetails extends StatefulWidget {
  final int creditId;

  const ActorDetails(
      {Key? key, required this.creditId, required CastMovie actor})
      : super(key: key);

  @override
  State<ActorDetails> createState() => _ActorDetailsState();
}

class _ActorDetailsState extends State<ActorDetails> {
  @override
  void initState() {
    super.initState();
    Provider.of<ActorDetailsProvider>(context, listen: false)
        .fetchActorDetails(widget.creditId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        final movieDetails =
            Provider.of<ActorDetailsProvider>(context).castDetails;
        final genres = Provider.of<ActorDetailsProvider>(context).genres;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 390,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (movieDetails.profilePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500/${movieDetails.profilePath}',
                          height: 200,
                          width: 150,
                          fit: BoxFit.fill,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    if (movieDetails.profilePath == null)
                      const Column(
                        children: [
                          SizedBox(height: 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error),
                              SizedBox(width: 5),
                              Text('No actor details available'),
                            ],
                          ),
                        ],
                      ),
                    Text(
                      movieDetails.name ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    });
  }
}
