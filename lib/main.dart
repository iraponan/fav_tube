import 'package:fav_tube/config/api.dart';
import 'package:fav_tube/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  Api api = Api();
  api.search('f1');
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

