import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:slant/models/video.dart';
import 'package:slant/view/screens/discover/videosList.dart';

import '../res.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _homeScreenVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _titlesVeryConservativeVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _titlesConservativeVideoslist = Rx<List<Video>>([]);
  final Rx<List<Video>> _titlesNeutralVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _titlesLiberalVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _titlesVeryLiberalVideosList = Rx<List<Video>>([]);

  final Rx<List<Video>> _hashtagsVeryConservativeVideosList =
      Rx<List<Video>>([]);
  final Rx<List<Video>> _hashtagsConservativeVideoslist = Rx<List<Video>>([]);
  final Rx<List<Video>> _hashtagsNeutralVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _hashtagsLiberalVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _hashtagsVeryLiberalVideosList = Rx<List<Video>>([]);

  final Rx<List<Video>> _topicsVeryConservativeVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _topicsConservativeVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _topicsNeutralVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _topicsLiberalVideosList = Rx<List<Video>>([]);
  final Rx<List<Video>> _topicsVeryLiberalVideosList = Rx<List<Video>>([]);

  List<Video> get homeScreenVideosList => _homeScreenVideosList.value;
  List<Video> get titlesVeryConservativeVideosList =>
      _titlesVeryConservativeVideosList.value;
  List<Video> get titlesConservativeVideoslist =>
      _titlesConservativeVideoslist.value;
  List<Video> get titlesNeutralVideosList => _titlesNeutralVideosList.value;
  List<Video> get titlesLiberalVideosList => _titlesLiberalVideosList.value;
  List<Video> get titlesVeryLiberalVideosList =>
      _titlesVeryLiberalVideosList.value;

  List<Video> get hashtagsVeryConservativeVideosList =>
      _hashtagsVeryConservativeVideosList.value;
  List<Video> get hashtagsConservativeVideoslist =>
      _hashtagsConservativeVideoslist.value;
  List<Video> get hashtagsNeutralVideosList => _hashtagsNeutralVideosList.value;
  List<Video> get hashtagsLiberalVideosList => _hashtagsLiberalVideosList.value;
  List<Video> get hashtagsVeryLiberalVideosList =>
      _hashtagsVeryLiberalVideosList.value;

  List<Video> get topicsVeryConservativeVideosList =>
      _topicsVeryConservativeVideosList.value;
  List<Video> get topicsConservativeVideoslist =>
      _topicsConservativeVideosList.value;
  List<Video> get topicsNeutralVideosList => _topicsNeutralVideosList.value;
  List<Video> get topicsLiberalVideosList => _topicsLiberalVideosList.value;
  List<Video> get topicsVeryLiberalVideosList =>
      _topicsVeryLiberalVideosList.value;

  var title = ''.obs;
  var hashtag = ''.obs;
  var topic = ''.obs;

  updateTitle(var videoTitle) {
    title.value = videoTitle;
    getTitlesVeryConservativeVideosList(videoTitle);
    getTitlesConservativeVideosList(videoTitle);
    getTitlesNeutralVideosList(videoTitle);
    getTitlesLiberalVideosList(videoTitle);
    getTitlesVeryLiberalVideosList(videoTitle);
  }

  updateHashtag(var videoHashtag) {
    hashtag.value = videoHashtag;

    getHashtagsVeryConservativeVideosList(videoHashtag);
    getHashtagsConservativeVideosList(videoHashtag);
    getHastagsNeutralVideosList(videoHashtag);
    getHashtagsLiberalVideosList(videoHashtag);
    getHashtagsVeryLiberalVideosList(videoHashtag);
  }

  updateTopic(var videoTopic) {
    topic.value = videoTopic;

    getTopicsVeryConservativeVideosList(videoTopic);
    getTopicsConservativeVideosList(videoTopic);
    getTopicsNeutralVideosList(videoTopic);
    getTopicsLiberalVideosList(videoTopic);
    getTopicsVeryLiberalVideosList(videoTopic);
  }

  Future<void> getHomeScreenVideos() async {
    try {
      _homeScreenVideosList.bindStream(FirebaseFirestore.instance
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
    } catch (e) {
      // ignore: empty_catches
    }
  }

  Future<void> getTitlesVeryConservativeVideosList(title) async {
    try {
      _titlesVeryConservativeVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(veryConservative)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("titles").doc(title).path])
          .endAt([
            FirebaseFirestore.instance.collection("titles").doc(title).path +
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

  Future<void> getTitlesConservativeVideosList(title) async {
    try {
      _titlesConservativeVideoslist.bindStream(FirebaseFirestore.instance
          .collectionGroup(conservative)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("titles").doc(title).path])
          .endAt([
            FirebaseFirestore.instance.collection("titles").doc(title).path +
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
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> getTitlesNeutralVideosList(title) async {
    try {
      _titlesNeutralVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(neutral)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("titles").doc(title).path])
          .endAt([
            FirebaseFirestore.instance.collection("titles").doc(title).path +
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
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> getTitlesLiberalVideosList(title) async {
    try {
      _titlesLiberalVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(liberal)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("titles").doc(title).path])
          .endAt([
            FirebaseFirestore.instance.collection("titles").doc(title).path +
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
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> getTitlesVeryLiberalVideosList(title) async {
    try {
      _titlesVeryLiberalVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(veryLiberal)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("titles").doc(title).path])
          .endAt([
            FirebaseFirestore.instance.collection("titles").doc(title).path +
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
      // ignore: empty_catches
    } catch (e) {}
  }

//For hastags search
  Future<void> getHashtagsVeryConservativeVideosList(hashtag) async {
    try {
      _hashtagsVeryConservativeVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(veryConservative)
          .orderBy(FieldPath.documentId)
          .startAt([
            FirebaseFirestore.instance.collection("hashtags").doc(hashtag).path
          ])
          .endAt([
            FirebaseFirestore.instance
                    .collection("hashtags")
                    .doc(hashtag)
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

//For hastags search
  Future<void> getHashtagsConservativeVideosList(hashtag) async {
    try {
      _hashtagsConservativeVideoslist.bindStream(FirebaseFirestore.instance
          .collectionGroup(conservative)
          .orderBy(FieldPath.documentId)
          .startAt([
            FirebaseFirestore.instance.collection("hashtags").doc(hashtag).path
          ])
          .endAt([
            FirebaseFirestore.instance
                    .collection("hashtags")
                    .doc(hashtag)
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

//For hastags search
  Future<void> getHastagsNeutralVideosList(hashtag) async {
    try {
      _hashtagsNeutralVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(neutral)
          .orderBy(FieldPath.documentId)
          .startAt([
            FirebaseFirestore.instance.collection("hashtags").doc(hashtag).path
          ])
          .endAt([
            FirebaseFirestore.instance
                    .collection("hashtags")
                    .doc(hashtag)
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

//For hastags search
  Future<void> getHashtagsLiberalVideosList(hashtag) async {
    try {
      _hashtagsLiberalVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(liberal)
          .orderBy(FieldPath.documentId)
          .startAt([
            FirebaseFirestore.instance.collection("hashtags").doc(hashtag).path
          ])
          .endAt([
            FirebaseFirestore.instance
                    .collection("hashtags")
                    .doc(hashtag)
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

//For hastags search
  Future<void> getHashtagsVeryLiberalVideosList(hashtag) async {
    try {
      _hashtagsVeryLiberalVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(veryLiberal)
          .orderBy(FieldPath.documentId)
          .startAt([
            FirebaseFirestore.instance.collection("hashtags").doc(hashtag).path
          ])
          .endAt([
            FirebaseFirestore.instance
                    .collection("hashtags")
                    .doc(hashtag)
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

  //For Topics
  Future<void> getTopicsVeryConservativeVideosList(topic) async {
    try {
      _topicsVeryConservativeVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(veryConservative)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("videos").doc(topic).path])
          .endAt([
            FirebaseFirestore.instance.collection("videos").doc(topic).path +
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

  Future<void> getTopicsConservativeVideosList(topic) async {
    try {
      _topicsConservativeVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(conservative)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("videos").doc(topic).path])
          .endAt([
            FirebaseFirestore.instance.collection("videos").doc(topic).path +
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

  Future<void> getTopicsNeutralVideosList(topic) async {
    try {
      _topicsNeutralVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(neutral)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("videos").doc(topic).path])
          .endAt([
            FirebaseFirestore.instance.collection("videos").doc(topic).path +
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

  Future<void> getTopicsLiberalVideosList(topic) async {
    try {
      _topicsLiberalVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(liberal)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("videos").doc(topic).path])
          .endAt([
            FirebaseFirestore.instance.collection("videos").doc(topic).path +
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

  Future<void> getTopicsVeryLiberalVideosList(topic) async {
    try {
      _topicsVeryLiberalVideosList.bindStream(FirebaseFirestore.instance
          .collectionGroup(veryLiberal)
          .orderBy(FieldPath.documentId)
          .startAt(
              [FirebaseFirestore.instance.collection("videos").doc(topic).path])
          .endAt([
            FirebaseFirestore.instance.collection("videos").doc(topic).path +
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
    } catch (e) {
      // ignore: empty_catches

    }
  }

  @override
  void onInit() {
    super.onInit();
    getHomeScreenVideos();
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
