import 'package:flutter/material.dart';
import 'package:slant/res.dart';

class Invite extends StatefulWidget {
  const Invite({Key? key}) : super(key: key);

  @override
  State<Invite> createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1D1A2F),
        body: Column(
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
                    txt(txt: 'Invite', fontSize: 18, fontColor: Colors.white),
                    Container(
                      width: screenWidth(context) * 0.05,
                    )
                  ],
                ),
              ),
            ),
            Column(children: [
              SizedBox(height: screenHeight(context) * 0.05),
              SizedBox(
                width: screenWidth(context) * 0.8,
                child: const Text(
                  'Invite your friends and family to share their perspective on this specific title and hashtag',
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
                  child:
                      txt(txt: 'Invite', fontSize: 13, fontColor: Colors.white),
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
          ],
        ),
      ),
    );
  }
}
