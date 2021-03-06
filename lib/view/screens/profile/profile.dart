import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as getx;
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:slant/auth/login.dart';
import 'package:slant/controller/profile_controller.dart';
import 'package:slant/res.dart';
import 'package:slant/splash.dart';
import 'package:slant/view/screens/profile/edit_profile.dart';
import 'package:slant/view/screens/profile/followers_screen.dart';
import 'package:slant/view/screens/profile/following_screen.dart';
import 'package:slant/view/screens/profile/view_by_you_videos.dart';
import 'package:slant/view/screens/profile/view_request_video.dart';
import 'package:slant/view/widgets/circular_progress.dart';

import '../../../bnb.dart';
import '../../widgets/video_thumbnail_generator.dart';

class Profile extends StatefulWidget {
  final String uid;

  const Profile({Key? key, required this.uid}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController profileController = getx.Get.put(ProfileController());

  updateUserId() async {
    await profileController.updateUserId(widget.uid);
  }

  @override
  void initState() {
    updateUserId();
    super.initState();
  }

  int noOfVids = 0;
  int noOfFollowers = 0;
  int noOfFollowing = 0;
  bool loading = false;
  bool isFollowButtonLoading = false;

  // final geolocator =
  //     Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  // Position? _currentPosition;
  // String currentAddress = "";

  // void getCurrentLocation() async {
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });

  //     getAddressFromLatLng();
  //   }).catchError((e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //   });
  // }

  // void getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await placemarkFromCoordinates(
  //         _currentPosition!.latitude, _currentPosition!.longitude);

  //     Placemark place = p[0];

  //     setState(() {
  //       currentAddress =
  //           "${place.thoroughfare},${place.subThoroughfare},${place.name}, ${place.subLocality}";
  //     });
  //   } catch (e) {
  //     Container();
  //   }
  // }

  // getUserInfo() async {
  //   await users
  //       .doc(userId)
  //       .collection('videos')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     noOfVids = querySnapshot.size;
  //   });
  //   await users
  //       .doc(userId)
  //       .collection(followers)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     noOfFollowers = querySnapshot.size;
  //   });
  //   await users
  //       .doc(userId)
  //       .collection(following)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     noOfFollowing = querySnapshot.size;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getUserInfo();
  //   // getCurrentLocation();
  // }

  @override
  Widget build(BuildContext context) {
    return getx.GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (profileController.user.isEmpty) {
            return const Center(
              child: CircularProgress(),
            );
          }
          return loading
              ? const Center(
                  child: CircularProgress(),
                )
              : DefaultTabController(
                  length: 2,
                  child: SizedBox(
                    height: screenHeight(context),
                    width: screenWidth(context),
                    child: Column(
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
                                txt(
                                    txt: 'Profile',
                                    fontSize: 18,
                                    fontColor: Colors.white),
                                PopupMenuButton(
                                    onSelected: (value) async {
                                      if (value == 1) {
                                        getx.Get.to(() => const EditProfile());
                                      } else if (value == 2) {
                                        setState(() {
                                          loading = true;
                                        });
                                        await FirebaseAuth.instance
                                            .signOut()
                                            .then((value) {
                                          setState(() {
                                            loading = false;
                                          });
                                          getx.Get.offAll(() => const Login(
                                                isLoggedout: true,
                                              ));
                                        });
                                        setState(() {
                                          loading = false;
                                        });
                                        // await FacebookAuth.instance.logOut();

                                      }
                                    },
                                    child: SvgPicture.asset(
                                        'assets/svgs/menu.svg'),
                                    elevation: 3.2,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            child: Text("Edit Profile"),
                                            value: 1,
                                          ),
                                          const PopupMenuItem(
                                            child: Text("Logout"),
                                            value: 2,
                                          )
                                        ]),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: screenHeight(context) * 0.02,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 50,
                              child: CachedNetworkImage(
                                imageUrl: profileController
                                                .user['profilePhoto'] ==
                                            null ||
                                        profileController.user['profilePhoto']
                                            .toString()
                                            .isEmpty
                                    ? 'https://www.kindpng.com/picc/m/285-2855863_a-festival-celebrating-tractors-round-profile-picture-placeholder.png'
                                    : profileController.user['profilePhoto'],
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 50,
                                        backgroundImage: imageProvider),
                                placeholder: (context, url) =>
                                    const CircularProgress(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            'assets/images/placeholder.png')),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.01,
                            ),
                            txt(
                                txt: profileController.user['name'],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),

                            // widget.uid != userId
                            //     ? Container()
                            //     : InkWell(
                            //         onTap: () {
                            //           // getCurrentLocation();
                            //         },
                            //         child: txt(
                            //             txt: 'Click here to add your location',
                            //             fontSize: 12),
                            //       ),
                            SizedBox(
                              height: screenHeight(context) * 0.01,
                            ),
                            txt(
                                txt: profileController.user['bio'],
                                fontSize: 12,
                                fontColor: Colors.black.withOpacity(0.5)),
                            SizedBox(
                              height: screenHeight(context) * 0.015,
                            ),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: screenWidth(context) * 0.2,
                                ),
                                const Spacer(),
                                navigator(
                                  function: Following(userID: widget.uid),
                                  child: Column(
                                    children: [
                                      txt(
                                          txt: profileController
                                              .user['following'],
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      txt(txt: 'FOLLOWING', fontSize: 10),
                                    ],
                                  ),
                                ),
                                const Spacer(
                                  flex: 3,
                                ),
                                Column(
                                  children: [
                                    Container(
                                        height: 20,
                                        width: 2,
                                        color: const Color(0xff707070)
                                            .withOpacity(0.3)),
                                    txt(txt: '', fontSize: 5),
                                  ],
                                ),
                                const Spacer(),
                                navigator(
                                  function: Followers(userID: widget.uid),
                                  child: Column(
                                    children: [
                                      txt(
                                          txt: profileController
                                              .user['followers'],
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      txt(txt: 'FOLLOWERS', fontSize: 10),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Container(
                                        height: 20,
                                        width: 2,
                                        color: const Color(0xff707070)
                                            .withOpacity(0.3)),
                                    txt(txt: '', fontSize: 5),
                                  ],
                                ),
                                const Spacer(
                                  flex: 3,
                                ),
                                Column(
                                  children: [
                                    txt(
                                        txt: profileController.user['vids'],
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    txt(txt: 'VIDS', fontSize: 10),
                                  ],
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: screenWidth(context) * 0.2,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.015,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        widget.uid != userId
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isFollowButtonLoading = true;
                                      });
                                      await profileController.followUser();
                                      setState(() {
                                        isFollowButtonLoading = false;
                                      });
                                    },
                                    child: isFollowButtonLoading
                                        ? const CircularProgress()
                                        : Container(
                                            width: screenWidth(context) * 0.5,
                                            height:
                                                screenHeight(context) * 0.055,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.0),
                                              color: const Color(0xFF3B5998),
                                            ),
                                            child: Center(
                                              child: txt(
                                                  txt: profileController
                                                          .user['isFollowing']
                                                      ? 'Unfollow'
                                                      : 'Follow',
                                                  fontSize: 13,
                                                  fontColor: Colors.white),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  txt(
                                      txt: 'This account is private',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)
                                ],
                              )
                            : Column(
                                children: [
                                  TabBar(
                                    indicatorColor:
                                        const Color(blueColor).withOpacity(0.5),
                                    tabs: [
                                      Tab(
                                          icon:
                                              txt(txt: "BY YOU", fontSize: 14)),
                                      Tab(
                                          icon: txt(
                                              txt: "REQUESTS", fontSize: 14)),
                                    ],
                                  ),
                                ],
                              ),
                        widget.uid != userId
                            ? Container()
                            : Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: TabBarView(
                                      children: [
                                        StreamBuilder<QuerySnapshot>(
                                            stream: usersCollection
                                                .doc(userId)
                                                .collection("videos")
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData ||
                                                  snapshot.hasError) {
                                                return const Center(
                                                  child: Text(
                                                    'No videos...',
                                                  ),
                                                );
                                              } else if (snapshot
                                                  .data!.docs.isNotEmpty) {
                                                return ListView.builder(
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      DocumentSnapshot doc =
                                                          snapshot.data!
                                                              .docs[index];

                                                      return favouriteItem(context,
                                                          controller:
                                                              profileController,
                                                          vc: (doc.data() as Map)[
                                                              'veryConservative'],
                                                          c: (doc.data() as Map)[
                                                              'conservative'],
                                                          n: (doc.data() as Map)[
                                                              'neutral'],
                                                          l: (doc.data() as Map)[
                                                              'liberal'],
                                                          vl: (doc.data() as Map)[
                                                              'veryLiberal'],
                                                          doc: doc,
                                                          name: ' ',
                                                          profileUrl: ' ',
                                                          title: (doc.data()
                                                                      as Map)[
                                                                  'videoTitle'] ??
                                                              ' ',
                                                          videoLink:
                                                              (doc.data() as Map)['videoLink'] ??
                                                                  ' ',
                                                          topic: (doc.data()
                                                                  as Map)['videoTopic'] ??
                                                              ' ');
                                                    });
                                              } else {
                                                return const Center(
                                                    child:
                                                        Text('No videos...'));
                                              }
                                            }),
                                        StreamBuilder<QuerySnapshot>(
                                            stream: usersCollection
                                                .doc(userId)
                                                .collection(
                                                    "perspectiveRequests")
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData ||
                                                  snapshot.hasError) {
                                                return const Center(
                                                  child: Text(
                                                    'No perspective requests for you...',
                                                  ),
                                                );
                                              } else if (snapshot
                                                  .data!.docs.isNotEmpty) {
                                                return ListView.builder(
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      DocumentSnapshot doc =
                                                          snapshot.data!
                                                              .docs[index];
                                                      var data =
                                                          (doc.data() as Map);
                                                      var videoDetails =
                                                          data['videoDetails']
                                                              as Map;

                                                      String userID =
                                                          data['userID'];
                                                      String userName =
                                                          data['userName'];
                                                      String userProfileUrl =
                                                          data[
                                                              'userProfileUrl'];

                                                      return perspectiveRequestedItem(
                                                          context,
                                                          controller:
                                                              profileController,
                                                          vc: (doc.data() as Map)[
                                                              'veryConservative'],
                                                          c: (doc.data() as Map)[
                                                              'conservative'],
                                                          n: (doc.data() as Map)[
                                                              'neutral'],
                                                          l: (doc.data()
                                                                  as Map)[
                                                              'liberal'],
                                                          vl: (doc.data()
                                                                  as Map)[
                                                              'veryLiberal'],
                                                          title: videoDetails[
                                                              'videoTitle'],
                                                          topic: videoDetails[
                                                              'videoTopic'],
                                                          name: userName,
                                                          videoDetails:
                                                              videoDetails,
                                                          profileUrl:
                                                              userProfileUrl,
                                                          userID: userID);
                                                    });
                                              } else {
                                                return const Center(
                                                    child: Text(
                                                        'No perspective requests for you...'));
                                              }
                                            }),
                                      ],
                                    )),
                              )
                      ],
                    ),
                  ),
                );
        });
  }

  Padding perspectiveRequestedItem(
    BuildContext context, {
    ProfileController? controller,
    String? name,
    Map? videoDetails,
    String? title,
    String? userID,
    String? topic,
    String? profileUrl,
    int? vc,
    int? c,
    int? n,
    int? l,
    int? vl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: screenHeight(context) * 0.2,
        child: Stack(
          children: [
            Container(
              height: screenHeight(context) * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: const AssetImage('assets/images/pic.jpeg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstIn),
                ),
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
              function: ViewRequestVideo(
                videoDetail: videoDetails,
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF3B5998),
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/svgs/chainIcon.svg'),
                    ),
                  )),
            ),
            Positioned(
              top: 15,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(
                      txt: title!,
                      fontColor: const Color(blueColor),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  Text(
                    '#$topic',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 35,
              right: 20,
              child: navigator(
                function: BNB(isProfile: true, uid: userID!),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  child: CachedNetworkImage(
                    imageUrl: profileUrl == null ||
                            profileUrl.toString().isEmpty
                        ? 'https://www.kindpng.com/picc/m/285-2855863_a-festival-celebrating-tractors-round-profile-picture-placeholder.png'
                        : profileUrl,
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
              bottom: 15,
              left: 10,
              right: 10,
              child: SizedBox(
                width: screenWidth(context) * 0.85,
                child: vc == 0 && c == 0 && n == 0 && l == 0 && vl == 0
                    ? Row(children: [
                        SizedBox(
                          width: screenWidth(context) * 0.7,
                          child: txt(
                              maxLines: 1,
                              txt:
                                  'No response from the audience on this video yet',
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.black45,
                              fontSize: 12),
                        ),
                      ])
                    : Row(
                        children: [
                          SizedBox(
                            width: screenWidth(context) * 0.065,
                            child: txt(
                              maxLines: 1,
                              txt: controller!
                                      .byYouVideoAudienceReactionPercentage(
                                        c: c,
                                        l: l,
                                        n: n,
                                        vc: vc,
                                        vl: vl,
                                      )
                                      .first
                                      .toString() +
                                  '%',
                              fontColor: const Color(blueColor),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.4,
                            child: txt(
                              maxLines: 1,
                              txt: ' audience labelled this video as ',
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.black45,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.3,
                            child: txt(
                                maxLines: 1,
                                txt: '#' +
                                    controller
                                        .byYouVideoAudienceReactionPercentage(
                                          c: c,
                                          l: l,
                                          n: n,
                                          vc: vc,
                                          vl: vl,
                                        )
                                        .last
                                        .toString(),
                                fontColor: const Color(blueColor),
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Padding favouriteItem(
  BuildContext context, {
  ProfileController? controller,
  String? name,
  String? profileUrl,
  DocumentSnapshot? doc,
  String? videoLink,
  String? topic,
  String? title,
  int? vc,
  int? c,
  int? n,
  int? l,
  int? vl,
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
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          navigator(
            function: ViewByYouVideo(
              pictureUrl: profileUrl!,
              name: name!,
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
            top: 15,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txt(
                    txt: title!,
                    fontColor: const Color(blueColor),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
                Text(
                  '#$topic',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            left: 10,
            right: 10,
            child: SizedBox(
              width: screenWidth(context) * 0.85,
              child: vc == 0 && c == 0 && n == 0 && l == 0 && vl == 0
                  ? Row(children: [
                      SizedBox(
                        width: screenWidth(context) * 0.7,
                        child: txt(
                            maxLines: 1,
                            txt:
                                'No response from the audience on this video yet',
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.black45,
                            fontSize: 12),
                      ),
                    ])
                  : Row(
                      children: [
                        SizedBox(
                          width: screenWidth(context) * 0.065,
                          child: txt(
                            maxLines: 1,
                            txt: controller!
                                    .byYouVideoAudienceReactionPercentage(
                                      c: c,
                                      l: l,
                                      n: n,
                                      vc: vc,
                                      vl: vl,
                                    )
                                    .first
                                    .toString() +
                                '%',
                            fontColor: const Color(blueColor),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth(context) * 0.4,
                          child: txt(
                            maxLines: 1,
                            txt: ' audience labelled this video as ',
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.black45,
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth(context) * 0.3,
                          child: txt(
                              maxLines: 1,
                              txt: '#' +
                                  controller
                                      .byYouVideoAudienceReactionPercentage(
                                        c: c,
                                        l: l,
                                        n: n,
                                        vc: vc,
                                        vl: vl,
                                      )
                                      .last
                                      .toString(),
                              fontColor: const Color(blueColor),
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}
