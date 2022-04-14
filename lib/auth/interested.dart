import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slant/bnb.dart';
import 'package:slant/res.dart';
import 'dart:math';

import 'package:slant/view/widgets/circularProgress.dart';

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

  topichecker() async {
    setState(() {
      loading = true;
    });
    try {
      await users.doc(userId).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.data() != null) {
            if (documentSnapshot.get(FieldPath(const ['topicsOfInterest'])) !=
                []) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const BNB()),
                  ),
                  (Route<dynamic> route) => false);
              // Future.delayed(Duration.zero, () {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: ((context) => const BNB())));
              // });
            } else {
              setState(() {
                loading = false;
              });
            }
          }
        }
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      // print('error is  +${e.toString()}');
      Container();
    }
  }

  Future<void> updateUser() async {
    setState(() {
      loading1 = true;
    });
    return await users
        .doc(userId)
        .update({'topicsOfInterest': topicsOfInterest}).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: ((context) => const BNB()),
          ),
          (Route<dynamic> route) => false);
    }).catchError((error) {
      print('error for uploading is + ${error.toString()}');
      setState(() {
        loading1 = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('something went wrong, Please restart the app')));
    });
  }

  @override
  void initState() {
    super.initState();
    // topichecker();
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
                                      topicsOfInterest.add(
                                          'What’s happening in my country');
                                    } else {
                                      topicsOfInterest.remove(
                                          'What’s happening in my country');
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText: 'What’s happening in my country',
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
                                      topicsOfInterest.add(
                                          'What’s happening around the world');
                                    } else {
                                      topicsOfInterest.remove(
                                          'What’s happening around the world');
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText:
                                        'What’s happening around the world',
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
                                          'My sense of belonging and it’s representation');
                                    } else {
                                      topicsOfInterest.remove(
                                          'My sense of belonging and it’s representation');
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText:
                                        'My sense of belonging and it’s representation',
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
                                      topicsOfInterest.add(
                                          'How society around me functions');
                                    } else {
                                      topicsOfInterest.remove(
                                          'How society around me functions');
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText: 'How society around me functions',
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
                                          topicsOfInterest.add('My Lifestyle');
                                        } else {
                                          topicsOfInterest
                                              .remove('My Lifestyle');
                                        }
                                      });
                                    },
                                    child: interestedItems(context,
                                        itemText: 'My Lifestyle',
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
                                          topicsOfInterest.add('My Religion');
                                        } else {
                                          topicsOfInterest
                                              .remove('My Religion');
                                        }
                                      });
                                    },
                                    child: interestedItems(context,
                                        itemText: 'My Religion',
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
                                      topicsOfInterest
                                          .add('What I see online/on my TV');
                                    } else {
                                      topicsOfInterest
                                          .remove('What I see online/on my TV');
                                    }
                                  });
                                },
                                child: interestedItems(context,
                                    itemText: 'What I see online/on my TV',
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
                                          topicsOfInterest.add('My identity');
                                        } else {
                                          topicsOfInterest
                                              .remove('My identity');
                                        }
                                      });
                                    },
                                    child: interestedItems(context,
                                        itemText: 'My identity',
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
                                              .add('Money and finances');
                                        } else {
                                          topicsOfInterest
                                              .remove('Money and finances');
                                        }
                                      });
                                    },
                                    child: interestedItems(context,
                                        itemText: 'Money and finances',
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
