import 'dart:async';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fav_tube/config/api.dart';
import 'package:fav_tube/models/video.dart';

class VideoBloc implements BlocBase {
  final Api api;

  VideoBloc({required this.api}) {
    _searchController.stream.listen(_search);
  }

  List<Video> videos = [];
  final StreamController _videosController = StreamController();
  Stream get outVideos => _videosController.stream;

  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }


  void _search(String search) async {
    videos = await api.search(search);
  }
}