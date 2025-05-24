import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CiclistaAnimado extends StatelessWidget {
  final double left;
  final double bottom;
  final double width;
  final double? rotation;

  const CiclistaAnimado({
    super.key,
    required this.left,
    required this.bottom,
    this.width = 260,
    this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    Widget ciclista = Lottie.asset(
      'assets/animacao/ciclista.json',
      width: width,
      repeat: true,
    );
    if (rotation != null) {
      ciclista = Transform.rotate(
        angle: rotation!,
        alignment: Alignment(-0.6, 1.2),
        child: ciclista,
      );
    }
    return Positioned(
      bottom: bottom,
      left: left,
      child: ciclista,
    );
  }
}
