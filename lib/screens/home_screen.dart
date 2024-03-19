import 'package:flutter/material.dart';

import '../widgets/page_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.menu),
            SizedBox(
              width: 100,
            ),
            Text(
              'Movies App',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: ListView(children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageViewWidget(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Top Rated Movies',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            )
          ],
        )
      ]),
    );
  }
}
