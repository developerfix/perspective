import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:slant/res.dart';
import 'dart:io';
import 'package:hashtagable/hashtagable.dart';

import 'package:slant/bnb.dart';
import 'package:slant/view/screens/makeVideo/q2_3.dart';
import 'package:slant/view/widgets/circular_progress.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';

import '../../../controller/upload_video_controller.dart';

class ChainVideoInfo extends StatefulWidget {
  final List? hastags;
  final String? title;
  final String? topic;
  const ChainVideoInfo({Key? key, this.hastags, this.title, this.topic})
      : super(key: key);

  @override
  State<ChainVideoInfo> createState() => _ChainVideoInfoState();
}

class _ChainVideoInfoState extends State<ChainVideoInfo> {
  final TextEditingController _descriptionController = TextEditingController();
  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  bool? p1 = false;
  bool? p2 = false;
  bool? p3 = false;
  bool? p4 = false;
  bool? p5 = false;
  String tagSelected = '';

  final ImagePicker _picker = ImagePicker();
  List? hashTags = [];
  bool loading = false;
  String? downloadURL;
  File? _video;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  String? userName = "";
  String? userProfilePic = "";

  getUserName() async {
    await users.doc(userId).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.data() != null) {
          if (documentSnapshot
              .get(FieldPath(const ['name']))
              .toString()
              .isNotEmpty) {
            setState(() {
              userName = documentSnapshot.get(FieldPath(const ['name']));
            });
          }
          if (documentSnapshot
              .get(FieldPath(const ['profilePic']))
              .toString()
              .isNotEmpty) {
            setState(() {
              userProfilePic =
                  documentSnapshot.get(FieldPath(const ['profilePic']));
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    hashTags = widget.hastags!;

    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.to(() => const BNB());

        return Future<bool>(
          () => true,
        );
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight(context) * 0.95,
              width: screenWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              txt: 'Add perspective',
                              fontSize: 18,
                              fontColor: Colors.white),
                          Container(
                            width: screenWidth(context) * 0.05,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt(
                            txt:
                                'Choose the most suitable tag for your perspective',
                            fontSize: 14),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p1 = true;
                              tagSelected = veryConservative;
                              if (p1 == true) {
                                p2 = false;
                                p3 = false;
                                p4 = false;
                                p5 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: veryConservative,
                              topic: p1 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p2 = true;
                              tagSelected = conservative;

                              if (p2 == true) {
                                p1 = false;
                                p3 = false;
                                p4 = false;
                                p5 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: conservative, topic: p2 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p3 = true;
                              tagSelected = neutral;

                              if (p3 == true) {
                                p1 = false;
                                p2 = false;
                                p4 = false;
                                p5 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: neutral, topic: p3 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p4 = true;
                              tagSelected = liberal;

                              if (p4 == true) {
                                p1 = false;
                                p3 = false;
                                p2 = false;
                                p5 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: liberal, topic: p4 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p5 = true;
                              tagSelected = veryLiberal;

                              if (p5 == true) {
                                p1 = false;
                                p3 = false;
                                p4 = false;
                                p2 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: veryLiberal, topic: p5 == true ? 1 : 0),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.03,
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        txt(txt: 'Add Short Description', fontSize: 14),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        textField(
                            isDisabled: false,
                            maxLength: 100,
                            maxlines: 5,
                            hinttext: '...',
                            controller: _descriptionController,
                            context: context),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (loading) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            txt(
                                txt: 'Please wait, video is publishing',
                                fontSize: 18),
                            SizedBox(
                              height: screenHeight(context) * 0.05,
                            ),
                            const CircularProgress(),
                          ],
                        )
                      ],
                    )
                  ],
                  if (!loading) ...[
                    InkWell(
                      onTap: () async {
                        if (tagSelected.isEmpty ||
                            _descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please fill out the video details first')));
                        } else {
                          if (widget.title == null ||
                              widget.hastags == null ||
                              widget.topic == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Something went wrong, Please try again')));
                          } else {
                            final XFile? file = await _picker.pickVideo(
                                source: ImageSource.camera,
                                maxDuration: const Duration(minutes: 3));

                            if (file != null) {
                              setState(() {
                                _video = File(file.path);
                                loading = true;
                              });
                              await uploadVideoController.uploadContent(
                                  context: context,
                                  video: _video,
                                  videoDescription: _descriptionController.text,
                                  videoHastags: hashTags,
                                  videoTag: tagSelected,
                                  videoTitle: widget.title!,
                                  videoTopic: widget.topic!,
                                  publisherProfilePic: userProfilePic,
                                  publishersName: userName);
                            }
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      },
                      child: Container(
                        height: screenHeight(context) * 0.088,
                        color: Colors.black,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              txt(
                                  txt: 'MAKE VIDEO',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontColor: Colors.white),
                              SizedBox(
                                width: screenWidth(context) * 0.03,
                              ),
                              Transform.rotate(
                                angle: pi,
                                child: SvgPicture.asset(
                                  'assets/svgs/arrowForward.svg',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding topicWidget(BuildContext context, {String? text, int? topic}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        height: screenHeight(context) * 0.04,
        width: screenWidth(context) * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: topic == 0 ? Colors.white : const Color(blueColor),
          border: topic == 0
              ? Border.all(
                  width: 0.5,
                  color: const Color(0xFF707070),
                )
              : Border.all(
                  width: 0,
                  color: Colors.transparent,
                ),
        ),
        child: Center(
          child: txt(
              txt: text!,
              fontSize: 11,
              fontColor:
                  topic == 0 ? Colors.black.withOpacity(0.5) : Colors.white),
        ),
      ),
    );
  }
}
