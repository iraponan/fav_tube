import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fav_tube/blocs/bloc_favorite.dart';
import 'package:fav_tube/models/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatelessWidget {
  final Video video;

  const VideoPlayer({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final youTubeController = YoutubePlayerController(
      initialVideoId: video.id,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        loop: false,
      ),
    );

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: youTubeController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
            playedColor: Colors.red, handleColor: Colors.white70),
        aspectRatio: 16.0 / 9.0,
        topActions: [
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Text(
              youTubeController.metadata.title,
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
          ),
        ],
      ),
      builder: (BuildContext context, Widget player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Video Player'),
            centerTitle: true,
            elevation: 0,
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
              StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, Video>> snapshot) {
                  if (snapshot.hasData) {
                    return IconButton(
                      onPressed: () {
                        BlocProvider.getBloc<FavoriteBloc>()
                            .toggleFavorite(video);
                      },
                      icon: Icon(
                        snapshot.data!.containsKey(video.id)
                            ? Icons.star
                            : Icons.star_border,
                        color: snapshot.data!.containsKey(video.id)
                            ? Colors.yellowAccent
                            : Colors.white,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
          body: ListView(
            children: [
              player,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Título: ',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      video.title,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),
                    const Divider(
                      color: Colors.black87,
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 26,
                          color: Colors.black87,
                        ),
                        Text(
                          video.channel,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
