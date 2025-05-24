import 'package:flutter/material.dart';

class ObstaculoAnimado extends StatelessWidget {
  final Animation<double> animacao;
  final double bottom;
  final double largura;
  final double larguraObstaculo;
  final double alturaObstaculo;
  final String asset;

  const ObstaculoAnimado({
    super.key,
    required this.animacao,
    required this.bottom,
    required this.largura,
    this.larguraObstaculo = 80,
    this.alturaObstaculo = 38,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    double posX = largura - (animacao.value * (largura + larguraObstaculo));
    return Positioned(
      bottom: bottom,
      left: posX,
      child: Image.asset(
        asset,
        width: larguraObstaculo,
        height: alturaObstaculo,
      ),
    );
  }
}
