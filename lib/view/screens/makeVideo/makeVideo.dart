import 'package:slant/view/screens/makeVideo/q1.dart';
import 'package:flutter/material.dart';

class MakeVideo extends StatefulWidget {
  final List? hastags;
  final String? title;
  final bool? isAddingToThChain;

  const MakeVideo({Key? key, this.hastags, this.isAddingToThChain, this.title})
      : super(key: key);

  @override
  State<MakeVideo> createState() => _MakeVideoState();
}

class _MakeVideoState extends State<MakeVideo> {
  @override
  Widget build(BuildContext context) {
    return Question1(
      isAddingToThChain: widget.isAddingToThChain,
      hastags: widget.hastags,
      title: widget.title,
    );
  }
}
