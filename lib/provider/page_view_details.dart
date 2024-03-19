// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/page_view_model.dart';

class PageViewDetailsProvider extends ChangeNotifier {
  late Results _movieDetails = Results();
  late List<Map<String, dynamic>> _genres = [];

  Results get movieDetails => _movieDetails;
  List<Map<String, dynamic>> get genres => _genres;

  Future<void> fetchMovieDetails(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/$movieId'),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYTMwMWNmOGMyNTI4ZGUwYjViNDU3NGYzMmZjNjY1YSIsInN1YiI6IjVmMDQzOGQ0OGEwZTliMDAzNjlhMjg0ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.UZ-QUPkO4P_79XS3p2p5Rfmfr9vWD63_1kcvR6wTf_I',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        _movieDetails = Results.fromJson(responseBody);

        final List<dynamic> genresData = responseBody['genres'] ?? [];
        _genres =
            genresData.map((genre) => genre as Map<String, dynamic>).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
      rethrow;
    }
  }
}
