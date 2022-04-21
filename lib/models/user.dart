import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String profilePhoto;
  String email;
  String bio;
  String uid;
  List<String> topicsOfInterest = [];

  User(
      {required this.name,
      required this.email,
      required this.bio,
      required this.uid,
      required this.topicsOfInterest,
      required this.profilePhoto});

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "bio": bio,
        "topicsOfInterest": topicsOfInterest,
        "uid": uid,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      bio: snapshot['bio'],
      topicsOfInterest: snapshot['topicsOfInterest'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      name: snapshot['name'],
    );
  }
}
