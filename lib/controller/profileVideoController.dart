// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:slant/models/video.dart';
// import 'package:slant/view/screens/discover/videosList.dart';

// import '../res.dart';

// class ProfileVideoController extends GetxController {
//   final Rx<List<Video>> _profileVideo = Rx<List<Video>>([]);
 


//   List<Video> get profileVideo => _profileVideo.value;
 
//   Future<void> getHomeScreenVideos() async {
//      StreamBuilder<QuerySnapshot>(
//                                   stream: users
//                                       .doc(userId)
//                                       .collection("videos")
//                                       .snapshots(),
//                                   builder: (context,
//                                       AsyncSnapshot<QuerySnapshot> snapshot) {
//                                     if (!snapshot.hasData ||
//                                         snapshot.hasError) {
//                                       return const Center(
//                                         child: Text(
//                                           'No videos...',
//                                         ),
//                                       );
//                                     } else if (snapshot.data!.docs.isNotEmpty) {
//                                       return ListView.builder(
//                                           itemCount: snapshot.data!.docs.length,
//                                           itemBuilder: (context, index) {
//                                             DocumentSnapshot doc =
//                                                 snapshot.data!.docs[index];

//                                             return favouriteItem(context,
//                                                 doc: doc,
//                                                 name: data['name'] ?? ' ',
//                                                 profileUrl:
//                                                     data['profilePic'] ?? ' ',
//                                                 title: (doc.data()
//                                                         as Map)['videoTitle'] ??
//                                                     ' ',
//                                                 videoLink: (doc.data()
//                                                         as Map)['videoLink'] ??
//                                                     ' ',
//                                                     thumbnail: (doc.data()
//                                                         as Map)['videoLink'] ??
//                                                     ' ',
//                                                 topic: (doc.data()
//                                                         as Map)['videoTopic'] ??
//                                                     ' ');
//                                           });
//                                     } else {
//                                       return const Center(
//                                           child: Text('No videos...'));
//                                     }
//   }


//   @override
//   void onInit() {
//     super.onInit();
//     getHomeScreenVideos();
//   }

//   // likeVideo(String id) async {
//   //   DocumentSnapshot doc = await FirebaseFirestore.instance.collection('videos').doc(id).get();
//   //   var uid = authController.user.uid;
//   //   if ((doc.data()! as dynamic)['likes'].contains(uid)) {
//   //     await firestore.collection('videos').doc(id).update({
//   //       'likes': FieldValue.arrayRemove([uid]),
//   //     });
//   //   } else {
//   //     await firestore.collection('videos').doc(id).update({
//   //       'likes': FieldValue.arrayUnion([uid]),
//   //     });
//   //   }
//   // }
// }
