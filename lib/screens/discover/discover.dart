import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:perspective/res.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  bool isSearching = false;
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
                ? EdgeInsets.only(left: 20)
                : EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back, color: Colors.white),
                isSearching
                    ? Container(
                        height: 77,
                        width: screenWidth(context) * 0.785,
                        padding: const EdgeInsets.fromLTRB(10, 15, 0, 7),
                        child: TextField(
                          autocorrect: true,
                          style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          // controller: _filter,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: 'Search...',
                              hintStyle: const TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 16.0,
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
                ? ListView(
                    children: [
                      txt(txt: 'Recent Searches', fontSize: 18),
                      SizedBox(
                        height: screenHeight(context) * 0.02,
                      ),
                      searchitems(item: 'ukarain'),
                      searchitems(item: 'ukarain'),
                      searchitems(item: 'ukarain'),
                      searchitems(item: 'ukarain'),
                    ],
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(100, (index) {
                      return Center(child: buildTopics(topic: '#Taylor swift'));
                    }),
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
          txt(txt: item, fontSize: 14),
          const Icon(
            Icons.clear,
            size: 20,
            color: Colors.black,
          )
        ],
      ),
    );
  }

  Container buildTopics({String? topic}) {
    return Container(
      width: screenWidth(context) * 0.4,
      height: screenHeight(context) * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: const Color(0xFF3B5998),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            offset: const Offset(0, 3.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Center(
        child: txt(txt: topic, fontColor: Colors.white, fontSize: 14),
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
