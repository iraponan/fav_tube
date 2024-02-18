import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fav_tube/blocs/bloc_videos.dart';
import 'package:fav_tube/data/data_search.dart';
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
          const Align(
            alignment: Alignment.center,
            child: Text(
              '0',
              style: TextStyle(
                color: Colors.white,
              ),
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
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return VideoTile(
                  video: snapshot.data[index],
                );
              },
              itemCount: snapshot.data.length,
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
