// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:slant/res.dart';

// class SearchController extends GetxController {
//   final Rx<List> _searchedTitles = Rx<List>([]);

//   List get searchedTitles => _searchedTitles.value;

//   searchTitles(String typedTitle) async {
//     _searchedTitles.bindStream(FirebaseFirestore.instance
//         .collection('titles')
//         .doc(typedTitle)
//         .collection(neutral)
//         .snapshots()
//         .map((QuerySnapshot query) {
//       List retVal = [];
//       for (var elem in query.docs) {
//         retVal.add(elem);
//       }
//       return retVal;
//     }));
//   }
// }
