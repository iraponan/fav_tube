import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fav_tube/blocs/bloc_favorite.dart';
import 'package:fav_tube/blocs/bloc_videos.dart';
import 'package:fav_tube/data/data_search.dart';
import 'package:fav_tube/models/video.dart';
import 'package:fav_tube/widgets/video_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: Image.asset('assets/images/youtube.png'),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
              initialData: const {},
              builder: (BuildContext context, AsyncSnapshot<Map<String, Video>> snapshot) {
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
              }
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star),
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () async {
              String? result = await showSearch(
                context: context,
                delegate: DataSearch(),
              );
              if (result != null) {
                BlocProvider.getBloc<VideosBloc>().inSearch.add(result);
              }
            },
            icon: const Icon(Icons.search),
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: BlocProvider.getBloc<VideosBloc>().outVideos,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(
                    video: snapshot.data[index],
                  );
                } else if (index > 1) {
                  BlocProvider.getBloc<VideosBloc>().inSearch.add('');
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: snapshot.data.length + 1,
            );
          } else {
            return Container();
          }
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
