// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/movies_model.dart';

class PopularMoviesProvider extends ChangeNotifier {
  List<Results> _views = [];
  List<Results> get views => _views;

  Future<void> fetchPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/popular'),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYTMwMWNmOGMyNTI4ZGUwYjViNDU3NGYzMmZjNjY1YSIsInN1YiI6IjVmMDQzOGQ0OGEwZTliMDAzNjlhMjg0ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.UZ-QUPkO4P_79XS3p2p5Rfmfr9vWD63_1kcvR6wTf_I',
        },
      );
      // print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic>? viewList = responseBody['results'];

        if (viewList != null) {
          _views = viewList.map((json) => Results.fromJson(json)).toList();

          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
