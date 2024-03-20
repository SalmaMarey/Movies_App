// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/movies_model.dart';

class TopRatedMoviesProvider extends ChangeNotifier {
  List<Results> _movies = [];
  List<Results> get movies => _movies;

  Future<void> fetchMovies() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/top_rated'),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYTMwMWNmOGMyNTI4ZGUwYjViNDU3NGYzMmZjNjY1YSIsInN1YiI6IjVmMDQzOGQ0OGEwZTliMDAzNjlhMjg0ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.UZ-QUPkO4P_79XS3p2p5Rfmfr9vWD63_1kcvR6wTf_I',
        },
      );
      // print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic>? movieList = responseBody['results'];

        if (movieList != null) {
          _movies = movieList.map((json) => Results.fromJson(json)).toList();

          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
