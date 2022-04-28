import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:slant/auth/login.dart';
import 'package:slant/res.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => Get.to(const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Hero(
                  tag: 'logo',
                  child: SvgPicture.asset('assets/svgs/logo.svg'))),
          SizedBox(
            height: screenHeight(context) * 0.02,
          ),
          txt(fontWeight: FontWeight.bold, txt: 'Slant', fontSize: 24)
        ],
      ),
    );
  }
}
