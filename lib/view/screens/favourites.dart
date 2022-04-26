import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as getx;
import 'package:slant/res.dart';
import 'package:slant/view/screens/profile/viewFavouriteVideo.dart';

import '../../controller/video_controller.dart';
import '../widgets/circularProgress.dart';
import '../widgets/video-thumbnail-generator.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final VideoController videoController = getx.Get.put(VideoController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: screenHeight(context) * 0.08,
          color: const Color(0xFF080808),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth(context) * 0.05,
                ),
                txt(txt: 'Favourites', fontSize: 18, fontColor: Colors.white),
                Container(
                  width: screenWidth(context) * 0.05,
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    users.doc(userId).collection("favouriteVideos").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'No videos...',
                      ),
                    );
                  } else if (snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          var data = (doc.data() as Map);

                          return favouriteItem(context,
                              doc: doc,
                              name: data['publisherName'] ?? "",
                              profileUrl: data['publisherProfilePic'] ?? '',
                              title: data['videoTitle'] ?? '',
                              videoLink: data['videoLink'] ?? "",
                              topic: data['videoTopic'] ?? "");
                        });
                  } else {
                    return const Center(child: Text('No videos...'));
                  }
                }),
          ),
        )
      ],
    );
  }

  Padding favouriteItem(
    BuildContext context, {
    String? name,
    String? profileUrl,
    DocumentSnapshot? doc,
    String? videoLink,
    String? topic,
    String? title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: screenHeight(context) * 0.2,
        child: Stack(
          children: [
            SizedBox(
              height: screenHeight(context) * 0.2,
              child: ThumbnailImage(
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Container(
                    height: screenHeight(context) * 0.2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage("assets/images/pic.jpeg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.dstIn),
                      ),
                    ),
                  );
                },

                frameBuilder: (BuildContext context, Widget child, int? frame,
                    bool wasSynchronouslyLoaded) {
                  return wasSynchronouslyLoaded
                      ? child
                      : AnimatedOpacity(
                          child: child,
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeOut,
                        );
                },

                filterQuality: FilterQuality.medium,
                colorBlendMode: BlendMode.dstIn,
                color: const Color(blueColor).withOpacity(0.8),

                height: screenHeight(context) * 0.2,
                width: double.infinity,

                fit: BoxFit.fill,
                cacheHeight: (screenHeight(context) * 0.2).toInt(),
                cacheWidth: 300,
                videoUrl: videoLink!,
                // width: 500,
                // height: screenHeight(context) * 0.2,
              ),
            ),
            Container(
              height: screenHeight(context) * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            navigator(
              function: ViewFavouriteVideo(
                doc: doc!,
              ),
              child: DelayedDisplay(
                delay: const Duration(seconds: 2),
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.string(
                    '<svg viewBox="174.78 378.56 39.93 39.93" ><path transform="translate(174.22, 377.99)" d="M 20.52500152587891 0.5625 C 9.497329711914062 0.5625 0.5625 9.497329711914062 0.5625 20.52500152587891 C 0.5625 31.55267333984375 9.497329711914062 40.48750686645508 20.52500152587891 40.48750686645508 C 31.55267333984375 40.48750686645508 40.48750686645508 31.55267333984375 40.48750686645508 20.52500152587891 C 40.48750686645508 9.497329711914062 31.55267333984375 0.5625 20.52500152587891 0.5625 Z M 29.8381519317627 22.45685577392578 L 15.67121505737305 30.58674240112305 C 14.39941215515137 31.29509162902832 12.79758167266846 30.3855094909668 12.79758167266846 28.89637184143066 L 12.79758167266846 12.15362930297852 C 12.79758167266846 10.67253971099854 14.39136123657227 9.754909515380859 15.67121505737305 10.46325588226318 L 29.8381519317627 19.07611083984375 C 31.15825271606445 19.81665420532227 31.15825271606445 21.72436141967773 29.8381519317627 22.45685577392578 Z" fill="#3b5998" stroke="none" stroke-width="5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 39.93,
                    height: 39.93,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.4,
                    child: txt(
                        txt: title!,
                        fontColor: const Color(blueColor),
                        fontSize: 14,
                        minFontSize: 8,
                        maxLines: 1,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.6,
                    child: AutoSizeText(
                      '#${topic!}',
                      maxFontSize: 14,
                      minFontSize: 8,
                      maxLines: 1,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 35,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: CachedNetworkImage(
                  imageUrl: profileUrl!,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      backgroundImage: imageProvider),
                  placeholder: (context, url) => const CircularProgress(),
                  errorWidget: (context, url, error) => const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/placeholder.png')),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 5,
              child: SizedBox(
                width: screenWidth(context) * 0.2,
                child: Center(
                  child: txt(
                    maxLines: 1,
                    minFontSize: 5,
                    txt: name!,
                    fontSize: 10,
                    fontColor: const Color(blueColor),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 15,
                right: 20,
                child: InkWell(
                  onTap: () async {
                    await videoController.removeVideoFromFavourites(
                        (doc!.data() as Map)['videoLink']);
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Color(redColor),
                    size: 40,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
