import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<VideoPlayerPage> createState() => _videoPlayerPageState();
}

// ignore: camel_case_types
class _videoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController controllers;
  @override
  void initState() {
    super.initState();
    controllers = VideoPlayerController.network(widget.url)
      ..initialize().then(
        (value) => setState(() {
          controllers.play();
          controllers.setLooping(true);
        }),
      );
  }

  @override
  void dispose() {
    super.dispose();
    controllers.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          if (controllers.value.isPlaying) {
            controllers.pause();
          } else {
            controllers.play();
          }
        });
      },
      child: Center(
        child: controllers.value.isInitialized
            ? AspectRatio(
                aspectRatio: controllers.value.aspectRatio,
                child: VideoPlayer(controllers),
              )
            : const Center(
                child: CircularProgressIndicator(
                color: Colors.red,
              )),
      ),
    );
  }
}
