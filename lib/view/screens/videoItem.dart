import 'dart:async';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:slant/res.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool _showIcon = true;
  IconData icon = Icons.pause_circle;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        Timer(
            const Duration(seconds: 2),
            () => setState(() {
                  _showIcon = false;
                }));
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (videoPlayerController.value.isPlaying) {
          setState(() {
            icon = Icons.play_circle_rounded;
            videoPlayerController.pause();
            _showIcon = true;
          });

          Timer(
              const Duration(seconds: 1),
              () => setState(() {
                    _showIcon = false;
                  }));
        } else {
          if (videoPlayerController.value.position ==
              videoPlayerController.value.duration) {
            videoPlayerController.initialize().then((value) {
              videoPlayerController.play();
            });
          } else {
            setState(() {
              icon = Icons.pause_circle;
              videoPlayerController.play();
              _showIcon = true;
            });

            Timer(
                const Duration(seconds: 1),
                () => setState(() {
                      _showIcon = false;
                    }));
          }
        }
      },
      child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(videoPlayerController)),
              ),
              Positioned.fill(
                  child: _showIcon
                      ? videoPlayerController.value.isPlaying
                          ? Icon(
                              icon,
                              color: const Color(
                                blueColor,
                              ),
                              size: 80,
                            )
                          : Icon(
                              icon,
                              color: const Color(
                                blueColor,
                              ),
                              size: 80,
                            )
                      : Container())
            ],
          )),
    );
  }
}
