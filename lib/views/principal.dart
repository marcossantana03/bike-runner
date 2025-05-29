import 'package:flutter/material.dart';
import 'package:runbike/controllers/principal_controller.dart';
import 'package:runbike/views/widgets/cenario_base.dart';
import 'package:runbike/views/widgets/ciclista_animado.dart';
import 'package:runbike/views/widgets/overlay_principal.dart';
import '../controllers/audio_controller.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> with TickerProviderStateMixin {
  late PrincipalController controlador;
  late final AudioController audioController;
  bool _animacoesIniciadas = false;

  @override
  void initState() {
    super.initState();
    controlador = PrincipalController();
    controlador.iniciarAnimacoes(this);
    audioController = AudioController();
    audioController.tocarMusicaMenu();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_animacoesIniciadas) {
      controlador.atualizarLargura(context);
      controlador.animarElementos(
        mostrarPassaro: () => setState(() {
          controlador.mostrarPassaro = true;
          controlador.alturaPassaro = 60 + controlador.random.nextDouble() * 140;
        }),
        esconderPassaro: () => setState(() => controlador.mostrarPassaro = false),
        mostrarAviao: () => setState(() => controlador.mostrarAviao = true),
        esconderAviao: () => setState(() => controlador.mostrarAviao = false),
      );
      _animacoesIniciadas = true;
    }
  }

  @override
  void dispose() {
    audioController.dispose();
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: controlador.controladorFundo,
        builder: (context, _) {
          return CenarioBase(
            assetCeuDia: 'assets/ceu_dia.png',
            assetCeuNoite: 'assets/ceu_noite.png',
            cicloValue: 0.0,
            deslocamento: controlador.deslocamento,
            largura: largura,
            altura: altura,
            nuvem1: controlador.nuvem1,
            nuvem2: controlador.nuvem2,
            estrelas: null,
            aviao: null,
            passaro: null,
            obstaculo: null,
            ciclista: CiclistaAnimado(
              left: largura / 2 - 130,
              bottom: 140,
              width: 260,
            ),
            hud: null,
            overlay: OverlayPrincipal(),
          );
        },
      ),
    );
  }
}
