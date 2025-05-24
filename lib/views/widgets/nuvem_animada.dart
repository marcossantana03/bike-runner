import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NuvemAnimada extends StatelessWidget {
  final double top;
  final double? left;
  final double? right;
  final double width;
  final double height;
  const NuvemAnimada({
    super.key,
    required this.top,
    this.left,
    this.right,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: SizedBox(
        width: width,
        height: height,
        child: Lottie.asset('assets/animacao/nuvem.json'),
      ),
    );
  }
}

