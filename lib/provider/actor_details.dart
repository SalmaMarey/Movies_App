// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cast_model.dart';

class ActorDetailsProvider extends ChangeNotifier {
  late CastMovie _castDetails = CastMovie();
  // late List<Map<String, dynamic>> _genres = [];
  // List<Map<String, dynamic>> get genres => _genres;
  CastMovie get castDetails => _castDetails;

  Future<void> fetchActorDetails(String creditId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/credit/$creditId'),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYTMwMWNmOGMyNTI4ZGUwYjViNDU3NGYzMmZjNjY1YSIsInN1YiI6IjVmMDQzOGQ0OGEwZTliMDAzNjlhMjg0ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.UZ-QUPkO4P_79XS3p2p5Rfmfr9vWD63_1kcvR6wTf_I',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        _castDetails = CastMovie.fromJson(responseBody["person"]);
        // final List<dynamic> genresData = responseBody['genres'] ?? [];
        // _genres =
        // genresData.map((genre) => genre as Map<String, dynamic>).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching actor details: $e');
      rethrow;
    }
  }
}
