import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;

  updateUserId(String uid) async {
    _uid.value = uid;
    await getUserData();
  }

  getUserData() async {
    var myVideos = await users.doc(_uid.value).collection('videos').get();

    DocumentSnapshot userDoc = await users.doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String bio = userData['bio'];
    String profilePhoto = userData['profilePic'];
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    var followerDoc = await users.doc(_uid.value).collection('followers').get();
    var followingDoc =
        await users.doc(_uid.value).collection('following').get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    await users
        .doc(_uid.value)
        .collection('followers')
        .doc(userId)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'bio': bio,
      'vids': myVideos.docs.length.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'profilePhoto': profilePhoto,
      'name': name,
    };
    update();
  }

  followUser() async {
    var doc =
        await users.doc(_uid.value).collection('followers').doc(userId).get();

    if (!doc.exists) {
      await users.doc(_uid.value).collection('followers').doc(userId).set({});
      await users.doc(userId).collection('following').doc(_uid.value).set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await users.doc(_uid.value).collection('followers').doc(userId).delete();
      await users.doc(userId).collection('following').doc(_uid.value).delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
