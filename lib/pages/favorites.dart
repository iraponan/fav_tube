import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fav_tube/blocs/bloc_favorite.dart';
import 'package:fav_tube/config/video_player.dart';
import 'package:fav_tube/models/video.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, Video>> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data?.length}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star),
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
        initialData: const {},
        builder:
            (BuildContext context, AsyncSnapshot<Map<String, Video>> snapshot) {
          return ListView(
            children: snapshot.data!.values.map((video) {
              return InkWell(
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: Image.network(video.thumb),
                    ),
                    Expanded(
                      child: Text(
                        video.title,
                        style: const TextStyle(color: Colors.white70),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(video: video),
                    ),
                  );
                },
                onLongPress: () {
                  BlocProvider.getBloc<FavoriteBloc>().toggleFavorite(video);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
