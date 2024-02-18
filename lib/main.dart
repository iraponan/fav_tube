import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fav_tube/blocs/bloc_favorite.dart';
import 'package:fav_tube/blocs/bloc_videos.dart';
import 'package:fav_tube/config/api.dart';
import 'package:fav_tube/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  Api api = Api();
  api.search('f1');
  runApp(BlocProvider(
    blocs: [
      Bloc((i) => VideosBloc()),
      Bloc((i) => FavoriteBloc()),
    ],
    dependencies: const [],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  ));
}
