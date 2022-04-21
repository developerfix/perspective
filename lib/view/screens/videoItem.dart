import 'dart:async';
import 'dart:io';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:slant/bnb.dart';
import 'package:slant/res.dart';
import 'package:slant/view/screens/homeScreen.dart';
import 'package:slant/view/widgets/circularProgress.dart';
import 'package:image_picker/image_picker.dart';

class AspectRatioVideo extends StatefulWidget {
  final String? videoUrl;
  VideoPlayerController controller;

  AspectRatioVideo(this.videoUrl, this.controller, {Key? key})
      : super(key: key);

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    widget.controller = VideoPlayerController.network(widget.videoUrl!)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..setLooping(false)
      ..initialize().then((value) =>
          widget.controller.play().then((value) => _isPlaying = true));
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.value.isInitialized
        ?
        // Stack(
        //     children: [
        AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: VideoPlayer(widget.controller))
        //   Align(
        //     alignment: Alignment.center,
        //     child: GestureDetector(
        //         onTap: () {
        //           if (widget.controller.value.isPlaying) {
        //             widget.controller.pause();
        //             // Timer(
        //             //     const Duration(seconds: 2),
        //             //     () => setState(() {
        //             //           _isPlaying = false;
        //             //         }));
        //           } else {
        //             widget.controller.play();
        //             _isPlaying = true;
        //             // setState(() {

        //             // });
        //           }
        //         },
        //         child: widget.controller.value.isPlaying
        //             ? _isPlaying
        //                 ? const Icon(
        //                     Icons.pause_circle,
        //                     color: Color(
        //                       blueColor,
        //                     ),
        //                     size: 80,
        //                   )
        //                 : Container()
        //             : const Icon(
        //                 Icons.play_circle_rounded,
        //                 color: Color(
        //                   blueColor,
        //                 ),
        //                 size: 80,
        //               )),
        //   )
        // ],
        // )
        : const Center(
            child: CircularProgress(),
          );
  }
}

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

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
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

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: VideoPlayer(videoPlayerController),
    );
  }
}
