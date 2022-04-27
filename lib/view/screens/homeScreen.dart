import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as getx;
import 'package:slant/bnb.dart';
import 'package:slant/controller/video_controller.dart';
import 'package:slant/res.dart';
import 'package:slant/view/screens/makeVideo/Invite.dart';
import 'package:slant/view/screens/makeVideo/makeVideo.dart';
import 'package:slant/view/screens/profile/profile.dart';
import 'package:slant/view/screens/videoItem.dart';
import "dart:math" show pi;

import '../../models/video.dart';
import '../widgets/circularProgress.dart';
import '../widgets/videoWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin<HomeScreen> {
  final VideoController videoController = getx.Get.put(VideoController());
  bool isFavourite = false;
  bool _isPlaying = false;
  bool seeMore = false;
  bool isbrainOnFire = false;
  List<dynamic> topicsOfInterest = [];
  var homeScreenVideos = [];
  bool isLoading = false;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getx.Obx(() {
      return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videoController.homeScreenVideosList.length,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        // controller: PreloadPageController(initialPage: 1),
        // preloadPagesCount: 3,
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

//   Stack videosWidget(
//     BuildContext context, {
//     Video? video,
//     String? name,
//     String? publishersID,
//     List? brainOnFireReactions,
//     String? profilePic,
//     String? description,
//     String? title,
//     String? videoTag,
//     List? hastags,
//     String? videoLink,
//   }) {
//     return Stack(
//       children: [
//         VideoPlayerItem(
//           videoUrl: videoLink!,
//         ),
//         Transform.rotate(
//           angle: 180.0 * pi / 180,
//           child: Container(
//             height: screenHeight(context) * 0.2,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   const Color(0xFF8B7070),
//                   Colors.black.withOpacity(0.0),
//                   Colors.white
//                 ],
//                 stops: const [0.0, 0.0, 1.0],
//               ),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Transform.rotate(
//             angle: 180 * pi / 180,
//             child: Container(
//               height: screenHeight(context) * 0.23,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.white10,
//                     Colors.white,
//                   ],
//                   stops: [0, 0.2, 0.9],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Padding(
//               padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//               child: SizedBox(
//                 width: screenWidth(context) * 0.95,
//                 height: seeMore
//                     ? screenHeight(context) * 0.25
//                     : screenHeight(context) * 0.22,
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: screenWidth(context) * 0.13,
//                           height: screenHeight(context) * 0.06,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       isbrainOnFire = !isbrainOnFire;
//                                     });
//                                   },
//                                   child: isbrainOnFire
//                                       ? SvgPicture.asset(
//                                           'assets/svgs/brainOnFire.svg')
//                                       : SvgPicture.asset(
//                                           'assets/svgs/brain.svg')),
//                               txt(
//                                   txt: brainOnFireReactions!.length.toString(),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   fontColor: isbrainOnFire
//                                       ? const Color(blueColor)
//                                       : Colors.white)
//                             ],
//                           ),
//                         ),
//                         navigator(
//                             function: MakeVideo(
//                               hastags: hastags!,
//                               isAddingToThChain: true,
//                               title: title,
//                             ),
//                             child: SvgPicture.asset('assets/svgs/slant.svg')),
//                       ],
//                     ),
//                     SizedBox(
//                       height: screenHeight(context) * 0.02,
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         navigator(
//                           function: BNB(isProfile: true, uid: publishersID!),
//                           child: CircleAvatar(
//                             backgroundColor: Colors.transparent,
//                             radius: 30,
//                             child: CachedNetworkImage(
//                               fit: BoxFit.contain,
//                               imageUrl: profilePic == null ||
//                                       profilePic.toString().isEmpty
//                                   ? 'https://www.kindpng.com/picc/m/285-2855863_a-festival-celebrating-tractors-round-profile-picture-placeholder.png'
//                                   : profilePic,
//                               imageBuilder: (context, imageProvider) =>
//                                   CircleAvatar(
//                                       backgroundColor: Colors.transparent,
//                                       radius: 30,
//                                       backgroundImage: imageProvider),
//                               placeholder: (context, url) =>
//                                   const CircularProgress(),
//                               errorWidget: (context, url, error) =>
//                                   const CircleAvatar(
//                                       backgroundColor: Colors.transparent,
//                                       radius: 30,
//                                       backgroundImage: AssetImage(
//                                           'assets/images/placeholder.png')),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: screenWidth(context) * 0.04,
//                         ),
//                         SizedBox(
//                           width: screenWidth(context) * 0.7,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               txt(
//                                 maxLines: 1,
//                                 txt: '$name perspective on',
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               SizedBox(
//                                 height: seeMore
//                                     ? screenHeight(context) * 0.055
//                                     : screenHeight(context) * 0.015,
//                                 child: Row(
//                                   crossAxisAlignment: seeMore
//                                       ? CrossAxisAlignment.end
//                                       : CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: AnimatedSize(
//                                         duration:
//                                             const Duration(milliseconds: 500),
//                                         child: AutoSizeText(
//                                           description!,
//                                           maxLines: seeMore ? 5 : 1,
//                                           maxFontSize: 10,
//                                           softWrap: true,
//                                           overflow: TextOverflow.ellipsis,
//                                           minFontSize: seeMore ? 5 : 8,
//                                           style: const TextStyle(
//                                             fontFamily: 'OpenSans',
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     description.length == 20
//                                         ? seeMore
//                                             ? GestureDetector(
//                                                 child: txt(
//                                                   txt: 'see less',
//                                                   fontSize: 10,
//                                                   fontColor:
//                                                       const Color(blueColor),
//                                                 ),
//                                                 onTap: () => setState(
//                                                     () => seeMore = false))
//                                             : GestureDetector(
//                                                 child: txt(
//                                                   txt: 'see more',
//                                                   fontSize: 10,
//                                                   fontColor:
//                                                       const Color(blueColor),
//                                                 ),
//                                                 onTap: () => setState(
//                                                     () => seeMore = true))
//                                         : Container(),
//                                   ],
//                                 ),
//                               ),
//                               txt(
//                                   maxLines: 1,
//                                   txt: '#$title',
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   fontColor: const Color(blueColor)),
//                               txt(
//                                   maxLines: 1,
//                                   txt: '#Being $videoTag',
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   fontColor: const Color(blueColor))
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: screenHeight(context) * 0.015,
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(children: [
//                               txt(
//                                 txt: '37%',
//                                 fontColor: const Color(blueColor),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                               txt(
//                                   txt: ' audience labelled this video as ',
//                                   fontWeight: FontWeight.bold,
//                                   fontColor: Colors.black45,
//                                   fontSize: 12),
//                               txt(
//                                 txt: '#very liberal',
//                                 fontColor: const Color(blueColor),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ]),
//                             txt(
//                               txt: 'What do you think?',
//                               fontColor: const Color(blueColor),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ],
//                         ),
//                         // const Spacer(),
//                         PopupMenuButton(
//                             // offset: const Offset(0, -250),
//                             color: const Color(blueColor),
//                             onSelected: (value) {
//                               // selectedValue(value);
//                             },
//                             elevation: 3.2,
//                             shape: const RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(15.0)),
//                             ),
//                             child:
//                                 SvgPicture.asset('assets/svgs/microphone.svg'),
//                             itemBuilder: (context) => [
//                                   PopupMenuItem(
//                                     child: GestureDetector(
//                                       onTap: () {},
//                                       child: popupmenuItem(
//                                           'Very Conservative', '3%'),
//                                     ),
//                                     value: 1,
//                                   ),
//                                   PopupMenuItem(
//                                     child: GestureDetector(
//                                       onTap: () {},
//                                       child:
//                                           popupmenuItem('Conservative', '3%'),
//                                     ),
//                                     value: 2,
//                                   ),
//                                   PopupMenuItem(
//                                     child: GestureDetector(
//                                       onTap: () {},
//                                       child: popupmenuItem('Neutral', '3%'),
//                                     ),
//                                     value: 3,
//                                   ),
//                                   PopupMenuItem(
//                                     child: GestureDetector(
//                                       onTap: () {},
//                                       child: popupmenuItem('Liberal', '3%'),
//                                     ),
//                                     value: 4,
//                                   ),
//                                   PopupMenuItem(
//                                     child: GestureDetector(
//                                       onTap: () {},
//                                       child:
//                                           popupmenuItem('Very Liberal', '3%'),
//                                     ),
//                                     value: 5,
//                                   ),
//                                 ]),
//                       ],
//                     ),
//                   ],
//                 ),
//               )),
//         ),
//         Align(
//           alignment: Alignment.topRight,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
//             child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//               navigator(
//                   function: const Invite(),
//                   child: SvgPicture.asset('assets/svgs/share.svg')),
//               SizedBox(
//                 width: screenWidth(context) * 0.03,
//               ),
//               InkWell(
//                 onTap: () async {
//                   setState(() {
//                     isLoading = true;
//                   });
//                   if (isFavourite) {
//                     setState(() {
//                       isFavourite = false;
//                     });
//                     await videoController.likeVideo(video!, false);
//                   } else {
//                     setState(() {
//                       isFavourite = true;
//                     });
//                     await videoController.likeVideo(video!, true);
//                   }
//                   setState(() {
//                     isLoading = false;
//                   });
//                 },
//                 child: SizedBox(
//                   height: screenHeight(context) * 0.04,
//                   child: isLoading
//                       ? const Center(child: CircularProgress())
//                       : FutureBuilder<bool>(
//                           future: videoController.whetherVideoLikedOrNot(
//                               videoLink: videoLink),
//                           builder: (BuildContext context,
//                               AsyncSnapshot<bool> snapshot) {
//                             if (snapshot.data == true) {
//                               return const Icon(
//                                 Icons.favorite,
//                                 color: Color(redColor),
//                                 size: 30,
//                               );
//                             } else {
//                               return SvgPicture.asset('assets/svgs/heart.svg');
//                             }
//                           },
//                         ),
//                 ),
//               )
//             ]),
//           ),
//         ),
//       ],
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
