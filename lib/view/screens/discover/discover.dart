import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slant/res.dart';
import 'package:slant/view/screens/discover/videosList.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:slant/view/widgets/circularProgress.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final TextEditingController _searchController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  var parser = EmojiParser();

  bool isSearching = false;
  bool isLoading = false;
  bool titleExist = false;
  bool hashtagExist = false;

  List<DocumentSnapshot> list = [];

  getSearchedTitle({required String typedTitle}) async {
    var veryConservativeTitleDocList = [];
    var conservativeTitleDocList = [];
    var neutralTitleDocList = [];
    var liberalTitleDocList = [];
    var veryLiberalTitleDocList = [];
    setState(() {
      isLoading = true;
      titleExist = false;
    });

    await FirebaseFirestore.instance
        .collection('titles')
        .doc(typedTitle)
        .collection(veryConservative)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        veryConservativeTitleDocList.add(element);
      }
    });
    await FirebaseFirestore.instance
        .collection('titles')
        .doc(typedTitle)
        .collection(conservative)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        conservativeTitleDocList.add(element);
      }
    });
    await FirebaseFirestore.instance
        .collection('titles')
        .doc(typedTitle)
        .collection(neutral)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        neutralTitleDocList.add(element);
      }
    });
    await FirebaseFirestore.instance
        .collection('titles')
        .doc(typedTitle)
        .collection(liberal)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        liberalTitleDocList.add(element);
      }
    });
    await FirebaseFirestore.instance
        .collection('titles')
        .doc(typedTitle)
        .collection(veryLiberal)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        veryLiberalTitleDocList.add(element);
      }
    });

    setState(() {
      if (veryConservativeTitleDocList.isEmpty &&
          conservativeTitleDocList.isEmpty &&
          neutralTitleDocList.isEmpty &&
          liberalTitleDocList.isEmpty &&
          veryLiberalTitleDocList.isEmpty) {
        titleExist = true;
      } else {
        titleExist = false;
      }
      isLoading = false;
    });
  }

  getSearchedHashtag({required String typedHashtag}) async {
    var veryConservativeHashtagDocList = [];
    var conservativeHashtagDocList = [];
    var neutralHashtagDocList = [];
    var liberalHashtagDocList = [];
    var veryLiberalHashtagDocList = [];
    setState(() {
      isLoading = true;
      hashtagExist = false;
    });

    await FirebaseFirestore.instance
        .collection('hashtags')
        .doc(typedHashtag)
        .collection(veryConservative)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        veryConservativeHashtagDocList.add(element);
      }
    });
    await FirebaseFirestore.instance
        .collection('hashtags')
        .doc(typedHashtag)
        .collection(conservative)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        conservativeHashtagDocList.add(element);
      }
    });
    await FirebaseFirestore.instance
        .collection('hashtags')
        .doc(typedHashtag)
        .collection(neutral)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        neutralHashtagDocList.add(element);
      }
    });
    await FirebaseFirestore.instance
        .collection('hashtags')
        .doc(typedHashtag)
        .collection(liberal)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        liberalHashtagDocList.add(element);
      }
    });
    await FirebaseFirestore.instance
        .collection('hashtags')
        .doc(typedHashtag)
        .collection(veryLiberal)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        veryLiberalHashtagDocList.add(element);
      }
    });

    setState(() {
      if (veryConservativeHashtagDocList.isEmpty &&
          conservativeHashtagDocList.isEmpty &&
          neutralHashtagDocList.isEmpty &&
          liberalHashtagDocList.isEmpty &&
          veryLiberalHashtagDocList.isEmpty) {
        hashtagExist = true;
      } else {
        hashtagExist = false;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: isSearching
              ? screenHeight(context) * 0.1
              : screenHeight(context) * 0.08,
          color: const Color(0xFF080808),
          child: Padding(
            padding: isSearching
                ? const EdgeInsets.only(left: 20)
                : const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth(context) * 0.05,
                ),
                isSearching
                    ? Container(
                        height: 77,
                        width: screenWidth(context) * 0.785,
                        padding: const EdgeInsets.fromLTRB(10, 15, 0, 7),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (value[0] == '#') {
                                getSearchedHashtag(typedHashtag: value);
                              } else {
                                getSearchedTitle(typedTitle: value);
                              }
                            }
                          },
                          autocorrect: true,
                          style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: 'Search with titles or #hastags',
                              hintStyle: const TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: const Color(0xffAAAAAA),
                              disabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff3A4F6B), width: 1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff3A4F6B), width: 1),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff3A4F6B), width: 1),
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isSearching = false;
                                  });
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                              )),
                        ))
                    : txt(
                        txt: 'Discover', fontSize: 18, fontColor: Colors.white),
                InkWell(
                    onTap: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                    },
                    child: Icon(isSearching ? null : Icons.search,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: isSearching
                ? _searchController.text.isEmpty
                    ? const Center(
                        child: AutoSizeText(
                        'Search videos with title or their hashtags and add your perspective',
                        textAlign: TextAlign.center,
                        maxFontSize: 20,
                        minFontSize: 18,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                    : isLoading
                        ? const Center(
                            child: CircularProgress(),
                          )
                        : _searchController.text[0] == "#"
                            ? hashtagExist
                                ? Center(
                                    child: txt(
                                        txt: 'No video found with this hashtag',
                                        fontSize: 18),
                                  )
                                : Column(
                                    children: [
                                      txt(txt: 'Results', fontSize: 24),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => VideoList(
                                                headertag: 'hashtag',
                                                headerName:
                                                    _searchController.text,
                                              ),
                                            ),
                                          );
                                        },
                                        child: ListTile(
                                          title: Text(
                                            _searchController.text,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                            : titleExist
                                ? Center(
                                    child: txt(
                                        txt: 'No video found with this title',
                                        fontSize: 18),
                                  )
                                : Column(
                                    children: [
                                      txt(txt: 'Results', fontSize: 24),
                                      InkWell(
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => VideoList(
                                              headertag: 'title',
                                              headerName:
                                                  _searchController.text,
                                            ),
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            _searchController.text,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                : GridView.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: [
                      buildTopics(
                        emojy: parser.getEmoji('🏳').code,
                        topic: whatsHappeningInMyCountry,
                        route: const VideoList(
                          headertag: 'topic',
                          headerName: whatsHappeningInMyCountry,
                        ),
                      ),
                      buildTopics(
                        emojy: parser.getEmoji('🌎').code,
                        topic: 'What’s happening around the world',
                        route: const VideoList(
                          headertag: 'topic',
                          headerName: whatsHappeningAroundTheWorld,
                        ),
                      ),
                      buildTopics(
                        emojy: parser.getEmoji('🤔').code,
                        topic: 'My sense of belonging\nand it’s representation',
                        route: const VideoList(
                          headertag: 'topic',
                          headerName: mySenseOfBelongingAndItsRepresentation,
                        ),
                      ),
                      buildTopics(
                        emojy: parser.getEmoji('🏘').code,
                        topic: howSocietyAroundMeFunctions,
                        route: const VideoList(
                          headertag: 'topic',
                          headerName: howSocietyAroundMeFunctions,
                        ),
                      ),
                      buildTopics(
                        emojy: parser.getEmoji('🚶‍♀️').code,
                        topic: 'My\nLifestyle',
                        route: const VideoList(
                          headertag: 'topic',
                          headerName: myLifestyle,
                        ),
                      ),
                      buildTopics(
                        emojy: parser.getEmoji('🙏').code,
                        topic: 'My\nReligion',
                        route: const VideoList(
                          headertag: 'topic',
                          headerName: myReligion,
                        ),
                      ),
                      buildTopics(
                        emojy: parser.getEmoji('📺').code,
                        topic: 'What I see online or\non my TV',
                        route: const VideoList(
                          headertag: 'topic',
                          headerName: whatISeeOnMyTV,
                        ),
                      ),
                      buildTopics(
                        emojy: parser.getEmoji('🆔').code,
                        topic: 'My\nIdentity',
                        route: const VideoList(
                          headertag: 'topic',
                          headerName: myIdentity,
                        ),
                      ),
                      buildTopics(
                        emojy: parser.getEmoji('💰').code,
                        topic: 'Money and finances',
                        route: const VideoList(
                          headertag: 'topic',
                          headerName: moneyAndFinances,
                        ),
                      ),
                    ],
                  ),
          ),
        )
      ],
    );
  }

  Padding searchitems({String? item}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          txt(txt: item!, fontSize: 14),
          const Icon(
            Icons.clear,
            size: 20,
            color: Colors.black,
          )
        ],
      ),
    );
  }

  InkWell buildTopics(
      {String? topic, Widget? route, Color? color, String? emojy}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => route!,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: const Color(blueColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              offset: const Offset(0, 3.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  emojy!,
                  maxFontSize: 50,
                  minFontSize: 45,
                ),
                SizedBox(
                  height: screenHeight(context) * 0.015,
                ),
                AutoSizeText(
                  topic!,
                  textAlign: TextAlign.center,
                  maxFontSize: 12,
                  minFontSize: 8,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )),
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
              bottom: 15,
              left: 20,
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
            const Positioned(
              bottom: 15,
              right: 10,
              child: CircleAvatar(
                // backgroundColor: Colors.red,
                maxRadius: 30,
                backgroundColor: Colors.transparent,

                backgroundImage: AssetImage(
                  'assets/images/girl2.png',
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 25,
              child: txt(
                txt: 'Alexa A. Williams',
                fontSize: 10,
                fontColor: const Color(blueColor),
              ),
            ),
            const Positioned(
                top: 15,
                right: 20,
                child: Icon(
                  Icons.favorite,
                  color: Color(redColor),
                  size: 40,
                )),
          ],
        ),
      ),
    );
  }
}
