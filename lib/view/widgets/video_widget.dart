import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart' as getx;
import '../../bnb.dart';
import '../../controller/video_controller.dart';
import '../../models/video.dart';
import '../../res.dart';
import '../screens/makeVideo/make_video.dart';
import '../screens/video_item.dart';
import 'circular_progress.dart';

class VideoWidget extends StatefulWidget {
  final VideoController? videoController;
  // final bool? isProfileController;
  // final ProfileVideoController? profileideoController;
  final Video? video;
  final String? name;
  final String? publishersID;
  final int? brainOnFireReactions;
  final String? profilePic;
  final String? description;
  final String? title;
  final String? videoTag;
  final List? hastags;
  final int? veryConservative;
  final int? conservative;
  final int? neutral;
  final int? liberal;
  final int? veryLiberal;
  final String? videoLink;

  const VideoWidget(
      {Key? key,
      this.brainOnFireReactions,
      // this.isProfileController,
      this.videoController,
      this.description,
      // this.profileideoController,
      this.hastags,
      this.conservative,
      this.liberal,
      this.neutral,
      this.veryConservative,
      this.veryLiberal,
      this.name,
      this.profilePic,
      this.publishersID,
      this.title,
      this.video,
      this.videoLink,
      this.videoTag})
      : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  bool isFavourite = false;
  bool seeMore = false;
  bool isbrainOnFire = false;
  bool isLoading = false;
  var totalOfReactions = 0;
  bool isBrainReactionLoading = false;
  bool tagReactionLoading = false;
  String largestPercentage = '';
  int maxValue = 0;

  bool? vc = false;
  bool? c = false;
  bool? n = false;
  bool? l = false;
  bool? vl = false;

  String selectedTag = '';

