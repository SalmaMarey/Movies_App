import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:films_app/provider/page_view.dart';

import '../screens/movies_details_screen.dart';

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({Key? key}) : super(key: key);

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  late final PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    Provider.of<PageViewProvider>(context, listen: false).fetchViews();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        final int nextPage = (_pageController.page ?? 0).toInt() + 1;
        if (nextPage <
            Provider.of<PageViewProvider>(context, listen: false)
                .views
                .length) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  String getImagePath(String name) {
    return 'http://image.tmdb.org/t/p/w500/$name';
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageViewProvider>(
      builder: (context, pageViewProvider, _) {
        return SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: pageViewProvider.views.length,
            itemBuilder: (BuildContext context, int index) {
              final film = pageViewProvider.views.elementAt(index);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageViewDetsils(
                        film: film,
                        movieId: film.id ?? 0,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (film.posterPath != null)
                      ClipRRect(
                        // borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: (film.posterPath != null)
                              ? getImagePath(film.posterPath!)
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
