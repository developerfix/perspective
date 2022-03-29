import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:perspective/auth/signup.dart';
import 'package:perspective/res.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool? isVisible;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    isVisible = false;
  }

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
              children: [
                SizedBox(
                  height: screenHeight(context) * 0.425,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 20,
                        child: SvgPicture.string(
                          // Polygon
                          '<svg viewBox="60.0 386.0 33.0 17.0" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 93.0, 403.0)" d="M 16.49999237060547 0 L 33 17 L 0 17 Z" fill="#1d1a2f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          width: 33.0,
                          height: screenHeight(context) * 0.025,
                        ),
                      ),
                      Container(
                        height: screenHeight(context) * 0.4,
                        color: const Color(0xFF1D1A2F),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: 'logo',
                              child: SvgPicture.asset(
                                'assets/svgs/logo.svg',
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.02,
                            ),
                            txt(
                                txt:
                                    'Hear and Be heard! Your Perspective matters',
                                fontColor: Colors.white,
                                fontSize: 14)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      txt(
                          txt: 'Login',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      SizedBox(
                        height: screenHeight(context) * 0.02,
                      ),
                      txt(
                          txt: 'Enter you email and password',
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                      SizedBox(
                        height: screenHeight(context) * 0.03,
                      ),
                      textField(
                        context: context,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        controller: _emailcontroller,
                        onChanged: (value) {},
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.02,
                      ),
                      textField(
                        context: context,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        controller: _passwordcontroller,
                        isobscuretext: isVisible! ? false : true,
                        hinttext: 'Password',
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isVisible = !isVisible!;
                            });
                          },
                          child: Icon(
                            isVisible!
                                ? Icons.visibility_outlined
                                : Icons.visibility_off,
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              txt(txt: 'Forgot Password?', fontSize: 12),
                              Row(
                                children: [
                                  txt(
                                      txt: 'Don\'t have an account?',
                                      fontSize: 12),
                                  navigator(
                                    function: const SignUp(),
                                    child: txt(
                                        txt: ' Sign up ',
                                        fontSize: 12,
                                        fontColor: const Color(blueColor)),
                                  ),
                                  txt(txt: 'here', fontSize: 12),
                                ],
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: screenHeight(context) * 0.088,
                        color: const Color(blueColor),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svgs/facebook.svg',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: screenHeight(context) * 0.088,
                        color: const Color(0xFF1D1A2F),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              txt(
                                  txt: 'SIGN IN',
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
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
