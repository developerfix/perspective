import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:slant/controller/video_controller.dart';
import 'package:slant/res.dart';
import "dart:math" show pi;

import '../../widgets/circularProgress.dart';
import '../videoItem.dart';

class VideoList extends StatefulWidget {
  final String? topicName;
  const VideoList({
    Key? key,
    this.topicName,
  }) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> with TickerProviderStateMixin {
  final VideoPlayerController? _controller =
      VideoPlayerController.asset('assets/images/placeholder.png');
  bool isFavourite = false;
  bool _isPlaying = false;
  bool seeMore = false;
  bool isbrainOnFire = false;
  List<dynamic> topicsOfInterest = [];
  var veryConservativeVideos = [];
  var conservativeVideos = [];
  var neutralVideos = [];
  var liberalVideos = [];
  var veryLiberalVideos = [];
  List<dynamic>? hastagsList = [];

  bool isVeryConservativeVideosLoading = false;
  bool isConservativeVideosLoading = false;
  bool isNeutralVideosLoading = false;
  bool isLiberalVideosLoading = false;
  bool isVeryLiberalVideosLoading = false;

  final PageController _pageController = PageController(initialPage: 0);

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> getVeryConservativeVideos() async {
    setState(() {
      isVeryConservativeVideosLoading = true;
    });
    await FirebaseFirestore.instance
        .collectionGroup(veryConservative)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(widget.topicName)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(widget.topicName)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            veryConservativeVideos.add((doc.data()));
          }
        });

    setState(() {
      isVeryConservativeVideosLoading = false;
    });
  }

  Future<void> getConservativeVideos() async {
    setState(() {
      isConservativeVideosLoading = true;
    });
    await FirebaseFirestore.instance
        .collectionGroup(conservative)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(widget.topicName)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(widget.topicName)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            conservativeVideos.add((doc.data()));
          }
        });

    setState(() {
      isConservativeVideosLoading = false;
    });
  }

  Future<void> getNeutralVideos() async {
    setState(() {
      isNeutralVideosLoading = true;
    });
    await FirebaseFirestore.instance
        .collectionGroup(neutral)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(widget.topicName)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(widget.topicName)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            neutralVideos.add((doc.data()));
          }
        });

    setState(() {
      isNeutralVideosLoading = false;
    });
  }

  Future<void> getLiberalVideos() async {
    setState(() {
      isLiberalVideosLoading = true;
    });
    await FirebaseFirestore.instance
        .collectionGroup(liberal)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(widget.topicName)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(widget.topicName)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            liberalVideos.add((doc.data()));
          }
        });

    setState(() {
      isLiberalVideosLoading = false;
    });
  }

  Future<void> getVeryLiberalVideos() async {
    setState(() {
      isVeryLiberalVideosLoading = true;
    });
    await FirebaseFirestore.instance
        .collectionGroup(veryLiberal)
        .orderBy(FieldPath.documentId)
        .startAt([
          FirebaseFirestore.instance
              .collection("videos")
              .doc(widget.topicName)
              .path
        ])
        .endAt([
          FirebaseFirestore.instance
                  .collection("videos")
                  .doc(widget.topicName)
                  .path +
              "\uf8ff"
        ])
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            veryLiberalVideos.add((doc.data()));
          }
        });

    setState(() {
      isVeryLiberalVideosLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getVeryConservativeVideos();
    getConservativeVideos();
    getNeutralVideos();
    getLiberalVideos();
    getVeryLiberalVideos();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          body: SizedBox(
            height: screenHeight(context),
            width: screenWidth(context),
            child: Column(children: [
              Container(
                height: screenHeight(context) * 0.08,
                color: const Color(0xFF080808),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      SizedBox(
                        width: screenWidth(context) * 0.7,
                        child: AutoSizeText(
                          'Perspectives on ${widget.topicName}',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          maxFontSize: 14,
                          minFontSize: 8,
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth(context) * 0.005,
                      )
                    ],
                  ),
                ),
              ),
              TabBar(
                isScrollable: true,
                indicatorColor: const Color(blueColor).withOpacity(0.5),
                tabs: [
                  Tab(icon: txt(txt: veryConservative, fontSize: 14)),
                  Tab(icon: txt(txt: conservative, fontSize: 14)),
                  Tab(icon: txt(txt: neutral, fontSize: 14)),
                  Tab(icon: txt(txt: liberal, fontSize: 14)),
                  Tab(icon: txt(txt: veryLiberal, fontSize: 14)),
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  listOfVideos(
                      list: veryConservativeVideos,
                      videoLoader: isVeryConservativeVideosLoading),
                  listOfVideos(
                      list: conservativeVideos,
                      videoLoader: isConservativeVideosLoading),
                  listOfVideos(
                      list: neutralVideos, videoLoader: isNeutralVideosLoading),
                  listOfVideos(
                      list: liberalVideos, videoLoader: isLiberalVideosLoading),
                  listOfVideos(
                      list: veryLiberalVideos,
                      videoLoader: isVeryLiberalVideosLoading),
                ]),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget listOfVideos({List? list, String? docPath, bool? videoLoader}) {
    return videoLoader!
        ? const Center(
            child: CircularProgress(),
          )
        : PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: list!.length,
            // controller: PreloadPageController(initialPage: 1),
            // preloadPagesCount: 3,
            itemBuilder: ((context, index) {
              final item = list[index];

              // List<dynamic> checkerList = [];
              // for (var i in (item['videoHashtags'])) {
              //   checkerList.add(i);
              // }
              return SizedBox(
                height: screenHeight(context) * 0.5,
                width: screenWidth(context),
                child: videosWidget(
                  context,
                  name: item['publisherName'] ?? '',
                  description: item['videoDescription'] ?? '',
                  topic: item['videoTopic'] ?? '',
                  videoTag: item['videoTag'] ?? '',
                  videoLink: item['videoLink'] ?? '',
                  // hastags: hastagsList!.isEmpty ? [] : hastagsList
                  // profilePic: item['publisherProfilePic']
                ),
              );
            }),
          );
  }

  SizedBox videosWidget(
    BuildContext context, {
    String? name,
    String? profilePic,
    String? description,
    String? topic,
    String? videoTag,
    List<dynamic>? hastags,
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
                                          child:

                                              // RichText(
                                              //   text: TextSpan(children: [
                                              //     TextSpan(
                                              //       text: description!,
                                              //       style: TextStyle(
                                              //         fontSize: 8,
                                              //         color: Colors.black,
                                              //       ),
                                              //     ),
                                              //     TextSpan(
                                              //         text: 'Login',
                                              //         style: TextStyle(
                                              //           fontSize: 8,
                                              //           color: Colors.blue,
                                              //         ),
                                              //         recognizer:
                                              //             TapGestureRecognizer()
                                              //               ..onTap = () {
                                              //                 print(
                                              //                     'Login Text Clicked');
                                              //               }),
                                              //   ]),
                                              // ),
                                              AutoSizeText.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: description!,
                                                ),
                                                TextSpan(
                                                  text: '#hello',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(blueColor)),
                                                ),
                                              ],
                                            ),
                                            style: const TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            maxLines: seeMore ? 5 : 1,
                                            maxFontSize: 10,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: seeMore ? 5 : 8,
                                          ),
                                          // AutoSizeText(
                                          //   description!,
                                          //   maxLines: seeMore ? 5 : 1,
                                          //   maxFontSize: 10,
                                          //   softWrap: true,
                                          //   overflow: TextOverflow.ellipsis,
                                          //   minFontSize: seeMore ? 5 : 8,
                                          //   style: const TextStyle(
                                          //     fontFamily: 'OpenSans',
                                          //     color: Colors.black,
                                          //     fontWeight: FontWeight.w400,
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                      description.length > 20
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
                                // SizedBox(
                                //   width: screenWidth(context) * 0.7,
                                //   height: seeMore
                                //       ? description!.length > 20
                                //           ? screenHeight(context) * 0.055
                                //           : screenHeight(context) * 0.045
                                //       : screenHeight(context) * 0.015,
                                //   child: Row(
                                //     crossAxisAlignment: seeMore
                                //         ? CrossAxisAlignment.end
                                //         : CrossAxisAlignment.center,
                                //     children: [
                                //       // Expanded(
                                //       //   child: ExpandableText(
                                //       //     "$description $hastags",
                                //       //     expandText: 'show more',
                                //       //     collapseText: 'show less',
                                //       //     style: const TextStyle(
                                //       //       fontFamily: 'OpenSans',
                                //       //       color: Colors.black,
                                //       //       fontSize: 10,
                                //       //       fontWeight: FontWeight.w400,
                                //       //     ),
                                //       //     linkStyle: const TextStyle(
                                //       //       fontFamily: 'OpenSans',
                                //       //       fontSize: 10,
                                //       //       fontWeight: FontWeight.w400,
                                //       //     ),
                                //       //     maxLines: 2,
                                //       //     linkColor: const Color(blueColor),
                                //       //   ),

                                //       AutoSizeText(
                                //         description!,
                                //         maxLines: seeMore ? 5 : 1,
                                //         maxFontSize: 10,
                                //         softWrap: true,
                                //         overflow: TextOverflow.ellipsis,
                                //         minFontSize: seeMore ? 5 : 8,
                                //         style: const TextStyle(
                                //           fontFamily: 'OpenSans',
                                //           color: Colors.black,
                                //           fontWeight: FontWeight.w400,
                                //         ),
                                //       ),
                                //       description.length > 20
                                //           ? seeMore
                                //               ? GestureDetector(
                                //                   child: txt(
                                //                     txt: 'see less',
                                //                     fontSize: 10,
                                //                     fontColor:
                                //                         const Color(blueColor),
                                //                   ),
                                //                   onTap: () => setState(
                                //                       () => seeMore = false))
                                //               : GestureDetector(
                                //                   child: txt(
                                //                     txt: 'see more',
                                //                     fontSize: 10,
                                //                     fontColor:
                                //                         const Color(blueColor),
                                //                   ),
                                //                   onTap: () => setState(
                                //                       () => seeMore = true))
                                //           : Container(),
                                //     ],
                                //   ),
                                // ),
                                // for (var document in hastags!) Text(document),

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
      txt(txt: itemText!, fontSize: 12, fontColor: Colors.white),
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
              txt: itemPercentage!,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontColor: const Color(blueColor)),
        ),
      )
    ],
  );
}
