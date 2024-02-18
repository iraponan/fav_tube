import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((value) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data?[index]),
                  leading: const Icon(Icons.play_arrow),
                  onTap: () {
                    close(context, snapshot.data?[index]);
                  },
                );
              },
              itemCount: snapshot.data?.length,
            );
          }
        },
      );
    }
  }

  @override
  String get searchFieldLabel => 'Pesquisar por...';

  Future<List> suggestions(String search) async {
    Uri suggestions = Uri(
        scheme: 'http',
        host: 'suggestqueries.google.com',
        path: '/complete/search',
        queryParameters: {
          'hl': 'br',
          'ds': 'yt',
          'client': 'youtube',
          'hjson': 't',
          'cp': '1',
          'q': search,
          'format': '5',
          'alt': 'json'
        });

    http.Response response = await http.get(suggestions);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)[1].map((value) {
        return value[0];
      }).toList();
    } else {
      throw Exception('Falha ao ler as sugestões');
    }
  }
}