  updateIsBrainOnFireForCurrentuserInitially() async {
    await usersCollection
        .doc(userId)
        .collection('brainReactions')
        .where('videoLink', isEqualTo: widget.videoLink)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          setState(() {
            isbrainOnFire = true;
          });
        } else {
          setState(() {
            isbrainOnFire = false;
          });
        }
      }
    });
  }

  updateTagReactionForCurrentuserInitially() async {
    await usersCollection
        .doc(userId)
        .collection('tagReactions')
        .where('videoLink', isEqualTo: widget.videoLink)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          if (doc.id == 'veryConservative') {
            setState(() {
              vc = true;
              c = false;
              n = false;
              l = false;
              vl = false;
            });
          } else if (doc.id == conservative) {
            setState(() {
              vc = false;
              c = true;
              n = false;
              l = false;
              vl = false;
            });
          } else if (doc.id == neutral) {
            setState(() {
              vc = false;
              c = false;
              n = true;
              l = false;
              vl = false;
            });
          } else if (doc.id == liberal) {
            setState(() {
              vc = false;
              c = false;
              n = false;
              l = true;
              vl = false;
            });
          } else if (doc.id == 'veryLiberal') {
            setState(() {
              vc = false;
              c = false;
              n = false;
              l = false;
              vl = true;
            });
          } else {
            setState(() {
              vc = false;
              c = false;
              n = false;
              l = false;
              vl = false;
            });
          }
        }
      }
    });
  }

  updateHighestReactionPercentage() {
    int vc = ((widget.veryConservative)! / totalOfReactions).isNaN
        ? 0
        : ((widget.veryConservative)! / totalOfReactions).isInfinite
            ? 0
            : (((widget.veryConservative)! / totalOfReactions) * 100).round();
    int c = ((widget.conservative)! / totalOfReactions).isNaN
        ? 0
        : ((widget.conservative)! / totalOfReactions).isInfinite
            ? 0
            : (((widget.conservative)! / totalOfReactions) * 100).round();
    int n = ((widget.neutral)! / totalOfReactions).isNaN
        ? 0
        : ((widget.neutral)! / totalOfReactions).isInfinite
            ? 0
            : (((widget.neutral)! / totalOfReactions) * 100).round();
    int l = ((widget.liberal)! / totalOfReactions).isNaN
        ? 0
        : ((widget.liberal)! / totalOfReactions).isInfinite
            ? 0
            : (((widget.liberal)! / totalOfReactions) * 100).round();
    int vl = ((widget.veryLiberal)! / totalOfReactions).isNaN
        ? 0
        : ((widget.veryLiberal)! / totalOfReactions).isInfinite
            ? 0
            : (((widget.veryLiberal)! / totalOfReactions) * 100).round();

    List compare = [];

    compare.add(vc);
    compare.add(c);
    compare.add(n);
    compare.add(l);
    compare.add(vl);

    compare.sort();

    maxValue = compare.last;

    if (vc == maxValue) {
      largestPercentage = 'very conservative';
    } else if (c == maxValue) {
      largestPercentage = 'conservative';
    } else if (n == maxValue) {
      largestPercentage = 'neutral';
    } else if (l == maxValue) {
      largestPercentage = 'liberal';
    } else if (vl == maxValue) {
      largestPercentage = 'very liberal';
    }
  }

  @override
  void initState() {
    updateIsBrainOnFireForCurrentuserInitially();
    updateTagReactionForCurrentuserInitially();
    updateHighestReactionPercentage();
    totalOfReactions = widget.veryConservative! +
        widget.conservative! +
        widget.neutral! +
        widget.liberal! +
        widget.veryLiberal!;

    super.initState();
  }

  //updating the tags of video in existing documents on firestore
  getDocs({String? tag, int? selectedTag, bool? shouldAdd}) async {
    var inCompletePaths = [];
    var collectionPaths = [];
    var fullDocPaths = [];
    var finalCollectionPaths = [];
    var finalDocPaths = [];

    await FirebaseFirestore.instance
        .collectionGroup(tag!)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        inCompletePaths.add(doc.reference.path);
      }

      for (var doc in inCompletePaths) {
        var ss = doc.toString().split("/");
        ss.length = ss.length - 1;
        var sd = ss.join("/");
        collectionPaths.add(sd);
      }
    }).then((value) async {
      for (var collectionPath in collectionPaths) {
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .where('videoLink', isEqualTo: widget.videoLink)
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            fullDocPaths.add(doc.reference.path);
          }
        });
      }
      for (var doc in fullDocPaths) {
        var ab = doc.toString().split("/");
        var cd = ab.removeLast();
        var ss = doc.toString().split("/");
        ss.length = ss.length - 1;
        var sd = ss.join("/");
        finalDocPaths.add(cd);
        finalCollectionPaths.add(sd);
      }
    }).then((value) async {
      for (int i = 0; i < finalCollectionPaths.length; i++) {
        if (selectedTag == 1) {
          shouldAdd!
              ? await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  "veryConservative": widget.veryConservative! + 1,
                })
              : await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  "veryConservative": widget.veryConservative! == 0
                      ? 0
                      : widget.veryConservative! - 1,
                });
        } else if (selectedTag == 2) {
          shouldAdd!
              ? await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  "conservative": widget.conservative! + 1,
                })
              : await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  "conservative":
                      widget.conservative! == 0 ? 0 : widget.conservative! - 1,
                });
        } else if (selectedTag == 3) {
          shouldAdd!
              ? await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  "neutral": widget.neutral! + 1,
                })
              : await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  "neutral": widget.neutral! == 0 ? 0 : widget.neutral! - 1,
                });
        } else if (selectedTag == 4) {
          shouldAdd!
              ? await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  "liberal": widget.liberal! + 1,
                })
              : await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  "liberal": widget.liberal! == 0 ? 0 : widget.liberal! - 1,
                });
        } else if (selectedTag == 5) {
          shouldAdd!
              ? await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  'veryLiberal': widget.veryLiberal! + 1,
                })
              : await FirebaseFirestore.instance
                  .collection(finalCollectionPaths[i])
                  .doc(finalDocPaths[i])
                  .update({
                  'veryLiberal':
                      widget.veryLiberal! == 0 ? 0 : widget.veryLiberal! - 1,
                });
        }
      }
    });
  }

  selectedValue(value) async {
    var existingDoc = [];

    setState(() {
      tagReactionLoading = true;
    });
    if (value == 1) {
      setState(() {
        vc = true;
        c = false;
        n = false;
        l = false;
        vl = false;
      });

      await usersCollection
          .doc(userId)
          .collection('tagReactions')
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.size <= 0) {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .doc("veryConservative")
              .set(({'videoLink': widget.videoLink}));
          await getDocs(selectedTag: 1, tag: widget.videoTag, shouldAdd: true);
        } else {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .where('videoLink', isEqualTo: widget.videoLink)
              .get()
              .then((QuerySnapshot querySnapshot) async {
            for (var doc in querySnapshot.docs) {
              if (doc.exists) {
                if (doc.id != 'veryConservative') {
                  existingDoc.add(doc.id);
                }
              }
            }
            if (existingDoc.isNotEmpty) {
              for (var id in existingDoc) {
                if (id == conservative) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(conservative)
                      .delete();
                  await getDocs(
                      selectedTag: 2, tag: widget.videoTag, shouldAdd: false);
                } else if (id == neutral) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(neutral)
                      .delete();
                  await getDocs(
                      selectedTag: 3, tag: widget.videoTag, shouldAdd: false);
                } else if (id == liberal) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(liberal)
                      .delete();
                  await getDocs(
                      selectedTag: 4, tag: widget.videoTag, shouldAdd: false);
                } else if (id == 'veryLiberal') {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc('veryLiberal')
                      .delete();
                  await getDocs(
                      selectedTag: 5, tag: widget.videoTag, shouldAdd: false);
                }
              }
              await usersCollection
                  .doc(userId)
                  .collection('tagReactions')
                  .doc('veryConservative')
                  .set(({'videoLink': widget.videoLink}));
              await getDocs(
                  selectedTag: 1, tag: widget.videoTag, shouldAdd: true);
            }
          });
        }
      });
    } else if (value == 2) {
      setState(() {
        vc = false;
        c = true;
        n = false;
        l = false;
        vl = false;
      });
      await usersCollection
          .doc(userId)
          .collection('tagReactions')
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.size <= 0) {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .doc(conservative)
              .set(({'videoLink': widget.videoLink}));
          await getDocs(selectedTag: 2, tag: widget.videoTag, shouldAdd: true);
        } else {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .where('videoLink', isEqualTo: widget.videoLink)
              .get()
              .then((QuerySnapshot querySnapshot) async {
            for (var doc in querySnapshot.docs) {
              if (doc.exists) {
                if (doc.id != conservative) {
                  existingDoc.add(doc.id);
                }
              }
            }
            if (existingDoc.isNotEmpty) {
              for (var id in existingDoc) {
                if (id == 'veryConservative') {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc('veryConservative')
                      .delete();
                  await getDocs(
                      selectedTag: 1, tag: widget.videoTag, shouldAdd: false);
                } else if (id == neutral) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(neutral)
                      .delete();
                  await getDocs(
                      selectedTag: 3, tag: widget.videoTag, shouldAdd: false);
                } else if (id == liberal) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(liberal)
                      .delete();
                  await getDocs(
                      selectedTag: 4, tag: widget.videoTag, shouldAdd: false);
                } else if (id == 'veryLiberal') {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc('veryLiberal')
                      .delete();
                  await getDocs(
                      selectedTag: 5, tag: widget.videoTag, shouldAdd: false);
                }
              }
              await usersCollection
                  .doc(userId)
                  .collection('tagReactions')
                  .doc(conservative)
                  .set(({'videoLink': widget.videoLink}));
              await getDocs(
                  selectedTag: 2, tag: widget.videoTag, shouldAdd: true);
            }
          });
        }
      });
    } else if (value == 3) {
      setState(() {
        vc = false;
        c = false;
        n = true;
        l = false;
        vl = false;
      });
      await usersCollection
          .doc(userId)
          .collection('tagReactions')
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.size <= 0) {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .doc(neutral)
              .set(({'videoLink': widget.videoLink}));
          await getDocs(selectedTag: 3, tag: widget.videoTag, shouldAdd: true);
        } else {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .where('videoLink', isEqualTo: widget.videoLink)
              .get()
              .then((QuerySnapshot querySnapshot) async {
            for (var doc in querySnapshot.docs) {
              if (doc.exists) {
                if (doc.id != neutral) {
                  existingDoc.add(doc.id);
                }
              }
            }
            if (existingDoc.isNotEmpty) {
              for (var id in existingDoc) {
                if (id == 'veryConservative') {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc('veryConservative')
                      .delete();
                  await getDocs(
                      selectedTag: 1, tag: widget.videoTag, shouldAdd: false);
                } else if (id == conservative) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(conservative)
                      .delete();
                  await getDocs(
                      selectedTag: 2, tag: widget.videoTag, shouldAdd: false);
                } else if (id == liberal) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(liberal)
                      .delete();
                  await getDocs(
                      selectedTag: 4, tag: widget.videoTag, shouldAdd: false);
                } else if (id == 'veryLiberal') {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc('veryLiberal')
                      .delete();
                  await getDocs(
                      selectedTag: 5, tag: widget.videoTag, shouldAdd: false);
                }
              }
              await usersCollection
                  .doc(userId)
                  .collection('tagReactions')
                  .doc(neutral)
                  .set(({'videoLink': widget.videoLink}));
              await getDocs(
                  selectedTag: 3, tag: widget.videoTag, shouldAdd: true);
            }
          });
        }
      });
    } else if (value == 4) {
      setState(() {
        vc = false;
        c = false;
        n = false;
        l = true;
        vl = false;
      });
      await usersCollection
          .doc(userId)
          .collection('tagReactions')
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.size <= 0) {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .doc(liberal)
              .set(({'videoLink': widget.videoLink}));
          await getDocs(selectedTag: 4, tag: widget.videoTag, shouldAdd: true);
        } else {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .where('videoLink', isEqualTo: widget.videoLink)
              .get()
              .then((QuerySnapshot querySnapshot) async {
            for (var doc in querySnapshot.docs) {
              if (doc.exists) {
                if (doc.id != liberal) {
                  existingDoc.add(doc.id);
                }
              }
            }
            if (existingDoc.isNotEmpty) {
              for (var id in existingDoc) {
                if (id == 'veryConservative') {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc('veryConservative')
                      .delete();
                  await getDocs(
                      selectedTag: 1, tag: widget.videoTag, shouldAdd: false);
                } else if (id == conservative) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(conservative)
                      .delete();
                  await getDocs(
                      selectedTag: 2, tag: widget.videoTag, shouldAdd: false);
                } else if (id == neutral) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(neutral)
                      .delete();
                  await getDocs(
                      selectedTag: 3, tag: widget.videoTag, shouldAdd: false);
                } else if (id == 'veryLiberal') {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc('veryLiberal')
                      .delete();
                  await getDocs(
                      selectedTag: 5, tag: widget.videoTag, shouldAdd: false);
                }
              }
              await usersCollection
                  .doc(userId)
                  .collection('tagReactions')
                  .doc(liberal)
                  .set(({'videoLink': widget.videoLink}));
              await getDocs(
                  selectedTag: 4, tag: widget.videoTag, shouldAdd: true);
            }
          });
        }
      });
    } else if (value == 5) {
      setState(() {
        vc = false;
        c = false;
        n = false;
        l = false;
        vl = true;
      });
      await usersCollection
          .doc(userId)
          .collection('tagReactions')
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.size <= 0) {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .doc('veryLiberal')
              .set(({'videoLink': widget.videoLink}));
          await getDocs(selectedTag: 5, tag: widget.videoTag, shouldAdd: true);
        } else {
          await usersCollection
              .doc(userId)
              .collection('tagReactions')
              .where('videoLink', isEqualTo: widget.videoLink)
              .get()
              .then((QuerySnapshot querySnapshot) async {
            for (var doc in querySnapshot.docs) {
              if (doc.exists) {
                if (doc.id != 'veryLiberal') {
                  existingDoc.add(doc.id);
                }
              }
            }
            if (existingDoc.isNotEmpty) {
              for (var id in existingDoc) {
                if (id == 'veryConservative') {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc('veryConservative')
                      .delete();
                  await getDocs(
                      selectedTag: 1, tag: widget.videoTag, shouldAdd: false);
                } else if (id == conservative) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(conservative)
                      .delete();
                  await getDocs(
                      selectedTag: 2, tag: widget.videoTag, shouldAdd: false);
                } else if (id == neutral) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(neutral)
                      .delete();
                  await getDocs(
                      selectedTag: 3, tag: widget.videoTag, shouldAdd: false);
                } else if (id == liberal) {
                  await usersCollection
                      .doc(userId)
                      .collection('tagReactions')
                      .doc(liberal)
                      .delete();
                  await getDocs(
                      selectedTag: 4, tag: widget.videoTag, shouldAdd: false);
                }
              }
              await usersCollection
                  .doc(userId)
                  .collection('tagReactions')
                  .doc('veryLiberal')
                  .set(({'videoLink': widget.videoLink}));
              await getDocs(
                  selectedTag: 5, tag: widget.videoTag, shouldAdd: true);
            }
          });
        }
      });
    }
    setState(() {
      tagReactionLoading = false;
    });
  }

