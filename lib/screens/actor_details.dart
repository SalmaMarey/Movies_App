import 'package:cached_network_image/cached_network_image.dart';
import 'package:films_app/models/cast_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/actor_details.dart';

class ActorDetails extends StatefulWidget {
  final String creditId;

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
            final castDetails =
                Provider.of<ActorDetailsProvider>(context).castDetails;
            // final genres = Provider.of<ActorDetailsProvider>(context).genres;

            return CustomScrollView(
              slivers: [
                if (castDetails.profilePath != null)
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: 300,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            // bottomLeft: Radius.circular(20),
                            ),
                        child: CachedNetworkImage(
                          imageUrl: (castDetails.profilePath != null)
                              ? getImagePath(castDetails.profilePath!)
                              : "https://cdn-icons-png.flaticon.com/512/15393/15393096.png",
                          height: 250,
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          castDetails.name ?? 'no',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(255, 61, 61, 61),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              const Text(
                                'Popularity',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                castDetails.popularity.toString(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text('There is no other information')
                      ],
                    ),
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
