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

  List byYouVideoAudienceReactionPercentage(
      {int? vc, int? c, int? n, int? l, int? vl}) {
    int veryConservativePercentage = 0;
    int conservativePercentage = 0;
    int neutralPercentage = 0;
    int liberalPercentage = 0;
    int veryLiberalPercentage = 0;
    var totalOfReactions = vc! + c! + n! + l! + vl!;

    String largestPercentage = '';
    int maxValue = 0;

    veryConservativePercentage = ((vc) / totalOfReactions).isNaN
        ? 0
        : ((vc) / totalOfReactions).isInfinite
            ? 0
            : (((vc) / totalOfReactions) * 100).round();

    conservativePercentage = ((c) / totalOfReactions).isNaN
        ? 0
        : ((c) / totalOfReactions).isInfinite
            ? 0
            : (((c / totalOfReactions) * 100).round());
    neutralPercentage = ((n) / totalOfReactions).isNaN
        ? 0
        : ((n) / totalOfReactions).isInfinite
            ? 0
            : (((n) / totalOfReactions) * 100).round();
    liberalPercentage = ((l) / totalOfReactions).isNaN
        ? 0
        : ((l) / totalOfReactions).isInfinite
            ? 0
            : (((l) / totalOfReactions) * 100).round();
    veryLiberalPercentage = ((vl) / totalOfReactions).isNaN
        ? 0
        : ((vl) / totalOfReactions).isInfinite
            ? 0
            : (((vl) / totalOfReactions) * 100).round();

    List compare = [];

    compare.add(veryConservativePercentage);
    compare.add(conservativePercentage);
    compare.add(neutralPercentage);
    compare.add(liberalPercentage);
    compare.add(veryLiberalPercentage);

    compare.sort();

    maxValue = compare.last;

    if (veryConservativePercentage == maxValue) {
      largestPercentage = 'very conservative';
    } else if (conservativePercentage == maxValue) {
      largestPercentage = 'conservative';
    } else if (neutralPercentage == maxValue) {
      largestPercentage = 'neutral';
    } else if (liberalPercentage == maxValue) {
      largestPercentage = 'liberal';
    } else if (veryLiberalPercentage == maxValue) {
      largestPercentage = 'very liberal';
    }
    return [maxValue, largestPercentage];
  }
}
