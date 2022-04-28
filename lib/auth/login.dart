import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart' as getx;
import 'package:slant/auth/interested.dart';
import 'package:slant/auth/reset_pass.dart';
import 'package:slant/bnb.dart';
import 'package:slant/auth/signup.dart';
import 'package:slant/res.dart';
import 'package:slant/view/widgets/circular_progress.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool? isVisible;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool loading1 = false;

  userchecker() {
    setState(() {
      loading1 = true;
    });

    if (userId != null) {
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        await usersCollection
            .doc(userId)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            if ((documentSnapshot.data() as Map)['name'] != 'ahme') {
              getx.Get.offAll(const BNB());
            } else {
              setState(() {
                loading1 = false;
              });
              getx.Get.offAll(const Interested());
            }
          }
        });
      });
    } else {
      setState(() {
        loading1 = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    userchecker();

    isVisible = false;
    _emailcontroller.text = '';
    _passwordcontroller.text = '';
    // _checkIfIsLogged();
  }

  @override
  void dispose() {
    super.dispose();

    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  // Map<String, dynamic>? _userData;
  // AccessToken? _accessToken;
  // bool _checking = true;

  // Future<void> _checkIfIsLogged() async {
  //   final accessToken = await FacebookAuth.instance.accessToken;
  //   setState(() {
  //     _checking = false;
  //   });
  //   if (accessToken != null) {
  //     // now you can call to  FacebookAuth.instance.getUserData();
  //     final userData = await FacebookAuth.instance.getUserData();
  //     // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
  //     _accessToken = accessToken;
  //     setState(() {
  //       _userData = userData;
  //     });
  //   }
  // }

  // Future<void> _loginWithFb() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   try {
  //     final LoginResult result = await FacebookAuth.instance
  //         .login(); // by default we request the email and the public profile

  //     if (result.status == LoginStatus.success) {
  //       _accessToken = result.accessToken;
  //       // get the user data
  //       // by default we get the userId, email,name and picture
  //       final userData = await FacebookAuth.instance.getUserData();
  //       // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
  //       _userData = userData;
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('Something went wrong, Please try again')),
  //       );
  //     }

  //     // PageLinkInfo(
  //     //     transition: LinkTransition.Fade,
  //     //     ease: Curves.easeOut,
  //     //     duration: 0.3,
  //     //     pageBuilder: () => const BNB());
  //   } on FirebaseAuthException catch (e) {
  //     String error = '';
  //     switch (e.code) {
  //       case "ERROR_EMAIL_ALREADY_IN_USE":
  //       case "account-exists-with-different-credential":
  //       case "email-already-in-use":
  //         error = "Email already used.";
  //         break;
  //       case "ERROR_WRONG_PASSWORD":
  //       case "wrong-password":
  //         error = "Wrong email/password combination.";
  //         break;
  //       case "ERROR_USER_NOT_FOUND":
  //       case "user-not-found":
  //         error = "No user found with this email.";
  //         break;
  //       case "ERROR_USER_DISABLED":
  //       case "user-disabled":
  //         error = "User disabled.";
  //         break;
  //       case "ERROR_TOO_MANY_REQUESTS":
  //         error = "Too many requests to log into this account.";
  //         break;
  //       case "ERROR_OPERATION_NOT_ALLOWED":
  //         error = "Server error, please try again later.";
  //         break;
  //       case "ERROR_INVALID_EMAIL":
  //       case "invalid-email":
  //         error = "Email address is invalid.";
  //         break;
  //       default:
  //         error = "Login failed. Please try again.";
  //         break;
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(error)),
  //     );
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading1
            ? const Center(child: CircularProgress())
            : Form(
                key: _formKey,
                child: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container();
                    } else {
                      return SingleChildScrollView(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Hero(
                                            tag: 'logo',
                                            child: SvgPicture.asset(
                                              'assets/svgs/logo.svg',
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.02,
                                          ),
                                          txt(
                                              txt:
                                                  'Hear and Be heard! Your perspective matters',
                                              fontColor: Colors.white,
                                              fontSize: 14)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 15, 30, 15),
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
                                      isDisabled: false,
                                      validator: EmailValidator(
                                          errorText: 'Invalid email address'),
                                      context: context,
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                      ),
                                      controller: _emailcontroller,
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.02,
                                    ),
                                    textField(
                                      isDisabled: false,
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
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            navigator(
                                                function: const ResetScreen(),
                                                child: txt(
                                                    txt: 'Forgot Password?',
                                                    fontSize: 12)),
                                            Row(
                                              children: [
                                                txt(
                                                    txt:
                                                        'Don\'t have an account?',
                                                    fontSize: 12),
                                                navigator(
                                                  function: const SignUp(),
                                                  child: txt(
                                                      txt: ' Sign up ',
                                                      fontSize: 12,
                                                      fontColor: const Color(
                                                          blueColor)),
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
                              if (loading) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgress(),
                                  ],
                                )
                              ],
                              if (!loading) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          // _loginWithFb();
                                        },
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
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (_emailcontroller
                                              .text.isNotEmpty) {
                                            if (_passwordcontroller
                                                .text.isNotEmpty) {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                signIn();
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Please enter the password')),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Please enter the email address')),
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: screenHeight(context) * 0.088,
                                          color: const Color(0xFF1D1A2F),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                txt(
                                                    txt: 'SIGN IN',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontColor: Colors.white),
                                                SizedBox(
                                                  width: screenWidth(context) *
                                                      0.03,
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
                                    )
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
      ),
    );
  }

  Future signIn() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim());

      setState(() {
        loading1 = false;
      });
      getx.Get.offAll(const Interested());
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used.";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          error = "Too many requests to log into this account.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          error = "Server error, please try again later.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          break;
        default:
          error = "Login failed. Please try again.";
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
