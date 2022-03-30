import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:perspective/res.dart';
import "dart:math" show pi;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context),
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
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
          Align(
            alignment: Alignment.center,
            child: SvgPicture.string(
              '<svg viewBox="174.78 378.56 39.9361 39.93" ><path transform="translate(174.22, 377.99)" d="M 20.52500152587891 0.5625 C 9.497329711914062 0.5625 0.5625 9.497329711914062 0.5625 20.52500152587891 C 0.5625 31.55267333984375 9.497329711914062 40.48750686645508 20.52500152587891 40.48750686645508 C 31.55267333984375 40.48750686645508 40.48750686645508 31.55267333984375 40.48750686645508 20.52500152587891 C 40.48750686645508 9.497329711914062 31.55267333984375 0.5625 20.52500152587891 0.5625 Z M 29.8381519317627 22.45685577392578 L 15.67121505737305 30.58674240112305 C 14.39941215515137 31.29509162902832 12.79758167266846 30.3855094909668 12.79758167266846 28.89637184143066 L 12.79758167266846 12.15362930297852 C 12.79758167266846 10.67253971099854 14.39136123657227 9.754909515380859 15.67121505737305 10.46325588226318 L 29.8381519317627 19.07611083984375 C 31.15825271606445 19.81665420532227 31.15825271606445 21.72436141967773 29.8381519317627 22.45685577392578 Z" fill="#3b5998" stroke="none" stroke-width="5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
              height: screenHeight(context) * 0.08,
            ),
          ),
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
                      offset: Offset(0.5, 0.5),
                      color: Color(blueColor).withOpacity(0.5),
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
                                child: popupmenuItem('Conservative', '3%'),
                              ),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: GestureDetector(
                                onTap: () {},
                                child: popupmenuItem('Neutral', '3%'),
                              ),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: GestureDetector(
                                onTap: () {},
                                child: popupmenuItem('Liberal', '3%'),
                              ),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: GestureDetector(
                                onTap: () {},
                                child: popupmenuItem('Very Liberal', '3%'),
                              ),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: GestureDetector(
                                onTap: () {},
                                child: popupmenuItem('Very Conservative', '3%'),
                              ),
                              value: 1,
                            ),
                          ]),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 120),
              child: Container(
                width: screenWidth(context) * 0.13,
                height: screenHeight(context) * 0.08,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3B5998),
                ),
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
                          backgroundImage: AssetImage('assets/images/girl.png'),
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
                child: SvgPicture.asset('assets/svgs/perspective.svg'),
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
    );
  }

  Row popupmenuItem(String? itemText, String? itemPercentage) {
    return Row(
      children: [
        txt(txt: itemText, fontSize: 12, fontColor: Colors.white),
        Spacer(),
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
                fontColor: Color(blueColor)),
          ),
        )
      ],
    );
  }
}
