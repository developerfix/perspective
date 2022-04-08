import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slant/controller/video_controller.dart';
import 'package:slant/res.dart';
import "dart:math" show pi;

import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  final XFile? file;

  const HomeScreen({Key? key, this.file}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VideoPlayerController? _controller =
      VideoPlayerController.asset('assets/images.facebook.png');
  bool isFavourite = false;

  Future<void> _playVideo(XFile? file) async {
    _controller = VideoPlayerController.file(File(file!.path));
    await _controller!.initialize();
    await _controller!.setLooping(true);
    await _controller!.play();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.file != null ? _playVideo(widget.file) : null;
  }

  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: screenHeight(context),
        child: Stack(
          children: [
            Positioned.fill(
                child: _controller != null
                    ? AspectRatioVideo(_controller)
                    : Image.asset(
                        'assets/images/image.png',
                        fit: BoxFit.fitHeight,
                      )),
            Transform.rotate(
              angle: 180.0 * pi / 180,
              child: Container(
                height: screenHeight(context) * 0.2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF8B7070),
                      Colors.black.withOpacity(0.0),
                      Colors.white
                    ],
                    stops: const [0.0, 0.0, 1.0],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.rotate(
                angle: 180 * pi / 180,
                child: Container(
                  height: screenHeight(context) * 0.6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF8B7070),
                        Colors.black.withOpacity(0.0),
                        Colors.white
                      ],
                      stops: const [0.0, 0.0, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            widget.file != null
                ? InkWell(
                    onTap: () {
                      setState(() {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                          Timer(
                              const Duration(seconds: 2),
                              () => setState(() {
                                    _isPlaying = false;
                                  }));
                        } else {
                          _controller!.play();
                          setState(() {
                            _isPlaying = true;
                          });
                        }
                      });
                    },
                    child: Align(
                        alignment: Alignment.center,
                        child: _controller!.value.isPlaying
                            ? _isPlaying
                                ? const Icon(
                                    Icons.pause_circle,
                                    color: Color(
                                      blueColor,
                                    ),
                                    size: 80,
                                  )
                                : Container()
                            : const Icon(
                                Icons.play_circle_rounded,
                                color: Color(
                                  blueColor,
                                ),
                                size: 80,
                              )),
                  )
                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(children: [
                          txt(
                            txt: '37%',
                            fontColor: const Color(blueColor),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          txt(
                            txt: ' audience labelled this video as ',
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.black45,
                            fontSize: 12,
                          ),
                          txt(
                            txt: '#very liberal',
                            fontColor: const Color(blueColor),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ]),
                        txt(
                          txt: 'What do you think?',
                          fontColor: const Color(blueColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    const Spacer(),
                    PopupMenuButton(
                        offset: const Offset(0, -250),
                        color: const Color(blueColor),
                        onSelected: (value) {
                          // selectedValue(value);
                        },
                        elevation: 3.2,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: SvgPicture.asset('assets/svgs/microphone.svg'),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: GestureDetector(
                                  onTap: () {},
                                  child:
                                      popupmenuItem('Very Conservative', '3%'),
                                ),
                                value: 1,
                              ),
                              PopupMenuItem(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: popupmenuItem('Conservative', '3%'),
                                ),
                                value: 2,
                              ),
                              PopupMenuItem(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: popupmenuItem('Neutral', '3%'),
                                ),
                                value: 3,
                              ),
                              PopupMenuItem(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: popupmenuItem('Liberal', '3%'),
                                ),
                                value: 4,
                              ),
                              PopupMenuItem(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: popupmenuItem('Very Liberal', '3%'),
                                ),
                                value: 5,
                              ),
                            ]),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 120),
                child: SizedBox(
                  width: screenWidth(context) * 0.13,
                  height: screenHeight(context) * 0.08,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/svgs/brain.svg'),
                      txt(
                          txt: '26',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontColor: Colors.white)
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: SizedBox(
                    width: screenWidth(context) * 0.65,
                    height: screenHeight(context) * 0.08,
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            maxRadius: 40,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/girl.png'),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              txt(
                                txt: 'Alexa A. Williams perspective on',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              txt(
                                  txt: '#Bidens no war policy',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontColor: const Color(blueColor)),
                              txt(
                                  txt: '#BeingNeutral',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontColor: const Color(blueColor))
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 80),
                  child: SvgPicture.asset('assets/svgs/slant.svg'),
                )),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SvgPicture.asset('assets/svgs/share.svg'),
                  SizedBox(
                    width: screenWidth(context) * 0.03,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                    },
                    child: SizedBox(
                      height: screenHeight(context) * 0.04,
                      child: isFavourite
                          ? const Icon(
                              Icons.favorite,
                              color: Color(redColor),
                              size: 30,
                            )
                          : SvgPicture.asset('assets/svgs/heart.svg'),
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row popupmenuItem(String? itemText, String? itemPercentage) {
    return Row(
      children: [
        txt(txt: itemText, fontSize: 12, fontColor: Colors.white),
        const Spacer(),
        Container(
          width: 24.0,
          height: 24.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: txt(
                txt: itemPercentage,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontColor: const Color(blueColor)),
          ),
        )
      ],
    );
  }
}
