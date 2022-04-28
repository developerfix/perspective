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

class Question4And5 extends StatefulWidget {
  final List? hastags;
  // final String? titlee;
  final bool? isAddingToThChain;

  final String? selectedTopic;
  final String? title;
  final String? perspectiveTag;
  const Question4And5(
      {Key? key,
      this.perspectiveTag,
      this.selectedTopic,
      // this.titlee,
      this.hastags,
      this.isAddingToThChain,
      this.title})
      : super(key: key);

  @override
  State<Question4And5> createState() => _Question4And5State();
}

class _Question4And5State extends State<Question4And5> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hashtagController = TextEditingController();
  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  bool? p1 = false;
  bool? p2 = false;
  bool? p3 = false;
  bool? p4 = false;
  bool? p5 = false;

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

    widget.isAddingToThChain! ? hashTags = widget.hastags! : [];

    getUserName();
  }

  showSnackBar(String snackText) {
    final snackBar = SnackBar(content: Text(snackText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.to(const BNB());

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
                  SizedBox(
                    height: screenHeight(context) * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.topToBottom,
                                    child: Question2And3(
                                      hastags: widget.hastags,
                                      isAddingToThChain:
                                          widget.isAddingToThChain,
                                      title: widget.title,
                                      selectedTopic: widget.selectedTopic,
                                    )));
                          },
                          child: Container(
                            width: screenWidth(context) * 0.08,
                            height: screenHeight(context) * 0.05,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF3B5998),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.16),
                                  offset: const Offset(0, 3.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: screenHeight(context) * 0.005,
                                ),
                                const RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                            txt: 'Almost There',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        SizedBox(
                          height: screenHeight(context) * 0.005,
                        ),
                        LinearPercentIndicator(
                          barRadius: const Radius.circular(8),
                          // width: screenWidth(context),
                          lineHeight: screenHeight(context) * 0.015,
                          percent: 1,
                          backgroundColor: Colors.black.withOpacity(0.2),
                          progressColor: const Color(blueColor),
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
                        txt(txt: 'Hastags', fontSize: 14),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        textField(
                            isDisabled:
                                widget.isAddingToThChain! ? true : false,
                            onChanged: (value) {
                              hashTags = extractHashTags(value);
                            },
                            hinttext: '#...',
                            controller: _hashtagController,
                            context: context),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        hashTags!.isNotEmpty
                            ? txt(txt: 'Selected Hastags', fontSize: 14)
                            : Container(),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        hashTags!.isNotEmpty
                            ? txt(
                                txt: hashTags.toString(),
                                fontSize: 14,
                                fontColor: const Color(blueColor))
                            : Container(),
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
                        if (widget.perspectiveTag!.isEmpty ||
                                widget.selectedTopic!.isEmpty ||
                                widget.title!.isEmpty ||
                                _descriptionController.text.isEmpty ||
                                widget.isAddingToThChain!
                            ? hashTags!.isEmpty
                            : _hashtagController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please fill out the video details first')));
                        } else {
                          final XFile? file = await _picker.pickVideo(
                            source: ImageSource.gallery,
                            // maxDuration: const Duration(minutes: 2)
                          );

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
                                videoTag: widget.perspectiveTag!,
                                videoTitle: widget.title!,
                                videoTopic: widget.selectedTopic,
                                publisherProfilePic: userProfilePic,
                                publishersName: userName);
                          }
                          setState(() {
                            loading = false;
                          });
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
