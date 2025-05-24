import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PassaroAnimado extends StatelessWidget {
  final Animation<double> animacao;
  final bool mostrar;
  final double top;
  final double largura;

  const PassaroAnimado({
    super.key,
    required this.animacao,
    required this.mostrar,
    required this.top,
    this.largura = 140,
  });

  @override
  Widget build(BuildContext context) {
    if (!mostrar) return SizedBox.shrink();
    return AnimatedBuilder(
      animation: animacao,
      builder: (_, __) => Positioned(
        top: top,
        left: animacao.value,
        child: SizedBox(
          width: largura,
          child: Lottie.asset('assets/animacao/passaro.json'),
        ),
      ),
    );
  }
}
