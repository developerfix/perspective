import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:slant/res.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slant/view/screens/makeVideo/q1.dart';
import 'package:slant/view/screens/makeVideo/q4_5.dart';

import '../../../bnb.dart';

class Question2And3 extends StatefulWidget {
  final String? selectedTopic;
  const Question2And3({Key? key, this.selectedTopic}) : super(key: key);

  @override
  State<Question2And3> createState() => _Question2And3State();
}

class _Question2And3State extends State<Question2And3> {
  final TextEditingController _titleController = TextEditingController();

  bool? p1 = false;
  bool? p2 = false;
  bool? p3 = false;
  bool? p4 = false;
  bool? p5 = false;
  String tagSelected = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.selectedTopic);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => const BNB()),
          ),
        );

        return Future<bool>(
          () => true,
        );
      },
      child: SafeArea(
        child: Scaffold(
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
                                      child: const Question1()));
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
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt(
                            txt: '2 more to go...',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        SizedBox(
                          height: screenHeight(context) * 0.005,
                        ),
                        LinearPercentIndicator(
                          barRadius: const Radius.circular(8),
                          lineHeight: screenHeight(context) * 0.015,
                          percent: 0.5,
                          backgroundColor: Colors.black.withOpacity(0.2),
                          progressColor: const Color(blueColor),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        txt(txt: 'Please give it a title', fontSize: 14),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        textField(
                            hinttext: 'Title',
                            controller: _titleController,
                            context: context),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        txt(txt: 'Is your Persective', fontSize: 14),
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
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        txt(
                            txt: 'Add description',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.black.withOpacity(0.3)),
                        SizedBox(
                          width: screenWidth(context) * 0.03,
                        ),
                        InkWell(
                            onTap: () {
                              if (_titleController.text.isEmpty ||
                                  tagSelected.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please complete the form first')));
                              } else {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: Question4And5(
                                          perspectiveTag: tagSelected,
                                          title: _titleController.text,
                                          selectedTopic: widget.selectedTopic,
                                        )));
                              }
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
                                  const RotatedBox(
                                    quarterTurns: 3,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.005,
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
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
