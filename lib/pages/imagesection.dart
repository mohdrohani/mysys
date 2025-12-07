import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // #docregion image-asset
    return Image.asset(
      image,
      width: screenWidth,
      height: 240,
      fit: BoxFit.cover,
    );
    // #enddocregion image-asset
  }
}
