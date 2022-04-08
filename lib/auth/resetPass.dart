import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../res.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final auth = FirebaseAuth.instance;
  final TextEditingController _emailcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailcontroller.text = '';
  }

  @override
  void dispose() {
    super.dispose();

    _emailcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt(
                            txt: 'Reset Password',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        txt(
                            txt:
                                'Enter you email address to reset your password',
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        SizedBox(
                          height: screenHeight(context) * 0.03,
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
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if (_emailcontroller.text.isNotEmpty) {
                        if (_formKey.currentState!.validate()) {
                          auth.sendPasswordResetEmail(
                              email: _emailcontroller.text);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Request sent to your email, Please check')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter the email address')),
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
                                txt: 'Send Request',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontColor: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
