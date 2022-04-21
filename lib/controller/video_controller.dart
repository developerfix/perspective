import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:slant/models/video.dart';
import 'package:slant/view/screens/discover/videosList.dart';

import '../res.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList1 = Rx<List<Video>>([]);
  // final Rx<List<Video>> _videoList2 = Rx<List<Video>>([]);
  // final Rx<List<Video>> finalVideoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList1.value;
  // var homeScreenVideos = [];

  Future<void> getVideos() async {
    try {
      _videoList1.bindStream(FirebaseFirestore.instance
          .collectionGroup(neutral)
          .orderBy(FieldPath.documentId)
          .startAt([
            FirebaseFirestore.instance
                .collection("videos")
                .doc(myLifestyle)
                .path
          ])
          .endAt([
            FirebaseFirestore.instance
                    .collection("videos")
                    .doc(myLifestyle)
                    .path +
                "\uf8ff"
          ])
          .snapshots()
          .map((QuerySnapshot query) {
            List<Video> retVal = [];
            for (var element in query.docs) {
              retVal.add(
                Video.fromSnap(element),
              );
            }
            return retVal;
          }));

      // _videoList2.bindStream(FirebaseFirestore.instance
      //     .collectionGroup(neutral)
      //     .orderBy(FieldPath.documentId)
      //     .startAt([
      //       FirebaseFirestore.instance
      //           .collection("videos")
      //           .doc(howSocietyAroundMeFunctions)
      //           .path
      //     ])
      //     .endAt([
      //       FirebaseFirestore.instance
      //               .collection("videos")
      //               .doc(whatsHappeningAroundTheWorld)
      //               .path +
      //           "\uf8ff"
      //     ])
      //     .snapshots()
      //     .map((QuerySnapshot query) {
      //   List<Video> retVal = [];
      //   for (var element in query.docs) {
      //     retVal.add(
      //       Video.fromSnap(element),
      //     );
      //   }
      //   return retVal;
      // }));

    } catch (e) {
      print('Error loading videos: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getVideos();
  }

  // likeVideo(String id) async {
  //   DocumentSnapshot doc = await FirebaseFirestore.instance.collection('videos').doc(id).get();
  //   var uid = authController.user.uid;
  //   if ((doc.data()! as dynamic)['likes'].contains(uid)) {
  //     await firestore.collection('videos').doc(id).update({
  //       'likes': FieldValue.arrayRemove([uid]),
  //     });
  //   } else {
  //     await firestore.collection('videos').doc(id).update({
  //       'likes': FieldValue.arrayUnion([uid]),
  //     });
  //   }
  // }
}
