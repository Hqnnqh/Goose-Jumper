import 'package:flutter/material.dart';

class Goose extends StatelessWidget {
  final String skinId;
  final double gooseY;
  final bool visible;

  const Goose(
      {Key? key,
      required this.gooseY,
      required this.skinId,
      required this.visible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, gooseY),
      child: (visible)
          ? Image.asset(
              'images/skins/$skinId.png',
              width: 75,
              height: 75,
            )
          : null,
    );
  }
}
