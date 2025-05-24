import 'dart:math';
import 'package:flutter/material.dart';

class PrincipalController {
  late AnimationController controladorFundo;
  late Animation<double> nuvem1;
  late Animation<double> nuvem2;
  late Animation<double> deslocamento;

  late AnimationController passaroController;
  late AnimationController aviaoController;
  late Animation<double> animacaoPassaro;
  late Animation<double> animacaoAviao;

  bool mostrarPassaro = false;
  bool mostrarAviao = false;
  double alturaPassaro = 100.0;
  final Random random = Random();

  void iniciarAnimacoes(TickerProvider vsync) {
    controladorFundo = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 20),
    )..repeat();

    nuvem1 = Tween<double>(begin: -30, end: 100).animate(
      CurvedAnimation(parent: controladorFundo, curve: Curves.linear),
    );
    nuvem2 = Tween<double>(begin: 30, end: -60).animate(
      CurvedAnimation(parent: controladorFundo, curve: Curves.linear),
    );
    deslocamento = Tween<double>(begin: 0, end: 1).animate(controladorFundo);

    passaroController = AnimationController(vsync: vsync, duration: const Duration(seconds: 6));
    aviaoController = AnimationController(vsync: vsync, duration: const Duration(seconds: 6));
  }

  void atualizarLargura(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    animacaoPassaro = Tween<double>(begin: -200, end: largura + 200).animate(passaroController);
    animacaoAviao = Tween<double>(begin: -300, end: largura + 300).animate(aviaoController);
  }

  void animarElementos({
    required VoidCallback mostrarPassaro,
    required VoidCallback esconderPassaro,
    required VoidCallback mostrarAviao,
    required VoidCallback esconderAviao,
  }) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      mostrarPassaro();
      await passaroController.forward(from: 0);
      esconderPassaro();

      await Future.delayed(const Duration(seconds: 3));
      mostrarAviao();
      await aviaoController.forward(from: 0);
      esconderAviao();
    }
  }

  void dispose() {
    controladorFundo.dispose();
    passaroController.dispose();
    aviaoController.dispose();
  }
}
