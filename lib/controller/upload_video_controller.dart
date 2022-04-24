import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

import '../bnb.dart';
import '../models/video.dart';
import '../res.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // uploading the data to firebase cloudstore
  Future uploadContent({
    BuildContext? context,
    String? publishersName,
    File? video,
    String? publisherProfilePic,
    String? videoTopic,
    String? videoTitle,
    String? videoDescription,
    String? videoTag,
    required List<String?> videoHastags,
  }) async {
    var videosCollection = FirebaseFirestore.instance.collection('videos');
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    var allDocs = await videosCollection.get();
    int len = allDocs.docs.length;
    String? downloadURL;

    final vidId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    String thumbnail = await _uploadImageToStorage("Video $len", video!.path);

    Reference reference = FirebaseStorage.instance
        .ref()
        .child('$userId/videos')
        .child("post_$vidId");

    UploadTask uploadTask = reference.putFile(await _compressVideo(video.path));
    TaskSnapshot snap = await uploadTask;
    downloadURL = await snap.ref.getDownloadURL();

    Video videoo = Video(
      brainOnFireReactions: [],
      conservative: 0,
      liberal: 0,
      neutral: 0,
      publisherID: userId!,
      publisherName: publishersName!,
      publisherProfilePic: publisherProfilePic!,
      veryConservative: 0,
      veryLiberal: 0,
      videoDescription: videoDescription!,
      videoHastags: videoHastags,
      videoLink: downloadURL,
      videoTag: videoTag!,
      videoTopic: videoTopic!,
      thumbnail: thumbnail,
      videoTitle: videoTitle!,
    );

    await videosCollection
        .doc(videoTopic)
        .collection(videoTag)
        .add(
          videoo.toJson(),
        )
        .then((value) {
      for (var i in videoHastags) {
        firebaseFirestore
            .collection('hashtags')
            .doc(i)
            .collection(videoTag)
            .add(
              videoo.toJson(),
            );
      }
    }).then((value) {
      firebaseFirestore
          .collection('titles')
          .doc(videoTitle)
          .collection(videoTag)
          .add(
            videoo.toJson(),
          );
    }).then((value) {
      firebaseFirestore
          .collection("users")
          .doc(userId)
          .collection('videos')
          .add(videoo.toJson())
          .then((value) {
        Navigator.pushAndRemoveUntil(
            Get.context!,
            MaterialPageRoute(
              builder: (ctx) => const BNB(),
            ),
            (Route<dynamic> route) => false);

        showSnackBar(
            context: context, snackText: 'Video published successfully');
      }).onError((error, stackTrace) {
        showSnackBar(
          context: context,
          snackText: 'Something went wrong, please try again',
        );
      });
    });
  }
}
