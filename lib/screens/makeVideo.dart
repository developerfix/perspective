import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:perspective/res.dart';
import 'dart:math';
// // List<CameraDescription> cameras;

//   Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // cameras = await availableCameras();
//   runApp(const MakeVideo());
// }

class MakeVideo extends StatefulWidget {
  const MakeVideo({Key? key}) : super(key: key);

  @override
  State<MakeVideo> createState() => _MakeVideoState();
}

class _MakeVideoState extends State<MakeVideo> {
  // late CameraController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   // controller = CameraController(cameras[0], ResolutionPreset.max);
  //   controller.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //   });
  // }

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }

  Object _dropDownValue = 'What’s happening in my country';
  Object _dropDownValue2 = 'Neutral';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hastagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight(context) * 0.95,
            width: screenWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight(context) * 0.08,
                  color: const Color(0xFF080808),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.white),
                        txt(
                            txt: 'Perspective details',
                            fontSize: 18,
                            fontColor: Colors.white),
                        Container(
                          width: screenWidth(context) * 0.05,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight(context) * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      txt(
                          txt: 'What do you want to share perspective on',
                          fontSize: 14),
                      SizedBox(
                        height: screenHeight(context) * 0.005,
                      ),
                      DropdownButton(
                        hint: Text(
                          _dropDownValue.toString(),
                          style: const TextStyle(color: Colors.black45),
                        ),
                        // isExpanded: true,
                        iconSize: 30.0,
                        style: const TextStyle(color: Colors.black45),
                        items: [
                          'What’s happening around the world',
                          'My sense of belonging and it’s representation',
                          'How society around me functions',
                          'My Lifestyle',
                          'My Religion',
                          'What I see online/on my TV',
                          'My identity',
                          'Money and finances',
                        ].map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                            () {
                              _dropDownValue = val!;
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.03,
                      ),
                      txt(txt: 'Please give it a title', fontSize: 14),
                      SizedBox(
                        height: screenHeight(context) * 0.01,
                      ),
                      textField(
                        hinttext: "Title",
                        context: context,
                        controller: _titleController,
                        onChanged: (value) {},
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.03,
                      ),
                      txt(txt: 'Is your perspective', fontSize: 14),
                      SizedBox(
                        height: screenHeight(context) * 0.005,
                      ),
                      DropdownButton(
                        hint: Text(
                          _dropDownValue2.toString(),
                          style: const TextStyle(color: Colors.black45),
                        ),
                        // isExpanded: true,
                        iconSize: 30.0,
                        style: const TextStyle(color: Colors.black45),
                        items: [
                          'Very Conservative',
                          'Conservative',
                          'Neutral',
                          'Liberal',
                          'Very Liberal',
                        ].map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                            () {
                              _dropDownValue2 = val!;
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.03,
                      ),
                      txt(txt: 'Add Descriptions', fontSize: 14),
                      SizedBox(
                        height: screenHeight(context) * 0.005,
                      ),
                      textField(
                        maxlines: 5,
                        hinttext: "...",
                        context: context,
                        controller: _descriptionController,
                        onChanged: (value) {},
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.03,
                      ),
                      txt(txt: 'Hashtags', fontSize: 14),
                      SizedBox(
                        height: screenHeight(context) * 0.005,
                      ),
                      textField(
                        hinttext: "...",
                        context: context,
                        controller: _hastagsController,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                navigator(
                  // function: const BNB(),
                  child: Container(
                    height: screenHeight(context) * 0.088,
                    color: Colors.black,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          txt(
                              txt: 'Make Video',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
