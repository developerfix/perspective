import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:slant/auth/login.dart';
import 'package:slant/res.dart';
import 'package:slant/view/screens/profile/editProfile.dart';
import 'package:slant/view/screens/profile/followers.dart';
import 'package:slant/view/screens/profile/viewVideo.dart';
import 'package:slant/view/widgets/circularProgress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../bnb.dart';
import '../../widgets/video-thumbnail-generator.dart';

class OtherUserProfile extends StatefulWidget {
  final String publishersID;

  // final String bio;
  // final String followers;
  const OtherUserProfile({Key? key, required this.publishersID})
      : super(key: key);

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  int noOfVids = 0;
  int noOfFollowers = 0;
  int noOfFollowing = 0;

  bool isFollowed = false;

  checkIfFollowedOrNot() async {
    await users
        .doc(userId)
        .collection('following')
        .doc(widget.publishersID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          isFollowed = true;
        });
      } else {
        setState(() {
          isFollowed = false;
        });
      }
    });
  }

  followUser() async {
    await users
        .doc(widget.publishersID)
        .collection(followers)
        .doc(userId)
        .set({}).then((value) {
      users.doc(userId).collection(following).doc(widget.publishersID).set({});
    }).then((value) {
      setState(() {
        isFollowed = true;
      });
    });
  }

  unFollowUser() async {
    await users
        .doc(widget.publishersID)
        .collection(followers)
        .doc(userId)
        .delete()
        .then((value) {
      users.doc(userId).collection(following).doc(widget.publishersID).delete();
    }).then((value) {
      setState(() {
        isFollowed = false;
      });
    });
  }

  getUserInfo() async {
    await users
        .doc(widget.publishersID)
        .collection('videos')
        .get()
        .then((QuerySnapshot querySnapshot) {
      noOfVids = querySnapshot.size;
    });
    await users
        .doc(widget.publishersID)
        .collection(followers)
        .get()
        .then((QuerySnapshot querySnapshot) {
      noOfFollowers = querySnapshot.size;
    });
    await users
        .doc(widget.publishersID)
        .collection(following)
        .get()
        .then((QuerySnapshot querySnapshot) {
      noOfFollowing = querySnapshot.size;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    checkIfFollowedOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
            future: users.doc(widget.publishersID).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container();
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Container();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                return SizedBox(
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
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                              ),
                              txt(
                                  txt: 'Profile',
                                  fontSize: 18,
                                  fontColor: Colors.white),
                              Container(
                                width: screenWidth(context) * 0.05,
                              ),
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
                              imageUrl: '${data['profilePic']}',
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
                              txt: '${data['name']}',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          SizedBox(
                            height: screenHeight(context) * 0.01,
                          ),
                          txt(
                              txt: '${data['bio']}',
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
                              Column(
                                children: [
                                  txt(
                                      txt: noOfFollowing.toString(),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  txt(txt: 'FOLLOWING', fontSize: 10),
                                ],
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
                                function:
                                    Followers(userID: widget.publishersID),
                                child: Column(
                                  children: [
                                    txt(
                                        txt: noOfFollowers.toString(),
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
                                      txt: noOfVids.toString(),
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
                          InkWell(
                            onTap: () {
                              isFollowed ? unFollowUser() : followUser();
                            },
                            child: Container(
                              width: screenWidth(context) * 0.5,
                              height: screenHeight(context) * 0.055,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                color: const Color(0xFF3B5998),
                              ),
                              child: Center(
                                child: txt(
                                    txt: isFollowed ? 'Unfollow' : 'Follow',
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
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return const Scaffold(body: Center(child: CircularProgress()));
            }),
      ),
    );
  }
}
