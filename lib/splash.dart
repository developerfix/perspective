import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slant/auth/login.dart';
import 'package:slant/res.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: navigator(
                function: const Login(),
                child: Hero(
                    tag: 'logo',
                    child: SvgPicture.asset('assets/svgs/logo.svg'))),
          ),
          SizedBox(
            height: screenHeight(context) * 0.02,
          ),
          txt(fontWeight: FontWeight.bold, txt: 'Slant', fontSize: 24)
        ],
      ),
    );
  }
}
