// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CoinButton extends StatefulWidget {
  const CoinButton({required this.taper, super.key});

  final Function taper;

  @override
  _CoinButtonState createState() => _CoinButtonState();
}

class _CoinButtonState extends State<CoinButton> with TickerProviderStateMixin {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onHighlightChanged: (value) {
          setState(() {
            isTapped = value;
          });
        },
        onTap: () => widget.taper(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          height: isTapped ? 200 : 220,
          width: isTapped ? 300 : 400,
          child: Image.asset(
            fit: BoxFit.cover,
            'assets/c.png',
          ),
        ),
      ),
    );
  }
}
