import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:slant/models/video.dart';
import 'package:slant/view/screens/discover/videosList.dart';

import '../res.dart';

class ProfileVideoController extends GetxController {
  final Rx<List<Video>> _profileVideo = Rx<List<Video>>([]);

  List<Video> get profileVideo => _profileVideo.value;

  final Rx<List<Video>> _favouriteVideo = Rx<List<Video>>([]);

  List<Video> get favouriteVideo => _favouriteVideo.value;

  final Rx<List<Video>> _requestVideo = Rx<List<Video>>([]);

  List<Video> get requestVideo => _requestVideo.value;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Rx<String> _url = "".obs;
  Rx<String> _favouriteUrl = "".obs;
  Rx<String> _requestUrl = "".obs;

  updateVideoUrl(String url) async {
    _url.value = url;
    await getProfileVideo(_url.value);
  }

  updateFavouriteVideoUrl(String url) async {
    _favouriteUrl.value = url;
    await getFavouriteVideo(_favouriteUrl.value);
  }

  updateRequestVideoUrl(String url) async {
    _requestUrl.value = url;
    await getRequestVideo(_requestUrl.value);
  }

  Future<void> getProfileVideo(String url) async {
    try {
      _profileVideo.bindStream(users
          .doc(userId)
          .collection('videos')
          .where('videoLink', isEqualTo: url)
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
    update();
  }

  Future<void> getFavouriteVideo(String url) async {
    try {
      _favouriteVideo.bindStream(users
          .doc(userId)
          .collection('favouriteVideos')
          .where('videoLink', isEqualTo: url)
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
    update();
  }

  Future<void> getRequestVideo(String url) async {
    try {
      _requestVideo.bindStream(users
          .doc(userId)
          .collection('perspectiveRequests')
          .where('videoLink', isEqualTo: url)
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
    update();
  }

  likeVideo(Video video, bool isFavourite) async {
    var retVal = [];
    isFavourite
        ? await users
            .doc(userId)
            .collection('favouriteVideos')
            .where('videoLink', isEqualTo: video.videoLink)
            .get()
            .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              retVal.add(doc);
            }
          }).then((value) async {
            retVal.isEmpty
                ? await users
                    .doc(userId)
                    .collection('favouriteVideos')
                    .add(video.toJson())
                : Container();
          })
        : await users
            .doc(userId)
            .collection('favouriteVideos')
            .where('videoLink', isEqualTo: video.videoLink)
            .get()
            .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.delete();
            }
          });
  }

  removeVideoFromFavourites(
    String videoLink,
  ) async {
    await users
        .doc(userId)
        .collection('favouriteVideos')
        .where('videoLink', isEqualTo: videoLink)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<bool> whetherVideoLikedOrNot({String? videoLink}) async {
    bool likedOrNot = false;
    var retVal = [];

    await users
        .doc(userId)
        .collection('favouriteVideos')
        .where('videoLink', isEqualTo: videoLink)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        retVal.add(doc);
      }
    }).then((value) async {
      retVal.isEmpty ? likedOrNot = false : likedOrNot = true;
    });

    return likedOrNot;
  }
}
