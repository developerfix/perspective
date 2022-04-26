import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slant/res.dart';
import 'package:slant/view/widgets/circularProgress.dart';
import 'dart:math';

import '../../../bnb.dart';
import '../../../models/video.dart';

class Invite extends StatefulWidget {
  final Video? video;
  const Invite({Key? key, this.video}) : super(key: key);

  @override
  State<Invite> createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  List userIDs = [];
  bool checkValue = false;
  bool loading = false;

  void onUserSelected(bool selected, userId) {
    if (selected == true) {
      setState(() {
        userIDs.add(userId);
      });
    } else {
      setState(() {
        userIDs.remove(userId);
      });
    }
  }

  sendingRequestToUsers() async {
    String userName = '';
    String userProfileUrl = '';

    if (userIDs.isNotEmpty) {
      setState(() {
        loading = true;
      });
      await usersCollection.doc(userId).get().then((value) {
        userName = (value.data() as Map)['name'];
        userProfileUrl = (value.data() as Map)['profilePic'];
      });
      for (var userID in userIDs) {
        await usersCollection
            .doc(userID)
            .collection('perspectiveRequests')
            .add(({
              'userID': userId,
              'userName': userName,
              'userProfileUrl': userProfileUrl,
              'videoDetails': widget.video!.toJson()
            }))
            .then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: ((context) => const BNB()),
              ),
              (Route<dynamic> route) => false);
        }).onError((error, stackTrace) {
          Container();
        });
      }
      setState(() {
        loading = false;
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: ((context) => const BNB()),
          ),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1D1A2F),
        body: SizedBox(
          height: screenHeight(context),
          width: screenWidth(context),
          child: Stack(
            children: [
              Positioned.fill(
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
                                txt: 'Invite',
                                fontSize: 18,
                                fontColor: Colors.white),
                            Container(
                              width: screenWidth(context) * 0.05,
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(children: [
                      SizedBox(height: screenHeight(context) * 0.03),
                      SizedBox(
                        width: screenWidth(context) * 0.8,
                        child: const Text(
                          'Invite your friends and family to share their perspective on this specific title and hashtag video you just published',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: screenHeight(context) * 0.03),
                      Container(
                        width: screenWidth(context) * 0.5,
                        height: screenHeight(context) * 0.055,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: const Color(0xFF3B5998),
                        ),
                        child: Center(
                          child: txt(
                              txt: 'Invite',
                              fontSize: 13,
                              fontColor: Colors.white),
                        ),
                      ),
                      SizedBox(height: screenHeight(context) * 0.03),
                      Text(
                        'Invite the slant users',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight(context) * 0.05),
                    ]),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: usersCollection.snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData || snapshot.hasError) {
                                return const Center(
                                  child: Text(
                                    'No users',
                                  ),
                                );
                              } else if (snapshot.data!.docs.isNotEmpty) {
                                return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot doc =
                                          snapshot.data!.docs[index];
                                      var data = (doc.data() as Map);

                                      return snapshot.data!.docs[index].id ==
                                              userId
                                          ? Container()
                                          : CheckboxListTile(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              checkColor:
                                                  const Color(blueColor),
                                              activeColor: Colors.white,
                                              title: txt(
                                                  txt: data['name'],
                                                  fontSize: 18,
                                                  fontColor: Colors.white),
                                              subtitle: txt(
                                                txt: data['bio'],
                                                fontSize: 14,
                                                fontColor: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                              value: userIDs.contains(snapshot
                                                  .data!.docs[index].id),
                                              onChanged: (value) {
                                                onUserSelected(
                                                    value!,
                                                    snapshot
                                                        .data!.docs[index].id);
                                              },
                                            );
                                    });
                              } else {
                                return const Center(child: Text('No users'));
                              }
                            }),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: loading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          txt(
                              txt: 'Please wait, sending request to users',
                              fontColor: Colors.white,
                              fontSize: 18),
                          SizedBox(
                            height: screenHeight(context) * 0.05,
                          ),
                          const CircularProgress(),
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          sendingRequestToUsers();
                        },
                        child: Container(
                          height: screenHeight(context) * 0.088,
                          color: Colors.black,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                txt(
                                    txt: 'Done',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
