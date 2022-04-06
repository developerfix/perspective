import 'dart:io';

import 'package:flutter/material.dart';
import 'package:slant/bnb.dart';
import 'package:slant/res.dart';
import 'package:slant/view/screens/homeScreen.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

// class VideoCapture extends StatefulWidget {
//   @override
//   State<VideoCapture> createState() => _VideoCaptureState();
// }

// class _VideoCaptureState extends State<VideoCapture> {
//   final ImagePicker _picker = ImagePicker();
//   VideoPlayerController? _controller;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Flutter Video Capture"),
//       ),
//       body: Column(
//         children: [
//           IconButton(
//             onPressed: () async {
//               final XFile? file = await _picker.pickVideo(
//                   source: ImageSource.camera,
//                   maxDuration: const Duration(minutes: 2));
//               setState(() {});
//               _playVideo(file);
//               print("Video Path ${file!.path}");
//               _controller ??
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (ctx) => BNB(
//                                 controller: _controller,
//                               )));
//             },
//             icon: const Icon(
//               Icons.video_call_rounded,
//             ),
//           ),
//           // _previewVideo(),
//         ],
//       ),
//     );
//   }

//   // Widget _previewVideo() {
//   //   if (_controller == null) {
//   //     return const Text(
//   //       'You have not yet picked a video',
//   //       textAlign: TextAlign.center,
//   //     );
//   //   }
//   //   return navigator(
//   //       function: HomeScreen(
//   //     controller: _controller,
//   //   ));
//   // }

//   Future<void> _playVideo(XFile? file) async {
//     if (file != null && mounted) {
//       print("Loading Video");
//       await _disposeVideoController();
//       late VideoPlayerController controller;
//       /*if (kIsWeb) {
//         controller = VideoPlayerController.network(file.path);
//       } else {*/
//       controller = VideoPlayerController.file(File(file.path));
//       //}
//       _controller = controller;
//       // In web, most browsers won't honor a programmatic call to .play
//       // if the video has a sound track (and is not muted).
//       // Mute the video so it auto-plays in web!
//       // This is not needed if the call to .play is the result of user
//       // interaction (clicking on a "play" button, for example).

//       //await controller.setVolume(volume);
//       await controller.initialize();
//       await controller.setLooping(true);
//       await controller.play();
//       setState(() {});
//     } else {
//       print("Loading Video error");
//     }
//   }

//   Future<void> _disposeVideoController() async {
//     /*  if (_toBeDisposed != null) {
//       await _toBeDisposed!.dispose();
//     }
//     _toBeDisposed = _controller;*/
//     _controller = null;
//   }
// }

class AspectRatioVideo extends StatefulWidget {
  final VideoPlayerController? controller;

  // ignore: use_key_in_widget_constructors
  const AspectRatioVideo(this.controller);

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!));
    } else {
      return Container();
    }
  }
}
