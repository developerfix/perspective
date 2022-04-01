import 'package:flutter/material.dart';

import 'package:perspective/screens/makeVideo/q1.dart';

class MakeVideo extends StatefulWidget {
  const MakeVideo({Key? key}) : super(key: key);

  @override
  State<MakeVideo> createState() => _MakeVideoState();
}

class _MakeVideoState extends State<MakeVideo> {
  @override
  Widget build(BuildContext context) {
    return const Question1();
  }
}
