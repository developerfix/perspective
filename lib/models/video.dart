import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String publisherName;
  String publisherID;
  int veryConservative;
  int conservative;
  int neutral;
  int liberal;
  int veryLiberal;
  List brainOnFireReactions;
  String videoLink;
  String videoTag;
  List? videoHastags;
  String videoDescription;
  String videoTopic;
  String thumbnail;
  String publisherProfilePic;
  String videoTitle;

  Video({
    required this.publisherName,
    required this.publisherID,
    required this.videoTitle,
    required this.brainOnFireReactions,
    required this.videoLink,
    required this.publisherProfilePic,
    required this.thumbnail,
    required this.conservative,
    required this.liberal,
    required this.neutral,
    required this.veryConservative,
    required this.veryLiberal,
    required this.videoDescription,
    required this.videoHastags,
    required this.videoTag,
    required this.videoTopic,
  });

  Map<String, dynamic> toJson() => {
        "publisherName": publisherName,
        "publisherProfilePic": publisherProfilePic,
        "publisherID": publisherID,
        "videoDescription": videoDescription,
        "videoHastags": videoHastags,
        "videoLink": videoLink,
        "videoTag": videoTag,
        "videoTitle": videoTitle,
        "videoTopic": videoTopic,
        "veryConservative": veryConservative,
        "conservative": conservative,
        "neutral": neutral,
        "liberal": liberal,
        "veryLiberal": veryLiberal,
        "brainOnFireReactions": brainOnFireReactions,
        "thumbnail": thumbnail,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      publisherName: snapshot['publisherName'],
      publisherProfilePic: snapshot['publisherProfilePic'],
      publisherID: snapshot['publisherID'],
      videoDescription: snapshot['videoDescription'],
      videoHastags: snapshot['videoHastags'],
      videoLink: snapshot['videoLink'],
      videoTag: snapshot['videoTag'],
      videoTitle: snapshot['videoTitle'],
      videoTopic: snapshot['videoTopic'],
      veryConservative: snapshot['veryConservative'],
      conservative: snapshot['conservative'],
      neutral: snapshot['neutral'],
      liberal: snapshot['liberal'],
      veryLiberal: snapshot['veryLiberal'],
      thumbnail: snapshot['thumbnail'],
      brainOnFireReactions: snapshot['brainOnFireReactions'],
    );
  }
}
