import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:slant/controller/video_controller.dart';
import 'package:slant/res.dart';

import '../../../models/video.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/video_widget.dart';

class VideoList extends StatefulWidget {
  final String? headerName;
  final String? headertag;

  const VideoList({
    Key? key,
    this.headerName,
    this.headertag,
  }) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> with TickerProviderStateMixin {
  final VideoController videoController = getx.Get.put(VideoController());

  bool isFavourite = false;
  bool seeMore = false;
  bool isbrainOnFire = false;
  bool isLoading = false;
  bool isLoading1 = false;
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

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  updatingVideoHeader() async {
    setState(() {
      isLoading = true;
    });

    if (widget.headertag == 'topic') {
      await videoController.updateTopic(widget.headerName);
    } else if (widget.headertag == 'title') {
      await videoController.updateTitle(widget.headerName);
    } else if (widget.headertag == 'hashtag') {
      await videoController.updateHashtag(widget.headerName);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    updatingVideoHeader();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getx.Obx(() {
      return SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgress(),
              )
            : DefaultTabController(
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
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: screenWidth(context) * 0.7,
                                child: AutoSizeText(
                                  'Perspectives on ${widget.headerName}',
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
                      widget.headertag == 'topic'
                          ? Expanded(
                              child: TabBarView(children: [
                                listOfVideos(
                                  list: videoController
                                      .topicsVeryConservativeVideosList,
                                ),
                                listOfVideos(
                                  list: videoController
                                      .topicsConservativeVideoslist,
                                ),
                                listOfVideos(
                                  list: videoController.topicsNeutralVideosList,
                                ),
                                listOfVideos(
                                  list: videoController.topicsLiberalVideosList,
                                ),
                                listOfVideos(
                                  list: videoController
                                      .topicsVeryLiberalVideosList,
                                ),
                              ]),
                            )
                          : widget.headertag == 'hashtag'
                              ? Expanded(
                                  child: TabBarView(children: [
                                    listOfVideos(
                                      list: videoController
                                          .hashtagsVeryConservativeVideosList,
                                    ),
                                    listOfVideos(
                                      list: videoController
                                          .hashtagsConservativeVideoslist,
                                    ),
                                    listOfVideos(
                                      list: videoController
                                          .hashtagsNeutralVideosList,
                                    ),
                                    listOfVideos(
                                      list: videoController
                                          .hashtagsLiberalVideosList,
                                    ),
                                    listOfVideos(
                                      list: videoController
                                          .hashtagsVeryLiberalVideosList,
                                    ),
                                  ]),
                                )
                              : widget.headertag == 'title'
                                  ? Expanded(
                                      child: TabBarView(children: [
                                        listOfVideos(
                                          list: videoController
                                              .titlesVeryConservativeVideosList,
                                        ),
                                        listOfVideos(
                                          list: videoController
                                              .titlesConservativeVideoslist,
                                        ),
                                        listOfVideos(
                                          list: videoController
                                              .titlesNeutralVideosList,
                                        ),
                                        listOfVideos(
                                          list: videoController
                                              .titlesLiberalVideosList,
                                        ),
                                        listOfVideos(
                                          list: videoController
                                              .titlesVeryLiberalVideosList,
                                        ),
                                      ]),
                                    )
                                  : Container()
                    ]),
                  ),
                ),
              ),
      );
    });
  }

  Widget listOfVideos({List<Video>? list}) {
    return list!.isEmpty
        ? Center(
            child: txt(
                txt:
                    'Currently there is no video under this tag\nPlease be the one to share your perspective',
                fontSize: 18),
          )
        : PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: list.length,
            itemBuilder: ((context, index) {
              final data = list[index];

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
  }
}

//   SizedBox videosWidget(
//     BuildContext context, {
//     String? name,
//     List? brainOnFireReactions,
//     Video? video,
//     String? profilePic,
//     String? description,
//     String? topic,
//     String? videoTag,
//     String? publisherID,
//     List<dynamic>? hastags,
//     String? videoLink,
//   }) {
//     return SizedBox(
//       height: screenHeight(context),
//       child: Stack(
//         children: [
//           Positioned.fill(child: VideoPlayerItem(videoUrl: videoLink!)),
//           Transform.rotate(
//             angle: 180.0 * pi / 180,
//             child: Container(
//               height: screenHeight(context) * 0.2,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     const Color(0xFF8B7070),
//                     Colors.black.withOpacity(0.0),
//                     Colors.white
//                   ],
//                   stops: const [0.0, 0.0, 1.0],
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Transform.rotate(
//               angle: 180 * pi / 180,
//               child: Container(
//                 height: screenHeight(context) * 0.23,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       Colors.transparent,
//                       Colors.white10,
//                       Colors.white,
//                     ],
//                     stops: [0, 0.2, 0.9],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                 child: SizedBox(
//                   width: screenWidth(context) * 0.95,
//                   height: seeMore
//                       ? screenHeight(context) * 0.25
//                       : screenHeight(context) * 0.22,
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width: screenWidth(context) * 0.13,
//                             height: screenHeight(context) * 0.06,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 InkWell(
//                                     onTap: () {
//                                       setState(() {
//                                         isbrainOnFire = !isbrainOnFire;
//                                       });
//                                     },
//                                     child: isbrainOnFire
//                                         ? SvgPicture.asset(
//                                             'assets/svgs/brainOnFire.svg')
//                                         : SvgPicture.asset(
//                                             'assets/svgs/brain.svg')),
//                                 txt(
//                                     txt:
//                                         brainOnFireReactions!.length.toString(),
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                     fontColor: isbrainOnFire
//                                         ? const Color(blueColor)
//                                         : Colors.white)
//                               ],
//                             ),
//                           ),
//                           SvgPicture.asset('assets/svgs/slant.svg'),
//                         ],
//                       ),
//                       SizedBox(
//                         height: screenHeight(context) * 0.02,
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           navigator(
//                             function: BNB(isProfile: true, uid: publisherID),
//                             child: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               radius: 30,
//                               child: CachedNetworkImage(
//                                 imageUrl: profilePic!,
//                                 imageBuilder: (context, imageProvider) =>
//                                     CircleAvatar(
//                                         backgroundColor: Colors.transparent,
//                                         radius: 30,
//                                         backgroundImage: imageProvider),
//                                 placeholder: (context, url) =>
//                                     const CircularProgress(),
//                                 errorWidget: (context, url, error) =>
//                                     const CircleAvatar(
//                                         backgroundColor: Colors.transparent,
//                                         radius: 30,
//                                         backgroundImage: AssetImage(
//                                             'assets/images/placeholder.png')),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: screenWidth(context) * 0.04,
//                           ),
//                           SizedBox(
//                             width: screenWidth(context) * 0.7,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 txt(
//                                   maxLines: 1,
//                                   txt: '$name perspective on',
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 SizedBox(
//                                   height: seeMore
//                                       ? screenHeight(context) * 0.055
//                                       : screenHeight(context) * 0.015,
//                                   child: Row(
//                                     crossAxisAlignment: seeMore
//                                         ? CrossAxisAlignment.end
//                                         : CrossAxisAlignment.center,
//                                     children: [
//                                       Expanded(
//                                         child: AnimatedSize(
//                                           duration:
//                                               const Duration(milliseconds: 500),
//                                           child:

//                                               // RichText(
//                                               //   text: TextSpan(children: [
//                                               //     TextSpan(
//                                               //       text: description!,
//                                               //       style: TextStyle(
//                                               //         fontSize: 8,
//                                               //         color: Colors.black,
//                                               //       ),
//                                               //     ),
//                                               //     TextSpan(
//                                               //         text: 'Login',
//                                               //         style: TextStyle(
//                                               //           fontSize: 8,
//                                               //           color: Colors.blue,
//                                               //         ),
//                                               //         recognizer:
//                                               //             TapGestureRecognizer()
//                                               //               ..onTap = () {
//                                               //                 print(
//                                               //                     'Login Text Clicked');
//                                               //               }),
//                                               //   ]),
//                                               // ),
//                                               AutoSizeText.rich(
//                                             TextSpan(
//                                               children: [
//                                                 TextSpan(
//                                                   text: description!,
//                                                 ),
//                                                 TextSpan(
//                                                   text: '#hello',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color: Color(blueColor)),
//                                                 ),
//                                               ],
//                                             ),
//                                             style: const TextStyle(
//                                               fontFamily: 'OpenSans',
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                             maxLines: seeMore ? 5 : 1,
//                                             maxFontSize: 10,
//                                             softWrap: true,
//                                             overflow: TextOverflow.ellipsis,
//                                             minFontSize: seeMore ? 5 : 8,
//                                           ),
//                                           // AutoSizeText(
//                                           //   description!,
//                                           //   maxLines: seeMore ? 5 : 1,
//                                           //   maxFontSize: 10,
//                                           //   softWrap: true,
//                                           //   overflow: TextOverflow.ellipsis,
//                                           //   minFontSize: seeMore ? 5 : 8,
//                                           //   style: const TextStyle(
//                                           //     fontFamily: 'OpenSans',
//                                           //     color: Colors.black,
//                                           //     fontWeight: FontWeight.w400,
//                                           //   ),
//                                           // ),
//                                         ),
//                                       ),
//                                       description.length > 20
//                                           ? seeMore
//                                               ? GestureDetector(
//                                                   child: txt(
//                                                     txt: 'see less',
//                                                     fontSize: 10,
//                                                     fontColor:
//                                                         const Color(blueColor),
//                                                   ),
//                                                   onTap: () => setState(
//                                                       () => seeMore = false))
//                                               : GestureDetector(
//                                                   child: txt(
//                                                     txt: 'see more',
//                                                     fontSize: 10,
//                                                     fontColor:
//                                                         const Color(blueColor),
//                                                   ),
//                                                   onTap: () => setState(
//                                                       () => seeMore = true))
//                                           : Container(),
//                                     ],
//                                   ),
//                                 ),
//                                 // SizedBox(
//                                 //   width: screenWidth(context) * 0.7,
//                                 //   height: seeMore
//                                 //       ? description!.length > 20
//                                 //           ? screenHeight(context) * 0.055
//                                 //           : screenHeight(context) * 0.045
//                                 //       : screenHeight(context) * 0.015,
//                                 //   child: Row(
//                                 //     crossAxisAlignment: seeMore
//                                 //         ? CrossAxisAlignment.end
//                                 //         : CrossAxisAlignment.center,
//                                 //     children: [
//                                 //       // Expanded(
//                                 //       //   child: ExpandableText(
//                                 //       //     "$description $hastags",
//                                 //       //     expandText: 'show more',
//                                 //       //     collapseText: 'show less',
//                                 //       //     style: const TextStyle(
//                                 //       //       fontFamily: 'OpenSans',
//                                 //       //       color: Colors.black,
//                                 //       //       fontSize: 10,
//                                 //       //       fontWeight: FontWeight.w400,
//                                 //       //     ),
//                                 //       //     linkStyle: const TextStyle(
//                                 //       //       fontFamily: 'OpenSans',
//                                 //       //       fontSize: 10,
//                                 //       //       fontWeight: FontWeight.w400,
//                                 //       //     ),
//                                 //       //     maxLines: 2,
//                                 //       //     linkColor: const Color(blueColor),
//                                 //       //   ),

//                                 //       AutoSizeText(
//                                 //         description!,
//                                 //         maxLines: seeMore ? 5 : 1,
//                                 //         maxFontSize: 10,
//                                 //         softWrap: true,
//                                 //         overflow: TextOverflow.ellipsis,
//                                 //         minFontSize: seeMore ? 5 : 8,
//                                 //         style: const TextStyle(
//                                 //           fontFamily: 'OpenSans',
//                                 //           color: Colors.black,
//                                 //           fontWeight: FontWeight.w400,
//                                 //         ),
//                                 //       ),
//                                 //       description.length > 20
//                                 //           ? seeMore
//                                 //               ? GestureDetector(
//                                 //                   child: txt(
//                                 //                     txt: 'see less',
//                                 //                     fontSize: 10,
//                                 //                     fontColor:
//                                 //                         const Color(blueColor),
//                                 //                   ),
//                                 //                   onTap: () => setState(
//                                 //                       () => seeMore = false))
//                                 //               : GestureDetector(
//                                 //                   child: txt(
//                                 //                     txt: 'see more',
//                                 //                     fontSize: 10,
//                                 //                     fontColor:
//                                 //                         const Color(blueColor),
//                                 //                   ),
//                                 //                   onTap: () => setState(
//                                 //                       () => seeMore = true))
//                                 //           : Container(),
//                                 //     ],
//                                 //   ),
//                                 // ),
//                                 // for (var document in hastags!) Text(document),

//                                 txt(
//                                     maxLines: 1,
//                                     txt: '#$topic',
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     fontColor: const Color(blueColor)),
//                                 txt(
//                                     maxLines: 1,
//                                     txt: '#Being $videoTag',
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                     fontColor: const Color(blueColor))
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: screenHeight(context) * 0.015,
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Row(children: [
//                                 txt(
//                                   txt: '37%',
//                                   fontColor: const Color(blueColor),
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                                 txt(
//                                     txt: ' audience labelled this video as ',
//                                     fontWeight: FontWeight.bold,
//                                     fontColor: Colors.black45,
//                                     fontSize: 12),
//                                 txt(
//                                   txt: '#very liberal',
//                                   fontColor: const Color(blueColor),
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                               ]),
//                               txt(
//                                 txt: 'What do you think?',
//                                 fontColor: const Color(blueColor),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ],
//                           ),
//                           const Spacer(),
//                           PopupMenuButton(
//                               // offset: const Offset(0, -250),
//                               color: const Color(blueColor),
//                               onSelected: (value) {
//                                 // selectedValue(value);
//                               },
//                               elevation: 3.2,
//                               shape: const RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(15.0)),
//                               ),
//                               child: SvgPicture.asset(
//                                   'assets/svgs/microphone.svg'),
//                               itemBuilder: (context) => [
//                                     PopupMenuItem(
//                                       child: GestureDetector(
//                                         onTap: () {},
//                                         child: popupmenuItem(
//                                             'Very Conservative', '3%'),
//                                       ),
//                                       value: 1,
//                                     ),
//                                     PopupMenuItem(
//                                       child: GestureDetector(
//                                         onTap: () {},
//                                         child:
//                                             popupmenuItem('Conservative', '3%'),
//                                       ),
//                                       value: 2,
//                                     ),
//                                     PopupMenuItem(
//                                       child: GestureDetector(
//                                         onTap: () {},
//                                         child: popupmenuItem('Neutral', '3%'),
//                                       ),
//                                       value: 3,
//                                     ),
//                                     PopupMenuItem(
//                                       child: GestureDetector(
//                                         onTap: () {},
//                                         child: popupmenuItem('Liberal', '3%'),
//                                       ),
//                                       value: 4,
//                                     ),
//                                     PopupMenuItem(
//                                       child: GestureDetector(
//                                         onTap: () {},
//                                         child:
//                                             popupmenuItem('Very Liberal', '3%'),
//                                       ),
//                                       value: 5,
//                                     ),
//                                   ]),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )),
//           ),
//           Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
//               child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//                 SvgPicture.asset('assets/svgs/share.svg'),
//                 SizedBox(
//                   width: screenWidth(context) * 0.03,
//                 ),
//                 InkWell(
//                   onTap: () async {
//                     setState(() {
//                       isLoading1 = true;
//                     });
//                     if (isFavourite) {
//                       setState(() {
//                         isFavourite = false;
//                       });
//                       await videoController.likeVideo(video!, false);
//                     } else {
//                       setState(() {
//                         isFavourite = true;
//                       });
//                       await videoController.likeVideo(video!, true);
//                     }
//                     setState(() {
//                       isLoading1 = false;
//                     });
//                   },
//                   child: SizedBox(
//                     height: screenHeight(context) * 0.04,
//                     child: isLoading1
//                         ? const CircularProgress()
//                         : FutureBuilder<bool>(
//                             future: videoController.whetherVideoLikedOrNot(
//                                 videoLink: videoLink),
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<bool> snapshot) {
//                               if (snapshot.data == true) {
//                                 return const Icon(
//                                   Icons.favorite,
//                                   color: Color(redColor),
//                                   size: 30,
//                                 );
//                               } else {
//                                 return SvgPicture.asset(
//                                     'assets/svgs/heart.svg');
//                               }
//                             },
//                           ),
//                   ),
//                 )
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Row popupmenuItem(String? itemText, String? itemPercentage) {
//   return Row(
//     children: [
//       txt(txt: itemText!, fontSize: 12, fontColor: Colors.white),
//       const Spacer(),
//       Container(
//         width: 24.0,
//         height: 24.0,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//         ),
//         child: Center(
//           child: txt(
//               txt: itemPercentage!,
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               fontColor: const Color(blueColor)),
//         ),
//       )
//     ],
//   );
// }
