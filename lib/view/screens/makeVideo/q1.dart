import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:slant/res.dart';

import 'package:page_transition/page_transition.dart';
import 'package:slant/view/screens/makeVideo/q2_3.dart';

import '../../../bnb.dart';

class Question1 extends StatefulWidget {
  const Question1({Key? key}) : super(key: key);

  @override
  State<Question1> createState() => _Question1State();
}

class _Question1State extends State<Question1> {
  bool? p1 = false;
  bool? p2 = false;
  bool? p3 = false;
  bool? p4 = false;
  bool? p5 = false;
  bool? p6 = false;
  bool? p7 = false;
  bool? p8 = false;

  String topicSelected = '';

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
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight(context) * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt(
                            txt: 'Lets Start',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        SizedBox(
                          height: screenHeight(context) * 0.005,
                        ),
                        LinearPercentIndicator(
                          barRadius: const Radius.circular(8),
                          lineHeight: screenHeight(context) * 0.015,
                          percent: 0.2,
                          backgroundColor: Colors.black.withOpacity(0.2),
                          progressColor: const Color(blueColor),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        txt(
                            txt: 'What do you want to share\nperspective on',
                            fontSize: 14),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p1 = true;
                              topicSelected =
                                  mySenseOfBelongingAndItsRepresentation;
                              if (p1 == true) {
                                p2 = false;
                                p3 = false;
                                p4 = false;
                                p5 = false;
                                p6 = false;
                                p7 = false;
                                p8 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: mySenseOfBelongingAndItsRepresentation,
                              topic: p1 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p2 = true;
                              topicSelected = whatsHappeningAroundTheWorld;
                              if (p2 == true) {
                                p1 = false;
                                p3 = false;
                                p4 = false;
                                p5 = false;
                                p6 = false;
                                p7 = false;
                                p8 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: whatsHappeningAroundTheWorld,
                              topic: p2 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p3 = true;
                              topicSelected = howSocietyAroundMeFunctions;
                              if (p3 == true) {
                                p1 = false;
                                p2 = false;
                                p4 = false;
                                p5 = false;
                                p6 = false;
                                p7 = false;
                                p8 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: howSocietyAroundMeFunctions,
                              topic: p3 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p4 = true;
                              topicSelected = myLifestyle;
                              if (p4 == true) {
                                p1 = false;
                                p3 = false;
                                p2 = false;
                                p5 = false;
                                p6 = false;
                                p7 = false;
                                p8 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: myLifestyle, topic: p4 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p5 = true;
                              topicSelected = myReligion;
                              if (p5 == true) {
                                p1 = false;
                                p3 = false;
                                p4 = false;
                                p2 = false;
                                p6 = false;
                                p7 = false;
                                p8 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: myReligion, topic: p5 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p6 = true;
                              topicSelected = whatISeeOnMyTV;
                              if (p6 == true) {
                                p1 = false;
                                p3 = false;
                                p4 = false;
                                p5 = false;
                                p2 = false;
                                p7 = false;
                                p8 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: whatISeeOnMyTV, topic: p6 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p7 = true;
                              topicSelected = myIdentity;
                              if (p7 == true) {
                                p1 = false;
                                p3 = false;
                                p4 = false;
                                p5 = false;
                                p6 = false;
                                p2 = false;
                                p8 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: myIdentity, topic: p7 == true ? 1 : 0),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              p8 = true;
                              topicSelected = moneyAndFinances;
                              if (p8 == true) {
                                p1 = false;
                                p3 = false;
                                p4 = false;
                                p5 = false;
                                p6 = false;
                                p7 = false;
                                p2 = false;
                              }
                            });
                          },
                          child: topicWidget(context,
                              text: moneyAndFinances,
                              topic: p8 == true ? 1 : 0),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        txt(
                            txt: 'Please give it a title',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.black.withOpacity(0.3)),
                        SizedBox(
                          width: screenWidth(context) * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                            if (topicSelected.isNotEmpty) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: Question2And3(
                                    selectedTopic: topicSelected,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please select the topic first')));
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
                          ),
                        )
                      ],
                    ),
                  ],
                ),
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
