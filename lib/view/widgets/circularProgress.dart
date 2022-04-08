import 'package:flutter/material.dart';
import 'package:slant/res.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Color(blueColor),
    );
  }
}
