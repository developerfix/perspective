import 'package:flutter/material.dart';
import 'package:perspective/res.dart';

class MakeVideo extends StatefulWidget {
  const MakeVideo({Key? key}) : super(key: key);

  @override
  State<MakeVideo> createState() => _MakeVideoState();
}

class _MakeVideoState extends State<MakeVideo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight(context) * 0.95,
            width: screenWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
