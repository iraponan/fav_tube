import 'dart:convert';

import 'package:fav_tube/config/api_key.dart';
import 'package:fav_tube/models/video.dart';
import 'package:http/http.dart' as http;

class Api {
  String _search = '';
  String _nextToken = '';

  Future<List<Video>> search(String search) async {
    _search = search;
    Uri searchUri = Uri(
        scheme: 'https',
        host: 'www.googleapis.com',
        path: '/youtube/v3/search',
        queryParameters: {
          'part': 'snippet',
          'q': search,
          'type': 'video',
          'key': API_KEY,
          'maxResults': '10'
        });
    http.Response response = await http.get(searchUri);
    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    Uri searchNextPageUri = Uri(
        scheme: 'https',
        host: 'www.googleapis.com',
        path: '/youtube/v3/search',
        queryParameters: {
          'part': 'snippet',
          'q': _search,
          'type': 'video',
          'key': API_KEY,
          'maxResults': '10',
          'pageToken': _nextToken
        });
    http.Response response = await http.get(searchNextPageUri);
    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      _nextToken = decoded['nextPageToken'];

      List<Video> videos = decoded['items'] != null ? decoded['items'].map<Video>((map) {
        return Video.fromJson(map);
      }).toList() : [];
      return videos;
    } else {
      throw Exception('Falha ao carregar os videos.');
    }
  }
}
