import 'package:flutter/material.dart';
import 'package:runbike/views/widgets/nuvem_animada.dart';

class CenarioBase extends StatelessWidget {
  final String assetCeuDia;
  final String assetCeuNoite;
  final double cicloValue;
  final Animation<double> deslocamento;
  final double largura;
  final double altura;
  final Animation<double> nuvem1;
  final Animation<double> nuvem2;
  final Widget? estrelas;
  final Widget? aviao;
  final Widget? passaro;
  final Widget? ciclista;
  final Widget? obstaculo;
  final Widget? hud;
  final Widget? overlay;

  const CenarioBase({
    super.key,
    required this.assetCeuDia,
    required this.assetCeuNoite,
    required this.cicloValue,
    required this.deslocamento,
    required this.largura,
    required this.altura,
    required this.nuvem1,
    required this.nuvem2,
    this.estrelas,
    this.aviao,
    this.passaro,
    this.ciclista,
    this.obstaculo,
    this.hud,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    final offset = deslocamento.value * 768;
    return Stack(
      children: [
        // Céu dia
        SizedBox(
          width: largura,
          height: altura,
          child: Image.asset(assetCeuDia, fit: BoxFit.cover),
        ),
        // Céu noite com fade animado
        Opacity(
          opacity: cicloValue,
          child: SizedBox(
            width: largura,
            height: altura,
            child: Image.asset(assetCeuNoite, fit: BoxFit.cover),
          ),
        ),
        if (cicloValue > 0.1 && estrelas != null) estrelas!,
        NuvemAnimada(
          top: 40,
          left: nuvem1.value,
          width: 120,
          height: 120,
        ),
        NuvemAnimada(
          top: 90,
          right: nuvem2.value,
          width: 110,
          height: 110,
        ),
        // Montanhas/fundo rolando
        Positioned(
          bottom: 0,
          left: -offset,
          child: Image.asset('assets/fundo.png', width: 768),
        ),
        Positioned(
          bottom: 0,
          left: -offset + 768,
          child: Image.asset('assets/fundo.png', width: 768),
        ),
        if (aviao != null) aviao!,
        if (passaro != null) passaro!,
        if (obstaculo != null) obstaculo!,
        if (ciclista != null) ciclista!,
        if (hud != null) hud!,
        if (overlay != null) overlay!,
      ],
    );
  }
}
