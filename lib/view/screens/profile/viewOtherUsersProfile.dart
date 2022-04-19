import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
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
                              child: data['profilePic'].toString().isEmpty
                                  ? const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                          'assets/images/placeholder.png'))
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        '${data['profilePic']}',
                                      ),
                                    )),
                          SizedBox(
                            height: screenHeight(context) * 0.01,
                          ),
                          txt(
                              txt: '${data['name']}',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          // ignore: unnecessary_null_comparison
                          // currentAddress.isNotEmpty
                          //     ? txt(txt: currentAddress, fontSize: 12)
                          //     :
                          // InkWell(
                          //   onTap: () {
                          //     // getCurrentLocation();
                          //   },
                          //   child: txt(
                          //       txt: 'Click here to add your location',
                          //       fontSize: 12),
                          // ),
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
                                      txt: '${data['following']}',
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
                              Column(
                                children: [
                                  txt(
                                      txt: '${data['followers']}',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  txt(txt: 'FOLLOWERS', fontSize: 10),
                                ],
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
                                      txt: '${data['noOfVids']}',
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
                          Container(
                            width: screenWidth(context) * 0.5,
                            height: screenHeight(context) * 0.055,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: const Color(0xFF3B5998),
                            ),
                            child: Center(
                              child: txt(
                                  txt: 'Follow',
                                  fontSize: 13,
                                  fontColor: Colors.white),
                            ),
                          )
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
