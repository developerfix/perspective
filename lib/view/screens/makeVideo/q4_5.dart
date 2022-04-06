import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:slant/controller/video_controller.dart';
import 'package:slant/res.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:slant/bnb.dart';
import 'package:slant/res.dart';
import 'package:slant/view/screens/homeScreen.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';

class Question4And5 extends StatefulWidget {
  const Question4And5({Key? key}) : super(key: key);

  @override
  State<Question4And5> createState() => _Question4And5State();
}

class _Question4And5State extends State<Question4And5> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hashtagController = TextEditingController();

  bool? p1 = false;
  bool? p2 = false;
  bool? p3 = false;
  bool? p4 = false;
  bool? p5 = false;

  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _controller;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  padding: const EdgeInsets.all(40.0),
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
                      txt(txt: 'Add Description', fontSize: 14),
                      SizedBox(
                        height: screenHeight(context) * 0.02,
                      ),
                      textField(
                          maxlines: 8,
                          hinttext: '...',
                          controller: _titleController,
                          context: context),
                      SizedBox(
                        height: screenHeight(context) * 0.05,
                      ),
                      txt(txt: 'Hastags', fontSize: 14),
                      SizedBox(
                        height: screenHeight(context) * 0.02,
                      ),
                      textField(
                          hinttext: '...',
                          controller: _hashtagController,
                          context: context),
                      SizedBox(
                        height: screenHeight(context) * 0.02,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    final XFile? file = await _picker.pickVideo(
                        source: ImageSource.camera,
                        maxDuration: const Duration(minutes: 2));

                    if (file != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => BNB(
                            file: file,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Video published successfully')));
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
              txt: text,
              fontSize: 11,
              fontColor:
                  topic == 0 ? Colors.black.withOpacity(0.5) : Colors.white),
        ),
      ),
    );
  }
}
