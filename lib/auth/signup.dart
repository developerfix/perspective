import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:slant/auth/interested.dart';
import 'package:slant/res.dart';

import '../view/widgets/circularProgress.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool? termsChecked;
  bool? isVisible;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _confirmPasswordcontroller =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    termsChecked = false;
    isVisible = false;
    _emailcontroller.text = '';
    _passwordcontroller.text = '';
    _namecontroller.text = '';
    _confirmPasswordcontroller.text = '';
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmPasswordcontroller.dispose();
    _namecontroller.dispose();
    super.dispose();
  }

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  Future<void> addUserInfo() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    return users.doc(userId).set({
      'email': _emailcontroller.text.trim(),
      'topicsOfInterest': [0],
      'name': _namecontroller.text,
      'profilePic': '',
      'bio': 'new account',
      'perspectiveRequests': 0
    }).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something went wrong, Please try again')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              // height: screenHeight(context),
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
                              SvgPicture.asset(
                                'assets/svgs/logo.svg',
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: screenHeight(context) * 0.02,
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
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt(
                            txt: 'Signup',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        textField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please enter the name';
                            }
                            return null;
                          },
                          context: context,
                          hinttext: 'Name',
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                          controller: _namecontroller,
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        textField(
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
                          validator: passwordValidator,
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
                        textField(
                          validator: (val) => MatchValidator(
                                  errorText: 'passwords do not match')
                              .validateMatch(val!, _passwordcontroller.text),
                          context: context,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),
                          controller: _confirmPasswordcontroller,
                          isobscuretext: isVisible! ? false : true,
                          hinttext: 'Confirm Password',
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
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.03,
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    termsChecked = !termsChecked!;
                                  });
                                },
                                child: Icon(
                                    termsChecked!
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    size: 18)),
                            SizedBox(
                              width: screenWidth(context) * 0.02,
                            ),
                            txt(txt: 'Terms and Conditions', fontSize: 12),
                          ],
                        ),
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
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 0.1,
                                  color: const Color(0xff8A9EAD),
                                ),
                              ),
                              height: screenHeight(context) * 0.088,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/arrowForward.svg',
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.03,
                                    ),
                                    txt(
                                      txt: 'BACK',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (_emailcontroller.text.isNotEmpty) {
                                if (_formKey.currentState!.validate()) {
                                  if (termsChecked == true) {
                                    signUpWithMail();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please check the terms and conditions')),
                                    );
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    txt(
                                        txt: 'PROCEED',
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
                        )
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUpWithMail() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim());
      await addUserInfo();
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const Interested())));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Successful')),
      );
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used.";
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
          error = "Signup failed. Please try again.";
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