//updating the brainOnFireReaction in existing videodocuments on firestore
  getVideoDocs({bool? isBrainOnFireReaction, String? tag}) async {
    var inCompletePaths = [];
    var collectionPaths = [];
    var fullDocPaths = [];
    var finalCollectionPaths = [];
    var finalDocPaths = [];

    await FirebaseFirestore.instance
        .collectionGroup(tag!)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        inCompletePaths.add(doc.reference.path);
      }

      for (var doc in inCompletePaths) {
        var ss = doc.toString().split("/");
        ss.length = ss.length - 1;
        var sd = ss.join("/");
        collectionPaths.add(sd);
      }
    }).then((value) async {
      for (var collectionPath in collectionPaths) {
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .where('videoLink', isEqualTo: widget.videoLink)
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            fullDocPaths.add(doc.reference.path);
          }
        });
      }
      for (var doc in fullDocPaths) {
        var ab = doc.toString().split("/");
        var cd = ab.removeLast();
        var ss = doc.toString().split("/");
        ss.length = ss.length - 1;
        var sd = ss.join("/");
        finalDocPaths.add(cd);
        finalCollectionPaths.add(sd);
      }
    }).then((value) async {
      if (isBrainOnFireReaction!) {
        for (int i = 0; i < finalCollectionPaths.length; i++) {
          await FirebaseFirestore.instance
              .collection(finalCollectionPaths[i])
              .doc(finalDocPaths[i])
              .update({
            'brainOnFireReactions': widget.brainOnFireReactions! + 1,
          });
        }
      } else {
        for (int i = 0; i < finalCollectionPaths.length; i++) {
          await FirebaseFirestore.instance
              .collection(finalCollectionPaths[i])
              .doc(finalDocPaths[i])
              .update({
            'brainOnFireReactions': widget.brainOnFireReactions! == 0
                ? 0
                : widget.brainOnFireReactions! - 1,
          });
        }
      }
    });
  }

  brainOnFireReactionUpdate(bool isBainOnFire) async {
    var existingDoc = [];
    setState(() {
      isBrainReactionLoading = true;
    });
    if (isbrainOnFire) {
      await usersCollection
          .doc(userId)
          .collection('brainReactions')
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.size <= 0) {
          await usersCollection
              .doc(userId)
              .collection('brainReactions')
              .add(({'videoLink': widget.videoLink}));
          await getVideoDocs(isBrainOnFireReaction: true, tag: widget.videoTag);
        } else {
          await usersCollection
              .doc(userId)
              .collection('brainReactions')
              .where('videoLink', isEqualTo: widget.videoLink)
              .get()
              .then((QuerySnapshot querySnapshot) async {
            for (var doc in querySnapshot.docs) {
              if (doc.exists) {
                existingDoc.add(doc.id);
              }
            }
            if (existingDoc.isNotEmpty) {
              for (var id in existingDoc) {
                await usersCollection
                    .doc(userId)
                    .collection('brainReactions')
                    .doc(id)
                    .delete();
                await getVideoDocs(
                    isBrainOnFireReaction: false, tag: widget.videoTag);
              }
            } else {
              await usersCollection
                  .doc(userId)
                  .collection('brainReactions')
                  .add(({'videoLink': widget.videoLink}));
              await getVideoDocs(
                  isBrainOnFireReaction: true, tag: widget.videoTag);
            }
          });
        }
      });
    } else {
      await usersCollection
          .doc(userId)
          .collection('brainReactions')
          .where('videoLink', isEqualTo: widget.videoLink)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          if (doc.exists) {
            existingDoc.add(doc.id);
          }
        }
        if (existingDoc.isNotEmpty) {
          for (var id in existingDoc) {
            await usersCollection
                .doc(userId)
                .collection('brainReactions')
                .doc(id)
                .delete();
            await getVideoDocs(
                isBrainOnFireReaction: false, tag: widget.videoTag);
          }
        }
      });
    }

    setState(() {
      isBrainReactionLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayerItem(
          videoUrl: widget.videoLink!,
        ),
        Transform.rotate(
          angle: 180.0 * pi / 180,
          child: Container(
            height: screenHeight(context) * 0.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF8B7070),
                  Colors.black.withOpacity(0.0),
                  Colors.white
                ],
                stops: const [0.0, 0.0, 1.0],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.rotate(
            angle: 180 * pi / 180,
            child: Container(
              height: screenHeight(context) * 0.23,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white10,
                    Colors.white,
                  ],
                  stops: [0, 0.2, 0.9],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: SizedBox(
                width: screenWidth(context) * 0.95,
                height: seeMore
                    ? screenHeight(context) * 0.25
                    : screenHeight(context) * 0.22,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth(context) * 0.13,
                          height: screenHeight(context) * 0.06,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isBrainReactionLoading
                                  ? SizedBox(
                                      width: screenWidth(context) * 0.08,
                                      height: screenHeight(context) * 0.03,
                                      child: const CircularProgress())
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          isbrainOnFire = !isbrainOnFire;
                                          brainOnFireReactionUpdate(
                                              isbrainOnFire);
                                        });
                                      },
                                      child: isbrainOnFire
                                          ? SvgPicture.asset(
                                              'assets/svgs/brainOnFire.svg')
                                          : SvgPicture.asset(
                                              'assets/svgs/brain.svg')),
                              txt(
                                  txt: widget.brainOnFireReactions!.toString(),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontColor: isbrainOnFire
                                      ? const Color(blueColor)
                                      : Colors.white)
                            ],
                          ),
                        ),
                        navigator(
                            function: MakeVideo(
                              hastags: widget.hastags!,
                              isAddingToThChain: true,
                              title: widget.title,
                            ),
                            child: SvgPicture.asset('assets/svgs/slant.svg')),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        navigator(
                          function:
                              BNB(isProfile: true, uid: widget.publishersID!),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 30,
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: widget.profilePic == null ||
                                      widget.profilePic.toString().isEmpty
                                  ? 'https://www.kindpng.com/picc/m/285-2855863_a-festival-celebrating-tractors-round-profile-picture-placeholder.png'
                                  : widget.profilePic!,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 30,
                                      backgroundImage: imageProvider),
                              placeholder: (context, url) =>
                                  const CircularProgress(),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'assets/images/placeholder.png')),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth(context) * 0.04,
                        ),
                        SizedBox(
                          width: screenWidth(context) * 0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              txt(
                                maxLines: 1,
                                txt: '${widget.name} perspective on',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: seeMore
                                    ? screenHeight(context) * 0.055
                                    : screenHeight(context) * 0.015,
                                child: Row(
                                  crossAxisAlignment: seeMore
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: AutoSizeText(
                                          widget.description!,
                                          maxLines: seeMore ? 5 : 1,
                                          maxFontSize: 10,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: seeMore ? 5 : 8,
                                          style: const TextStyle(
                                            fontFamily: 'OpenSans',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    widget.description!.length == 20
                                        ? seeMore
                                            ? GestureDetector(
                                                child: txt(
                                                  txt: 'see less',
                                                  fontSize: 10,
                                                  fontColor:
                                                      const Color(blueColor),
                                                ),
                                                onTap: () => setState(
                                                    () => seeMore = false))
                                            : GestureDetector(
                                                child: txt(
                                                  txt: 'see more',
                                                  fontSize: 10,
                                                  fontColor:
                                                      const Color(blueColor),
                                                ),
                                                onTap: () => setState(
                                                    () => seeMore = true))
                                        : Container(),
                                  ],
                                ),
                              ),
                              txt(
                                  maxLines: 1,
                                  txt: '#${widget.title}',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontColor: const Color(blueColor)),
                              txt(
                                  maxLines: 1,
                                  txt: '#Being ${widget.videoTag}',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontColor: const Color(blueColor))
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.015,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            widget.veryConservative == 0 &&
                                    widget.conservative == 0 &&
                                    widget.neutral == 0 &&
                                    widget.liberal == 0 &&
                                    widget.veryLiberal == 0
                                ? Row(children: [
                                    SizedBox(
                                      width: screenWidth(context) * 0.8,
                                      child: txt(
                                          maxLines: 1,
                                          txt:
                                              'No response from the audience on this video yet',
                                          fontWeight: FontWeight.bold,
                                          fontColor: Colors.black45,
                                          fontSize: 12),
                                    ),
                                  ])
                                : Row(children: [
                                    SizedBox(
                                      width: screenWidth(context) * 0.08,
                                      child: txt(
                                        maxLines: 1,
                                        txt: '${maxValue.toString()}%',
                                        fontColor: const Color(blueColor),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.45,
                                      child: txt(
                                          maxLines: 1,
                                          txt:
                                              ' audience labelled this video as ',
                                          fontWeight: FontWeight.bold,
                                          fontColor: Colors.black45,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.25,
                                      child: txt(
                                        maxLines: 1,
                                        txt: '#$largestPercentage',
                                        fontColor: const Color(blueColor),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ]),
                            txt(
                              txt: 'What do you think?',
                              fontColor: const Color(blueColor),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ],
                        ),
                        const Spacer(),
                        tagReactionLoading
                            ? const CircularProgress()
                            : PopupMenuButton(
                                offset: const Offset(0, -250),
                                color: const Color(blueColor),
                                onSelected: (value) {
                                  selectedValue(value);
                                },
                                elevation: 3.2,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: SvgPicture.asset(
                                    'assets/svgs/microphone.svg'),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: popupmenuItem(
                                            context,
                                            'Very Conservative',
                                            '${((((widget.veryConservative)! / totalOfReactions).isNaN ? 0 : (widget.veryConservative)! / totalOfReactions).isInfinite ? 0 : ((widget.veryConservative)! / totalOfReactions) * 100).round()}%',
                                            vc! ? true : false),
                                        value: 1,
                                      ),
                                      PopupMenuItem(
                                        child: popupmenuItem(
                                            context,
                                            'Conservative',
                                            '${((((widget.conservative)! / totalOfReactions).isNaN ? 0 : (widget.conservative)! / totalOfReactions).isInfinite ? 0 : ((widget.conservative)! / totalOfReactions) * 100).round()}%',
                                            c! ? true : false),
                                        value: 2,
                                      ),
                                      PopupMenuItem(
                                        child: popupmenuItem(
                                            context,
                                            'Neutral',
                                            '${((((widget.neutral)! / totalOfReactions).isNaN ? 0 : (widget.neutral)! / totalOfReactions).isInfinite ? 0 : ((widget.neutral)! / totalOfReactions) * 100).round()}%',
                                            n! ? true : false),
                                        value: 3,
                                      ),
                                      PopupMenuItem(
                                        child: popupmenuItem(
                                            context,
                                            'Liberal',
                                            '${((((widget.liberal)! / totalOfReactions).isNaN ? 0 : (widget.liberal)! / totalOfReactions).isInfinite ? 0 : ((widget.liberal)! / totalOfReactions) * 100).round()}%',
                                            l! ? true : false),
                                        value: 4,
                                      ),
                                      PopupMenuItem(
                                        child: popupmenuItem(
                                            context,
                                            'Very Liberal',
                                            '${((((widget.veryLiberal)! / totalOfReactions).isNaN ? 0 : (widget.veryLiberal)! / totalOfReactions).isInfinite ? 0 : ((widget.veryLiberal)! / totalOfReactions) * 100).round()}%',
                                            vl! ? true : false),
                                        value: 5,
                                      ),
                                    ]),
                      ],
                    ),
                  ],
                ),
              )),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SvgPicture.asset('assets/svgs/share.svg'),
              SizedBox(
                width: screenWidth(context) * 0.03,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (isFavourite) {
                    setState(() {
                      isFavourite = false;
                    });
                    await widget.videoController!
                        .likeVideo(widget.video!, false);
                  } else {
                    setState(() {
                      isFavourite = true;
                    });
                    await widget.videoController!
                        .likeVideo(widget.video!, true);
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                child: SizedBox(
                  height: screenHeight(context) * 0.04,
                  child: isLoading
                      ? const Center(child: CircularProgress())
                      : FutureBuilder<bool>(
                          future: widget.videoController!
                              .whetherVideoLikedOrNot(
                                  videoLink: widget.videoLink),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.data == true) {
                              return const Icon(
                                Icons.favorite,
                                color: Color(redColor),
                                size: 30,
                              );
                            } else {
                              return SvgPicture.asset('assets/svgs/heart.svg');
                            }
                          },
                        ),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }
}

Row popupmenuItem(BuildContext context, String? itemText,
    String? itemPercentage, bool? isSelected) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(
          itemText!,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      SizedBox(
        width: screenWidth(context) * 0.1,
      ),
      Container(
        width: screenWidth(context) * 0.1,
        height: screenHeight(context) * 0.04,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected! ? Colors.green.shade400 : Colors.white,
        ),
        child: Center(
          child: txt(
              txt: itemPercentage!,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontColor: isSelected ? Colors.white : const Color(blueColor)),
        ),
      )
    ],
  );
}
