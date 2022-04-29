import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:slant/controller/profile_video_controller.dart';
import 'package:slant/controller/video_controller.dart';

import '../../widgets/circular_progress.dart';
import 'package:slant/view/widgets/video_widget.dart';

class ViewRequestVideo extends StatefulWidget {
  final Map? videoDetail;
  const ViewRequestVideo({Key? key, this.videoDetail}) : super(key: key);

  @override
  State<ViewRequestVideo> createState() => _ViewRequestVideoState();
}

class _ViewRequestVideoState extends State<ViewRequestVideo>
    with TickerProviderStateMixin {
  bool isLoading = true;
  final ProfileVideoController profileVideoController =
      getx.Get.put(ProfileVideoController());
  final VideoController videoController = getx.Get.put(VideoController());

  updatingRequestVideoUrl() async {
    setState(() {
      isLoading = true;
    });
    await profileVideoController
        .updateRequestVideoUrl(widget.videoDetail!['videoLink']);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    updatingRequestVideoUrl();
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
                      itemCount: profileVideoController.requestVideo.length,
                      controller:
                          PageController(initialPage: 0, viewportFraction: 1),
                      itemBuilder: ((context, index) {
                        final data = profileVideoController.requestVideo[index];
                        return VideoWidget(
                            videoController: videoController,
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
