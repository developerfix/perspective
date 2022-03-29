import 'package:flutter/material.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 375.0,
          height: 65.0,
          color: const Color(0xFF080808),
        )
      ],
    );
  }
}
