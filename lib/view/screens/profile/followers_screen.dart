import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slant/res.dart';
import 'package:slant/view/widgets/circular_progress.dart';

class Followers extends StatefulWidget {
  final String userID;
  const Followers({Key? key, required this.userID}) : super(key: key);

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  var followersList = [];

  bool isLoading = false;

  getFollowers() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userID)
        .collection(followers)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          followersList.add(documentSnapshot.data());
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: screenHeight(context),
          width: screenWidth(context),
          child: Column(children: [
            Container(
              height: screenHeight(context) * 0.08,
              color: const Color(0xFF080808),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    txt(
                        txt: 'Followers',
                        fontSize: 18,
                        fontColor: Colors.white),
                    Container(
                      width: screenWidth(context) * 0.05,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgress(),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10),
                      separatorBuilder: (BuildContext context, int index) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 0.5,
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: const Divider(),
                          ),
                        );
                      },
                      itemCount: followersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var follower = followersList[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 25,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${follower['profilePic'] == null || follower['profilePic'].toString().isEmpty ? 'https://www.kindpng.com/picc/m/285-2855863_a-festival-celebrating-tractors-round-profile-picture-placeholder.png' : follower['profilePic']}',
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 25,
                                          backgroundImage: imageProvider),
                                  placeholder: (context, url) =>
                                      const CircularProgress(),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 25,
                                          backgroundImage: AssetImage(
                                              'assets/images/placeholder.png')),
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              title: txt(txt: follower['name'], fontSize: 14),
                              subtitle: txt(
                                  txt: follower['bio'],
                                  fontSize: 12,
                                  fontColor: Colors.black45)),
                        );
                      },
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}
