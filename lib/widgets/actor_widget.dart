import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/movie_cast.dart';
import '../screens/actor_details.dart';

class ActorWidget extends StatefulWidget {
  final int movieId;

  const ActorWidget({Key? key, required this.movieId}) : super(key: key);

  @override
  State<ActorWidget> createState() => _ActorWidgetState();
}

class _ActorWidgetState extends State<ActorWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<MovieCastProvider>(context, listen: false)
        .fetchMovieCredits(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieCastProvider>(
      builder: (context, movieCastProvider, _) {
        final movieCredits = movieCastProvider.cast;

        return SizedBox(
          height: 800,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: movieCredits.length,
            itemBuilder: (context, index) {
              final actor = movieCastProvider.cast.elementAt(index);

              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActorDetails(
                            creditId: actor.creditId ?? 'p', actor: actor),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: actor.profilePath != null
                            ? NetworkImage(
                                'https://image.tmdb.org/t/p/w200${actor.profilePath}')
                            : const AssetImage('assets/3177440.png')
                                as ImageProvider,
                        radius: 40,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        actor.name ?? 'no',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        actor.character ?? 'no',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
