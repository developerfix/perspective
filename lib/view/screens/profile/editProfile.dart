import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slant/auth/login.dart';
import 'dart:math';
import 'package:slant/res.dart';
import 'package:slant/view/widgets/circularProgress.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // initializing some values
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  late Map<String, dynamic> dataChecker;

  // picking the image

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No Image selected");
      }
    });
  }

  // uploading the image to firebase cloudstore
  Future uploadContent(File _image) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('$userId/images')
        .child("post_$imgId");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    // cloud firestore
    await firebaseFirestore
        .collection("users")
        .doc(userId)
        .update({
          'profilePic': downloadURL,
          // 'name': _nameController.text,
          // 'bio': _statusController,
          // 'address': _addressController
        })
        .onError((error, stackTrace) =>
            showSnackBar('Something went wrong, please try again'))
        .whenComplete(() => showSnackBar('Changes Saved'));
  }

  showSnackBar(String snackText) {
    final snackBar = SnackBar(content: Text(snackText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = '';
    _statusController.text = '';
    _addressController.text = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Material(
      child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(userId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              dataChecker = data;

              return SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: DefaultTabController(
                    length: 2,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: screenHeight(context) * 0.95,
                        width: screenWidth(context),
                        child: Column(
                          children: [
                            Container(
                              height: screenHeight(context) * 0.08,
                              color: const Color(0xFF080808),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.arrow_back,
                                        color: Colors.white),
                                    txt(
                                        txt: 'Edit Profile',
                                        fontSize: 18,
                                        fontColor: Colors.white),
                                    Container(
                                      width: screenWidth(context) * 0.005,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.75,
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      SizedBox(
                                          height: screenHeight(context) * 0.2,
                                          width: screenWidth(context) * 0.4,
                                          child: Stack(
                                            children: [
                                              _image == null
                                                  ? CircleAvatar(
                                                      radius: 100,
                                                      child: data['profilePic']
                                                              .toString()
                                                              .isEmpty
                                                          ? const CircleAvatar(
                                                              radius: 95,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      'assets/images/placeholder.png'))
                                                          : CircleAvatar(
                                                              radius: 95,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      '${data['profilePic']}'),
                                                            ))
                                                  : CircleAvatar(
                                                      radius: 100,
                                                      child: CircleAvatar(
                                                          radius: 95,
                                                          backgroundImage:
                                                              Image.file(
                                                            _image!,
                                                          ).image),
                                                      //   data['profilePic'] == null ?  const AssetImage(
                                                      //             'assets/images/placeholder.png'
                                                      //           ) :

                                                      //           NetworkImage('${data['profilePic']}'),
                                                      // )
                                                      //  _image == null?  CircleAvatar(
                                                      //       radius: 95,
                                                      //       backgroundImage:
                                                      //       data['profilePic'] == null ?  const AssetImage(
                                                      //               'assets/images/placeholder.png'
                                                      //             ) : NetworkImage('${data['profilePic']}')

                                                      //       ) : CircleAvatar(
                                                      //       radius: 95,
                                                      //       backgroundImage:  Image.file(
                                                      //               _image!,
                                                      //             ).image),
                                                    ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.white54,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.add_a_photo,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () {
                                                      imagePickerMethod();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        height: screenHeight(context) * 0.05,
                                      ),
                                      textField(
                                        context: context,
                                        hinttext: '${data['name']}',
                                        prefixIcon: const Icon(
                                          Icons.person,
                                        ),
                                        controller: _nameController,
                                      ),
                                      SizedBox(
                                        height: screenHeight(context) * 0.05,
                                      ),
                                      textField(
                                        context: context,
                                        hinttext: '${data['bio']}',
                                        prefixIcon: const Icon(
                                          Icons.add,
                                        ),
                                        controller: _statusController,
                                      ),
                                      SizedBox(
                                        height: screenHeight(context) * 0.05,
                                      ),
                                      textField(
                                        context: context,
                                        hinttext: '${data['address']}',
                                        prefixIcon:
                                            const Icon(Icons.add_location),
                                        controller: _addressController,
                                      ),
                                      SizedBox(
                                        height: screenHeight(context) * 0.015,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                if (_nameController.text.isEmpty &&
                                    _addressController.text.isEmpty &&
                                    _statusController.text.isEmpty &&
                                    _image == null) {
                                  showSnackBar(
                                    "Made some changes first",
                                  );
                                } else {
                                  uploadContent(_image!);
                                }
                              },
                              child: Container(
                                height: screenHeight(context) * 0.088,
                                color: Colors.black,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      txt(
                                          txt: 'Save Changes',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontColor: Colors.white),
                                      SizedBox(
                                        width: screenWidth(context) * 0.03,
                                      ),
                                      Transform.rotate(
                                        angle: pi,
                                        child: SvgPicture.asset(
                                          'assets/svgs/arrowForward.svg',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return const Scaffold(body: Center(child: CircularProgress()));
          }),
    );
  }
}

Padding favouriteItem(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SizedBox(
      height: screenHeight(context) * 0.2,
      child: Stack(
        children: [
          Container(
            height: screenHeight(context) * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                image: const AssetImage('assets/images/pic.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstIn),
              ),
            ),
          ),
          Container(
            height: screenHeight(context) * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.string(
              '<svg viewBox="174.78 378.56 39.93 39.93" ><path transform="translate(174.22, 377.99)" d="M 20.52500152587891 0.5625 C 9.497329711914062 0.5625 0.5625 9.497329711914062 0.5625 20.52500152587891 C 0.5625 31.55267333984375 9.497329711914062 40.48750686645508 20.52500152587891 40.48750686645508 C 31.55267333984375 40.48750686645508 40.48750686645508 31.55267333984375 40.48750686645508 20.52500152587891 C 40.48750686645508 9.497329711914062 31.55267333984375 0.5625 20.52500152587891 0.5625 Z M 29.8381519317627 22.45685577392578 L 15.67121505737305 30.58674240112305 C 14.39941215515137 31.29509162902832 12.79758167266846 30.3855094909668 12.79758167266846 28.89637184143066 L 12.79758167266846 12.15362930297852 C 12.79758167266846 10.67253971099854 14.39136123657227 9.754909515380859 15.67121505737305 10.46325588226318 L 29.8381519317627 19.07611083984375 C 31.15825271606445 19.81665420532227 31.15825271606445 21.72436141967773 29.8381519317627 22.45685577392578 Z" fill="#3b5998" stroke="none" stroke-width="5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
              width: 39.93,
              height: 39.93,
            ),
          ),
          Positioned(
            top: 15,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txt(
                    txt: 'Bidens no war policy',
                    fontColor: const Color(blueColor),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
                const Text(
                  '#Elections',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            left: 10,
            child: SizedBox(
              width: screenWidth(context) * 0.85,
              child: Row(
                children: [
                  txt(
                    txt: '37%',
                    fontColor: const Color(blueColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  txt(
                    txt: ' audience labelled this video as ',
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.black45,
                    fontSize: 12,
                  ),
                  txt(
                    txt: '#very liberal',
                    fontColor: const Color(blueColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.play_arrow, color: Color(blueColor)),
                      txt(
                        txt: '21.k',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontColor: const Color(blueColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
