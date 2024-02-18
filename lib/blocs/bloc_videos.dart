import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fav_tube/config/api.dart';
import 'package:fav_tube/models/video.dart';

class VideosBloc extends BlocBase {
  late Api api;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  List<Video> videos = [];
  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;

  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  void _search(String search) async {
    videos = await api.search(search);
    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    super.dispose();
    _videosController.close();
    _searchController.close();
  }
}