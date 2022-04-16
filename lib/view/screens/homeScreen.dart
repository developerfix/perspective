import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:slant/controller/video_controller.dart';
import 'package:slant/res.dart';
import "dart:math" show pi;

import '../widgets/circularProgress.dart';

class HomeScreen extends StatefulWidget {
  final XFile? file;

  const HomeScreen({Key? key, this.file}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin<HomeScreen> {
  final VideoPlayerController? _controller =
      VideoPlayerController.asset('assets/images/placeholder.png');
  bool isFavourite = false;
  bool _isPlaying = false;
  bool seeMore = false;
  bool isbrainOnFire = false;
  List<dynamic> topicsOfInterest = [];
  var homeScreenVideos = [];
  bool isLoading = false;

  var myidentityLiberalDoc = FirebaseFirestore.instance
      .collectionGroup(liberal)
      .orderBy(FieldPath.documentId)
      .startAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path
  ]).endAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path +
        "\uf8ff"
  ]);

  var myidentityNeutralDoc = FirebaseFirestore.instance
      .collectionGroup(neutral)
      .orderBy(FieldPath.documentId)
      .startAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path
  ]).endAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path +
        "\uf8ff"
  ]);

  var myidentityVeryLiberalDoc = FirebaseFirestore.instance
      .collectionGroup(veryLiberal)
      .orderBy(FieldPath.documentId)
      .startAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path
  ]).endAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path +
        "\uf8ff"
  ]);

  var myidentityConservativeDoc = FirebaseFirestore.instance
      .collectionGroup(conservative)
      .orderBy(FieldPath.documentId)
      .startAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path
  ]).endAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path +
        "\uf8ff"
  ]);

  var myidentityVeryConservativeDoc = FirebaseFirestore.instance
      .collectionGroup(veryConservative)
      .orderBy(FieldPath.documentId)
      .startAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path
  ]).endAt([
    FirebaseFirestore.instance.collection("videos").doc(myIdentity).path +
        "\uf8ff"
  ]);

  final PageController _pageController = PageController(initialPage: 0);

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> getVideos() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collectionGroup(veryConservative)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(howSocietyAroundMeFunctions)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(whatsHappeningAroundTheWorld)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            homeScreenVideos.add((doc));
          }
        });
    await FirebaseFirestore.instance
        .collectionGroup(conservative)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(howSocietyAroundMeFunctions)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(whatsHappeningAroundTheWorld)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            homeScreenVideos.add((doc));
          }
        });
    await FirebaseFirestore.instance
        .collectionGroup(neutral)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(howSocietyAroundMeFunctions)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(whatsHappeningAroundTheWorld)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            homeScreenVideos.add((doc));
          }
        });
    await FirebaseFirestore.instance
        .collectionGroup(liberal)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(howSocietyAroundMeFunctions)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(whatsHappeningAroundTheWorld)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            homeScreenVideos.add((doc));
          }
        });
    await FirebaseFirestore.instance
        .collectionGroup(veryLiberal)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(howSocietyAroundMeFunctions)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(whatsHappeningAroundTheWorld)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            homeScreenVideos.add((doc));
          }
        });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgress(),
            )
          : PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: homeScreenVideos.length,
              // controller: PreloadPageController(initialPage: 1),
              // preloadPagesCount: 3,
              itemBuilder: ((context, index) {
                final item = homeScreenVideos[index];
                return SizedBox(
                  height: screenHeight(context) * 0.5,
                  width: screenWidth(context),
                  child: videosWidget(
                    context,
                    name: item['publisherName'],
                    description: item['videoDescription'],
                    topic: item['videoTopic'],
                    videoTag: item['videoTag'],
                    videoLink: item['videoLink'],
                    // profilePic: item['publisherProfilePic']
                  ),
                );
              }),
            ),
    );
  }

  SizedBox videosWidget(
    BuildContext context, {
    String? name,
    String? profilePic,
    String? description,
    String? topic,
    String? videoTag,
    List<String>? hastags,
    String? videoLink,
  }) {
    return SizedBox(
      height: screenHeight(context),
      child: Stack(
        children: [
          Positioned.fill(
              child: videoLink != null
                  ? AspectRatioVideo(videoLink, _controller!)
                  : Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.fitHeight,
                    )),
          Transform.rotate(
            angle: 180.0 * pi / 180,
            child: Container(
              height: screenHeight(context) * 0.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF8B7070),
                    Colors.black.withOpacity(0.0),
                    Colors.white
                  ],
                  stops: const [0.0, 0.0, 1.0],
                ),
              ),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       if (_controller!.value.isPlaying) {
          //         _controller!.pause();
          //         Timer(
          //             const Duration(seconds: 2),
          //             () => setState(() {
          //                   _isPlaying = false;
          //                 }));
          //       } else {
          //         _controller!.play();
          //         setState(() {
          //           _isPlaying = true;
          //         });
          //       }
          //     });
          //   },
          //   child: Align(
          //       alignment: Alignment.center,
          //       child: _controller!.value.isPlaying
          //           ? _isPlaying
          //               ? const Icon(
          //                   Icons.pause_circle,
          //                   color: Color(
          //                     blueColor,
          //                   ),
          //                   size: 80,
          //                 )
          //               : Container()
          //           : const Icon(
          //               Icons.play_circle_rounded,
          //               color: Color(
          //                 blueColor,
          //               ),
          //               size: 80,
          //             )),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.rotate(
              angle: 180 * pi / 180,
              child: Container(
                height: screenHeight(context) * 0.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFF8B7070),
                      Colors.black.withOpacity(0.0),
                      Colors.white
                    ],
                    stops: const [0.0, 0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SizedBox(
                  width: screenWidth(context) * 0.95,
                  height: seeMore
                      ? screenHeight(context) * 0.25
                      : screenHeight(context) * 0.22,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: screenWidth(context) * 0.13,
                            height: screenHeight(context) * 0.06,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        isbrainOnFire = !isbrainOnFire;
                                      });
                                    },
                                    child: isbrainOnFire
                                        ? SvgPicture.asset(
                                            'assets/svgs/brainOnFire.svg')
                                        : SvgPicture.asset(
                                            'assets/svgs/brain.svg')),
                                txt(
                                    txt: '26',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontColor: isbrainOnFire
                                        ? const Color(blueColor)
                                        : Colors.white)
                              ],
                            ),
                          ),
                          SvgPicture.asset('assets/svgs/slant.svg'),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  // profilePic == null
                                  //     ?
                                  AssetImage('assets/images/girl.png')
                              // : NetworkImage(profilePic) as ImageProvider,
                              ),
                          SizedBox(
                            width: screenWidth(context) * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                txt(
                                  maxLines: 1,
                                  txt: '$name perspective on',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  height: seeMore
                                      ? screenHeight(context) * 0.055
                                      : screenHeight(context) * 0.015,
                                  child: Row(
                                    crossAxisAlignment: seeMore
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: AnimatedSize(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: AutoSizeText(
                                            description!,
                                            maxLines: seeMore ? 5 : 1,
                                            maxFontSize: 10,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: seeMore ? 5 : 8,
                                            style: const TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      description.length == 20
                                          ? seeMore
                                              ? GestureDetector(
                                                  child: txt(
                                                    txt: 'see less',
                                                    fontSize: 10,
                                                    fontColor:
                                                        const Color(blueColor),
                                                  ),
                                                  onTap: () => setState(
                                                      () => seeMore = false))
                                              : GestureDetector(
                                                  child: txt(
                                                    txt: 'see more',
                                                    fontSize: 10,
                                                    fontColor:
                                                        const Color(blueColor),
                                                  ),
                                                  onTap: () => setState(
                                                      () => seeMore = true))
                                          : Container(),
                                    ],
                                  ),
                                ),
                                txt(
                                    maxLines: 1,
                                    txt: '#$topic',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontColor: const Color(blueColor)),
                                txt(
                                    maxLines: 1,
                                    txt: '#Being $videoTag',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontColor: const Color(blueColor))
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(children: [
                                txt(
                                  txt: '37%',
                                  fontColor: const Color(blueColor),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                txt(
                                    txt: ' audience labelled this video as ',
                                    fontWeight: FontWeight.bold,
                                    fontColor: Colors.black45,
                                    fontSize: 12),
                                txt(
                                  txt: '#very liberal',
                                  fontColor: const Color(blueColor),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ]),
                              txt(
                                txt: 'What do you think?',
                                fontColor: const Color(blueColor),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ],
                          ),
                          const Spacer(),
                          PopupMenuButton(
                              // offset: const Offset(0, -250),
                              color: const Color(blueColor),
                              onSelected: (value) {
                                // selectedValue(value);
                              },
                              elevation: 3.2,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: SvgPicture.asset(
                                  'assets/svgs/microphone.svg'),
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: popupmenuItem(
                                            'Very Conservative', '3%'),
                                      ),
                                      value: 1,
                                    ),
                                    PopupMenuItem(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child:
                                            popupmenuItem('Conservative', '3%'),
                                      ),
                                      value: 2,
                                    ),
                                    PopupMenuItem(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: popupmenuItem('Neutral', '3%'),
                                      ),
                                      value: 3,
                                    ),
                                    PopupMenuItem(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: popupmenuItem('Liberal', '3%'),
                                      ),
                                      value: 4,
                                    ),
                                    PopupMenuItem(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child:
                                            popupmenuItem('Very Liberal', '3%'),
                                      ),
                                      value: 5,
                                    ),
                                  ]),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                SvgPicture.asset('assets/svgs/share.svg'),
                SizedBox(
                  width: screenWidth(context) * 0.03,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isFavourite = !isFavourite;
                    });
                  },
                  child: SizedBox(
                    height: screenHeight(context) * 0.04,
                    child: isFavourite
                        ? const Icon(
                            Icons.favorite,
                            color: Color(redColor),
                            size: 30,
                          )
                        : SvgPicture.asset('assets/svgs/heart.svg'),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

Row popupmenuItem(String? itemText, String? itemPercentage) {
  return Row(
    children: [
      txt(txt: itemText, fontSize: 12, fontColor: Colors.white),
      const Spacer(),
      Container(
        width: 24.0,
        height: 24.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: txt(
              txt: itemPercentage,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontColor: const Color(blueColor)),
        ),
      )
    ],
  );
}
