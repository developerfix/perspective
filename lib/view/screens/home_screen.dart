import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:slant/controller/video_controller.dart';

import 'package:slant/view/widgets/video_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin<HomeScreen> {
  final VideoController videoController = getx.Get.put(VideoController());
  bool isFavourite = false;
  bool seeMore = false;
  bool isbrainOnFire = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getx.Obx(() {
      return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videoController.homeScreenVideosList.length,
        controller: PageController(initialPage: 0, viewportFraction: 1.0),
        itemBuilder: ((context, index) {
          final data = videoController.homeScreenVideosList[index];

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
    }));
  }
}
