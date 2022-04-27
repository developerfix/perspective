import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as getx;
import 'package:preload_page_view/preload_page_view.dart';
import 'package:slant/controller/profileVideoController.dart';
import 'package:slant/controller/video_controller.dart';
import 'package:slant/res.dart';
import 'package:slant/view/widgets/videoWidget.dart';
import "dart:math" show pi;

import '../../../bnb.dart';
import '../../widgets/circularProgress.dart';
import '../videoItem.dart';

class ViewByYouVideo extends StatefulWidget {
  final DocumentSnapshot doc;
  final String? name;
  final String? pictureUrl;

  const ViewByYouVideo(
      {Key? key, this.pictureUrl, this.name, required this.doc})
      : super(key: key);

  @override
  State<ViewByYouVideo> createState() => _ViewByYouVideoState();
}

class _ViewByYouVideoState extends State<ViewByYouVideo>
    with TickerProviderStateMixin {
  bool isLoading = true;
  final ProfileVideoController profileVideoController =
      getx.Get.put(ProfileVideoController());
  final VideoController videoController = getx.Get.put(VideoController());

  updatingVideoUrl() async {
    setState(() {
      isLoading = true;
    });
    await profileVideoController
        .updateVideoUrl((widget.doc.data() as Map)['videoLink']);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    updatingVideoUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? const Center(
              child: CircularProgress(),
            )
          : Scaffold(
              body: getx.GetBuilder<ProfileVideoController>(
                  init: ProfileVideoController(),
                  builder: (controller) {
                    return PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: profileVideoController.profileVideo.length,
                      controller:
                          PageController(initialPage: 0, viewportFraction: 1),
                      // controller: PreloadPageController(initialPage: 1),
                      // preloadPagesCount: 3,
                      itemBuilder: ((context, index) {
                        final data = profileVideoController.profileVideo[index];
                        return VideoWidget(
                            videoController: videoController,
                            video: data,
                            conservative: data.conservative,
                            veryConservative: data.veryConservative,
                            liberal: data.liberal,
                            neutral: data.neutral,
                            veryLiberal: data.veryLiberal,
                            name: data.publisherName,
                            publishersID: data.publisherID,
                            description: data.videoDescription,
                            title: data.videoTitle,
                            videoTag: data.videoTag,
                            videoLink: data.videoLink,
                            profilePic: data.publisherProfilePic,
                            hastags: data.videoHastags,
                            brainOnFireReactions: data.brainOnFireReactions);
                      }),
                    );
                  })),
    );
  }
}
