// ignore_for_file: avoid_print

import 'dart:io';

import 'package:films_app/models/cast_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieCastProvider extends ChangeNotifier {
  late List<CastMovie> _cast = [];

  List<CastMovie> get cast => _cast;

  Future<void> fetchMovieCredits(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits'),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYTMwMWNmOGMyNTI4ZGUwYjViNDU3NGYzMmZjNjY1YSIsInN1YiI6IjVmMDQzOGQ0OGEwZTliMDAzNjlhMjg0ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.UZ-QUPkO4P_79XS3p2p5Rfmfr9vWD63_1kcvR6wTf_I',
        },
      );
      // print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> castList = responseBody['cast'];
        _cast = castList.map((item) => CastMovie.fromJson(item)).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load movie credits');
      }
    } catch (e) {
      print('Error fetching movie credits: $e');
      rethrow;
    }
  }
}
