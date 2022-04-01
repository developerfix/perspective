import 'package:diamond_bottom_bar/diamond_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:perspective/res.dart';
import 'package:perspective/screens/Favourites.dart';
import 'package:perspective/screens/HomeScreen.dart';
import 'package:perspective/screens/Profile.dart';
import 'package:perspective/screens/discover/discover.dart';
import 'package:perspective/screens/makeVideo/makeVideo.dart';

class BNB extends StatefulWidget {
  const BNB({Key? key}) : super(key: key);

  @override
  State<BNB> createState() => _BNBState();
}

class _BNBState extends State<BNB> {
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
              builder: (_) => const MakeVideo(),
            ),
          );
          break;
        case 3:
          _scrn = const Favourites();
          break;
        case 4:
          _scrn = const Profile();
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

    _scrn = const HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            _selectedIndex = _;
            screen(_);
          },
        ),
      ),
    );
  }
}
