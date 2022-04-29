import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:slant/bnb.dart';
import 'package:slant/res.dart';
import 'dart:math';

import 'package:slant/view/widgets/circular_progress.dart';

class Interested extends StatefulWidget {
  const Interested({Key? key}) : super(key: key);

  @override
  State<Interested> createState() => _InterestedState();
}

class _InterestedState extends State<Interested> {
  bool? topic1Selected = false;
  bool? topic2Selected = false;
  bool? topic3Selected = false;
  bool? topic4Selected = false;
  bool? topic5Selected = false;
  bool? topic6Selected = false;
  bool? topic7Selected = false;
  bool? topic8Selected = false;
  bool? topic9Selected = false;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final List<String> topicsOfInterest = [];

  bool loading = false;
  bool loading1 = false;

  Future<void> updateUser() async {
    setState(() {
      loading1 = true;
    });
    return await users
        .doc(userId)
        .update({'topicsOfInterest': topicsOfInterest}).then((value) {
      Get.offAll(() => const BNB());
    }).catchError((error) {
      setState(() {
        loading1 = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('something went wrong, Please restart the app')));
    });
  }

  topicChecker() {
    setState(() {
      loading = true;
    });
    if (userId != null) {
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        await usersCollection
            .doc(userId)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            if ((documentSnapshot.data() as Map)['topicsOfInterest'] != null) {
              Get.offAll(() => const BNB());
            } else {
              setState(() {
                loading = false;
              });
            }
          }
        });
      });
    }
  }

  @override
  void initState() {
    topicChecker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1D1A2F),
        body: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight(context) * 0.95,
            width: screenWidth(context),
            child: loading
                ? const Center(
                    child: CircularProgress(),
                  )
                : Column(
                    children: [
                      Container(
                        height: screenHeight(context) * 0.08,
                        color: const Color(0xFF080808),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              txt(
                                  txt: 'Welcome',
                                  fontSize: 18,
                                  fontColor: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: screenHeight(context) * 0.05),
                          SizedBox(
                            width: screenWidth(context) * 0.8,
                            child: const Text(
                              'In which of these areas you would like to share and gain perspective ?',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: screenHeight(context) * 0.01),
                          Text(
                            'Choose 3 or more topics from\nthe following list',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight(context) * 0.05),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    topic1Selected = !topic1Selected!;
                                    if (topic1Selected!) {
                                      topicsOfInterest
                                          .add(whatsHappeningInMyCountry);
                                    } else {
                                      topicsOfInterest
                                          .remove(whatsHappeningInMyCountry);
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText: whatsHappeningInMyCountry,
                                    width: screenWidth(context) * 0.5,
                                    color: topic1Selected!
                                        ? const Color(blueColor)
                                        : null),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    topic2Selected = !topic2Selected!;
                                    if (topic2Selected!) {
                                      topicsOfInterest
                                          .add(whatsHappeningAroundTheWorld);
                                    } else {
                                      topicsOfInterest
                                          .remove(whatsHappeningAroundTheWorld);
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText: whatsHappeningAroundTheWorld,
                                    color: topic2Selected!
                                        ? const Color(blueColor)
                                        : null,
                                    width: screenWidth(context) * 0.55),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    topic3Selected = !topic3Selected!;
                                    if (topic3Selected!) {
                                      topicsOfInterest.add(
                                          mySenseOfBelongingAndItsRepresentation);
                                    } else {
                                      topicsOfInterest.remove(
                                          mySenseOfBelongingAndItsRepresentation);
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText:
                                        mySenseOfBelongingAndItsRepresentation,
                                    color: topic3Selected!
                                        ? const Color(blueColor)
                                        : null,
                                    width: screenWidth(context) * 0.68),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    topic4Selected = !topic4Selected!;
                                    if (topic4Selected!) {
                                      topicsOfInterest
                                          .add(howSocietyAroundMeFunctions);
                                    } else {
                                      topicsOfInterest
                                          .remove(howSocietyAroundMeFunctions);
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText: howSocietyAroundMeFunctions,
                                    color: topic4Selected!
                                        ? const Color(blueColor)
                                        : null,
                                    width: screenWidth(context) * 0.5),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        topic5Selected = !topic5Selected!;
                                        if (topic5Selected!) {
                                          topicsOfInterest.add(myLifestyle);
                                        } else {
                                          topicsOfInterest.remove(myLifestyle);
                                        }
                                      });
                                    },
                                    child: interestedItems(context,
                                        itemText: myLifestyle,
                                        color: topic5Selected!
                                            ? const Color(blueColor)
                                            : null,
                                        width: screenWidth(context) * 0.2),
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.02,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        topic6Selected = !topic6Selected!;
                                        if (topic6Selected!) {
                                          topicsOfInterest.add(myReligion);
                                        } else {
                                          topicsOfInterest.remove(myReligion);
                                        }
                                      });
                                    },
                                    child: interestedItems(context,
                                        itemText: myReligion,
                                        color: topic6Selected!
                                            ? const Color(blueColor)
                                            : null,
                                        width: screenWidth(context) * 0.2),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    topic7Selected = !topic7Selected!;
                                    if (topic7Selected!) {
                                      topicsOfInterest.add(whatISeeOnMyTV);
                                    } else {
                                      topicsOfInterest.remove(whatISeeOnMyTV);
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText: whatISeeOnMyTV,
                                    color: topic7Selected!
                                        ? const Color(blueColor)
                                        : null,
                                    width: screenWidth(context) * 0.42),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        topic8Selected = !topic8Selected!;
                                        if (topic8Selected!) {
                                          topicsOfInterest.add(myIdentity);
                                        } else {
                                          topicsOfInterest.remove(myIdentity);
                                        }
                                      });
                                    },
                                    child: interestedItems(context,
                                        itemText: myIdentity,
                                        color: topic8Selected!
                                            ? const Color(blueColor)
                                            : null,
                                        width: screenWidth(context) * 0.2),
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.02,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        topic9Selected = !topic9Selected!;
                                        if (topic9Selected!) {
                                          topicsOfInterest
                                              .add(moneyAndFinances);
                                        } else {
                                          topicsOfInterest
                                              .remove(moneyAndFinances);
                                        }
                                      });
                                    },
                                    child: interestedItems(context,
                                        itemText: moneyAndFinances,
                                        color: topic9Selected!
                                            ? const Color(blueColor)
                                            : null,
                                        width: screenWidth(context) * 0.32),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      if (loading1) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [CircularProgress()],
                        )
                      ],
                      if (!loading1) ...[
                        InkWell(
                          onTap: () {
                            if (topicsOfInterest.length < 3) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please select at least 3 topics')),
                              );
                            } else {
                              updateUser();
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
                                      txt: 'PROCEED',
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
    );
  }

  Padding interestedItems(BuildContext context,
      {String? itemText, double? width, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: width,
        height: screenHeight(context) * 0.035,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          border: color == null
              ? Border.all(
                  width: 1.0,
                  color: Colors.white,
                )
              : Border.all(width: 0, color: Colors.transparent),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: AutoSizeText(
              itemText!,
              maxLines: 1,
              maxFontSize: 12,
              minFontSize: 5,
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
