import 'package:camera/camera.dart';
import 'package:diamond_bottom_bar/diamond_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slant/res.dart';
import 'package:slant/view/screens/HomeScreen.dart';
import 'package:slant/view/screens/discover/discover.dart';
import 'package:slant/view/screens/favourites.dart';
import 'package:slant/view/screens/makeVideo/makeVideo.dart';
import 'package:slant/view/screens/profile/profile.dart';

class BNB extends StatefulWidget {
  final bool? isProfile;
  final String? uid;
  const BNB({Key? key, this.isProfile, this.uid}) : super(key: key);

  @override
  State<BNB> createState() => _BNBState();
}

class _BNBState extends State<BNB> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Widget? _scrn;
  int? _selectedIndex = 0;

  void screen(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _scrn = const HomeScreen();
          break;
        case 1:
          _scrn = const Discover();
          break;
        case 2:
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => const MakeVideo(
                hastags: [],
                isAddingToThChain: false,
                title: '',
              ),
            ),
          );
          break;
        case 3:
          _scrn = const Favourites();
          break;
        case 4:
          _scrn = Profile(uid: userId!);
          break;
        default:
          _scrn = const HomeScreen();
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.isProfile == true) {
      _scrn = Profile(uid: widget.uid!);
      screen(4);
    } else {
      screen(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          final differeance = DateTime.now().difference(timeBackPressed);
          timeBackPressed = DateTime.now();
          if (differeance >= const Duration(seconds: 2)) {
            const String msg = 'Press the back button to exit';
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(msg),
            ));

            return false;
          } else {
            SystemNavigator.pop();
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _scrn,
          bottomNavigationBar: DiamondBottomNavigation(
            height: screenHeight(context) * 0.075,
            selectedColor: const Color(blueColor),
            itemIcons: const [
              Icons.home,
              Icons.search,
              Icons.favorite,
              Icons.person,
            ],
            selectedLightColor: const Color(blueColor),
            centerIcon: Icons.add,
            selectedIndex: _selectedIndex!,
            onItemPressed: (_) {
              // _selectedIndex = _;
              screen(_);
            },
          ),
        ),
      ),
    );
  }
}
