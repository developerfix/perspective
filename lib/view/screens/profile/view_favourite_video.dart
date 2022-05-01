import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:slant/controller/profile_video_controller.dart';
import 'package:slant/controller/video_controller.dart';
import 'package:slant/view/widgets/video_widget.dart';

import '../../widgets/circular_progress.dart';

class ViewFavouriteVideo extends StatefulWidget {
  final DocumentSnapshot doc;

  const ViewFavouriteVideo({Key? key, required this.doc}) : super(key: key);

  @override
  State<ViewFavouriteVideo> createState() => _ViewFavouriteVideoState();
}

class _ViewFavouriteVideoState extends State<ViewFavouriteVideo>
    with TickerProviderStateMixin {
  bool isLoading = true;
  final ProfileVideoController profileVideoController =
      getx.Get.put(ProfileVideoController());

  final VideoController videoController = getx.Get.put(VideoController());

  updatingFavouriteVideoUrl() async {
    setState(() {
      isLoading = true;
    });
    await profileVideoController
        .updateFavouriteVideoUrl((widget.doc.data() as Map)['videoLink']);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    updatingFavouriteVideoUrl();
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
                      itemCount: profileVideoController.favouriteVideo.length,
                      controller:
                          PageController(initialPage: 0, viewportFraction: 1),
                      itemBuilder: ((context, index) {
                        final data =
                            profileVideoController.favouriteVideo[index];
                        return VideoWidget(
                            videoController: videoController,
                            topic: data.videoTopic,
                            video: data,
                            name: data.publisherName,
                            conservative: data.conservative,
                            veryConservative: data.veryConservative,
                            liberal: data.liberal,
                            neutral: data.neutral,
                            veryLiberal: data.veryLiberal,
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
