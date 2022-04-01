import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:perspective/res.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight(context),
          width: screenWidth(context),
          child: Column(
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
                          txt: 'Profile',
                          fontSize: 18,
                          fontColor: Colors.white),
                      Container(
                        width: screenWidth(context) * 0.05,
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: screenHeight(context) * 0.02,
                  ),
                  Image.asset('assets/images/girl3.png'),
                  SizedBox(
                    height: screenHeight(context) * 0.01,
                  ),
                  txt(
                      txt: 'Alexa A. Williams',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  txt(txt: 'Las vegas,CA', fontSize: 12),
                  SizedBox(
                    height: screenHeight(context) * 0.01,
                  ),
                  txt(
                      txt:
                          'Actor |  Pet lover | Karma believer\nFollow for awesome content <3',
                      fontSize: 12,
                      fontColor: Colors.black.withOpacity(0.5)),
                  SizedBox(
                    height: screenHeight(context) * 0.015,
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth(context) * 0.2,
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          txt(
                              txt: '40.3K',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          txt(txt: 'FOLLOWING', fontSize: 10),
                        ],
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      Column(
                        children: [
                          Container(
                              height: 20,
                              width: 2,
                              color: const Color(0xff707070).withOpacity(0.3)),
                          txt(txt: '', fontSize: 5),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          txt(
                              txt: '993K',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          txt(txt: 'FOLLOWERS', fontSize: 10),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Container(
                              height: 20,
                              width: 2,
                              color: const Color(0xff707070).withOpacity(0.3)),
                          txt(txt: '', fontSize: 5),
                        ],
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      Column(
                        children: [
                          txt(
                              txt: '112',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          txt(txt: 'VIDS', fontSize: 10),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: screenWidth(context) * 0.2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.015,
                  ),
                  Container(
                    width: screenWidth(context) * 0.5,
                    height: screenHeight(context) * 0.055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      color: const Color(0xFF3B5998),
                    ),
                    child: Center(
                      child: txt(
                          txt: 'Follow', fontSize: 13, fontColor: Colors.white),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              TabBar(
                indicatorColor: const Color(blueColor).withOpacity(0.5),
                tabs: [
                  Tab(icon: txt(txt: "BY YOU", fontSize: 14)),
                  Tab(icon: txt(txt: "REQUESTS", fontSize: 14)),
                ],
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TabBarView(
                      children: [
                        ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            favouriteItem(context),
                            favouriteItem(context),
                            favouriteItem(context),
                            favouriteItem(context),
                            favouriteItem(context),
                          ],
                        ),
                        ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                height: screenHeight(context) * 0.2,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: screenHeight(context) * 0.2,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        image: DecorationImage(
                                          image: const AssetImage(
                                              'assets/images/pic.jpeg'),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.5),
                                              BlendMode.dstIn),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: screenHeight(context) * 0.2,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 56.0,
                                          height: 56.0,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF3B5998),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                                'assets/svgs/chainIcon.svg'),
                                          ),
                                        )),
                                    Positioned(
                                      top: 15,
                                      left: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          txt(
                                              txt: 'Bidens no war policy',
                                              fontColor: const Color(blueColor),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          const Text(
                                            '#Elections',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      left: 10,
                                      child: SizedBox(
                                        width: screenWidth(context) * 0.85,
                                        child: Row(
                                          children: [
                                            txt(
                                              txt: '37%',
                                              fontColor: const Color(blueColor),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            txt(
                                              txt:
                                                  ' audience labelled this video as ',
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
                                            const Spacer(),
                                            Row(
                                              children: [
                                                const Icon(Icons.play_arrow,
                                                    color: Color(blueColor)),
                                                txt(
                                                  txt: '21.k',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontColor:
                                                      const Color(blueColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Positioned(
                                    //   bottom: 15,
                                    //   right: 25,
                                    //   child: Row(
                                    //     children: [
                                    //       const Icon(Icons.play_arrow, color: Color(blueColor)),
                                    //       txt(
                                    //         txt: '21.k',
                                    //         fontSize: 12,
                                    //         fontWeight: FontWeight.bold,
                                    //         fontColor: const Color(blueColor),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding favouriteItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: screenHeight(context) * 0.2,
        child: Stack(
          children: [
            Container(
              height: screenHeight(context) * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: const AssetImage('assets/images/pic.jpeg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstIn),
                ),
              ),
            ),
            Container(
              height: screenHeight(context) * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SvgPicture.string(
                '<svg viewBox="174.78 378.56 39.93 39.93" ><path transform="translate(174.22, 377.99)" d="M 20.52500152587891 0.5625 C 9.497329711914062 0.5625 0.5625 9.497329711914062 0.5625 20.52500152587891 C 0.5625 31.55267333984375 9.497329711914062 40.48750686645508 20.52500152587891 40.48750686645508 C 31.55267333984375 40.48750686645508 40.48750686645508 31.55267333984375 40.48750686645508 20.52500152587891 C 40.48750686645508 9.497329711914062 31.55267333984375 0.5625 20.52500152587891 0.5625 Z M 29.8381519317627 22.45685577392578 L 15.67121505737305 30.58674240112305 C 14.39941215515137 31.29509162902832 12.79758167266846 30.3855094909668 12.79758167266846 28.89637184143066 L 12.79758167266846 12.15362930297852 C 12.79758167266846 10.67253971099854 14.39136123657227 9.754909515380859 15.67121505737305 10.46325588226318 L 29.8381519317627 19.07611083984375 C 31.15825271606445 19.81665420532227 31.15825271606445 21.72436141967773 29.8381519317627 22.45685577392578 Z" fill="#3b5998" stroke="none" stroke-width="5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                width: 39.93,
                height: 39.93,
              ),
            ),
            Positioned(
              top: 15,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(
                      txt: 'Bidens no war policy',
                      fontColor: const Color(blueColor),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  const Text(
                    '#Elections',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 15,
              left: 10,
              child: SizedBox(
                width: screenWidth(context) * 0.85,
                child: Row(
                  children: [
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
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.play_arrow, color: Color(blueColor)),
                        txt(
                          txt: '21.k',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontColor: const Color(blueColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   bottom: 15,
            //   right: 25,
            //   child: Row(
            //     children: [
            //       const Icon(Icons.play_arrow, color: Color(blueColor)),
            //       txt(
            //         txt: '21.k',
            //         fontSize: 12,
            //         fontWeight: FontWeight.bold,
            //         fontColor: const Color(blueColor),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
