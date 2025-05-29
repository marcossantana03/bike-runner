import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:runbike/controllers/game_controller.dart';
import 'package:runbike/views/widgets/aviao_animado.dart';
import 'package:runbike/views/widgets/cenario_base.dart';
import 'package:runbike/views/widgets/ciclista_animado.dart';
import 'package:runbike/views/widgets/game_over_dialog.dart';
import 'package:runbike/views/widgets/hud_jogo.dart';
import 'package:runbike/views/widgets/obstaculo_animado.dart';
import 'package:runbike/views/widgets/passaro_animado.dart';
import 'package:vibration/vibration.dart';
import '../controllers/audio_controller.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  final AudioController audioController = AudioController();
  late AnimationController fundoController;
  late AnimationController nuvensController;
  late AnimationController cicloController;
  late AnimationController obstaculoController;
  late Animation<double> obstaculoAnimacao;
  late AnimationController puloController;
  late Animation<double> puloAnimacao;
  late AnimationController retornoController;
  late Animation<double> retornoAnimacao;
  bool _animacoesAtivas = true;
  late AnimationController movimentoHorizontalController;
  late Animation<double> movimentoHorizontalAnimacao;

  late Animation<double> deslocamento;
  late Animation<double> nuvem1;
  late Animation<double> nuvem2;

  late AnimationController passaroController;
  late AnimationController aviaoController;
  late Animation<double> passaroAnimacao;
  late Animation<double> aviaoAnimacao;

  late Timer pontuacaoTimer;

  final gameController = GameController();

  @override
  void initState() {
    super.initState();

    puloController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    puloAnimacao =
        CurvedAnimation(parent: puloController, curve: Curves.decelerate);

    movimentoHorizontalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    movimentoHorizontalAnimacao = Tween<double>(begin: 0, end: 90).animate(
      CurvedAnimation(
          parent: movimentoHorizontalController, curve: Curves.easeOutQuad),
    );

    puloController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.microtask(() {
          if (mounted) {
            setState(() {
              gameController.pulando = false;
            });
            puloController.reset();
            movimentoHorizontalController.reset();

            if (gameController.posicaoHorizontalCiclista.abs() > 2) {
              retornoController.forward(from: 0);
            } else {
              gameController.posicaoHorizontalCiclista = 0.0;
            }
          }
        });
      }
    });

    obstaculoController = AnimationController(
      vsync: this,
      duration: _durationPorVelocidade(gameController.velocidade),
    );
    obstaculoAnimacao =
        Tween<double>(begin: 0, end: 1).animate(obstaculoController);

    obstaculoAnimacao.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.microtask(() {
          if (mounted && gameController.jogando && !gameController.gameOver) {
            _onObstaculoUltrapassadoSeguro();
          }
        });
      }
    });

    cicloController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    fundoController = AnimationController(
      vsync: this,
      duration: _durationPorVelocidade(gameController.velocidade),
    );

    nuvensController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 32),
    )..repeat();

    nuvem1 = Tween<double>(begin: -30, end: 100).animate(
      CurvedAnimation(parent: nuvensController, curve: Curves.linear),
    );
    nuvem2 = Tween<double>(begin: 30, end: -60).animate(
      CurvedAnimation(parent: nuvensController, curve: Curves.linear),
    );

    deslocamento = Tween<double>(begin: 0, end: 1).animate(fundoController);

    passaroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    aviaoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _iniciarJogo();
      }
    });

    pontuacaoTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && gameController.jogando && !gameController.gameOver) {
        setState(() {
          gameController.pontuacao++;
        });
      }
    });

    retornoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    retornoAnimacao = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: retornoController,
      curve: Curves.easeOut,
    ));
    retornoController.addListener(() {
      setState(() {
        gameController.posicaoHorizontalCiclista = lerpDouble(
            gameController.posicaoHorizontalCiclista, 0.0, retornoAnimacao.value)!
            .clamp(-100.0, 100.0);
      });
    });
    retornoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        gameController.posicaoHorizontalCiclista = 0.0;
        retornoController.reset();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final largura = MediaQuery.of(context).size.width;

    passaroAnimacao = Tween<double>(begin: -200, end: largura + 200)
        .animate(passaroController);
    aviaoAnimacao =
        Tween<double>(begin: -300, end: largura + 300).animate(aviaoController);

    _iniciarAnimacoes(largura);
  }

  Duration _durationPorVelocidade(double velocidadeAtual) {
    const double velocidadeBase = 12.0;
    const int durationBaseMs = 3000;
    double fator = velocidadeAtual / velocidadeBase;
    int durationMs = (durationBaseMs / fator).toInt();
    return Duration(milliseconds: durationMs.clamp(800, 3000));
  }

  void _gerarNovoObstaculoSeguro() {
    setState(() {
      gameController.novoObstaculo();
      obstaculoController.duration = _durationPorVelocidade(gameController.velocidade);
      obstaculoController.reset();
      obstaculoController.forward();
    });
  }

  void _onObstaculoUltrapassadoSeguro() {
    setState(() {
      gameController.obstaculoUltrapassado();
      fundoController.duration = _durationPorVelocidade(gameController.velocidade);
      fundoController.stop();
      fundoController.repeat();
      _gerarNovoObstaculoSeguro();
    });
  }

  void _iniciarJogo() {
    setState(() {
      gameController.iniciarJogo();
    });

    puloController.reset();
    movimentoHorizontalController.reset();

    fundoController.duration = _durationPorVelocidade(gameController.velocidade);
    fundoController.repeat();

    obstaculoController.duration = _durationPorVelocidade(gameController.velocidade);
    obstaculoController.reset();
    obstaculoController.forward();
  }

  void reiniciarJogo() {
    _pausarAnimacoes();
    setState(() {
      gameController.resetPuloHorizontal();
    });
    puloController.reset();
    movimentoHorizontalController.reset();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _iniciarJogo();
      }
    });
  }

  void _pausarAnimacoes() {
    fundoController.stop();
    obstaculoController.stop();
    puloController.reset();
    movimentoHorizontalController.reset();
  }

  double get _rotacaoCiclista {
    final t = puloAnimacao.value;
    if (t < 0.2) {
      return lerpDouble(0, -0.28, t / 0.2)!;
    } else if (t < 0.7) {
      return lerpDouble(-0.28, 0.18, (t - 0.2) / 0.5)!;
    } else if (t < 1.0) {
      return lerpDouble(0.18, 0, (t - 0.7) / 0.3)!;
    } else {
      return 0.0;
    }
  }

  Future<void> _iniciarAnimacoes(double largura) async {
    while (_animacoesAtivas && mounted) {
      await Future.delayed(const Duration(seconds: 5));
      if (!_animacoesAtivas || !mounted) break;

      if (!gameController.gameOver && gameController.jogando) {
        setState(() {
          gameController.mostrarPassaro = true;
          gameController.alturaPassaro = 60 + gameController.random.nextDouble() * 140;
        });
        await passaroController.forward(from: 0);
        if (_animacoesAtivas && mounted) {
          setState(() => gameController.mostrarPassaro = false);
        }
      }

      await Future.delayed(const Duration(seconds: 3));
      if (!_animacoesAtivas || !mounted) break;

      if (!gameController.gameOver && gameController.jogando) {
        setState(() => gameController.mostrarAviao = true);
        await aviaoController.forward(from: 0);
        if (_animacoesAtivas && mounted) {
          setState(() => gameController.mostrarAviao = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _animacoesAtivas = false;
    audioController.dispose();
    fundoController.dispose();
    nuvensController.dispose();
    cicloController.dispose();
    passaroController.dispose();
    aviaoController.dispose();
    obstaculoController.dispose();
    puloController.dispose();
    movimentoHorizontalController.dispose();
    pontuacaoTimer.cancel();
    retornoController.dispose();
    super.dispose();
  }

  void _pularCiclista() {
    if (!mounted) return;

    if (gameController.gameOver) {
      reiniciarJogo();
      return;
    }

    if (!gameController.jogando) {
      _iniciarJogo();
      return;
    }

    if (gameController.pulando) return;

    setState(() => gameController.pulando = true);
    audioController.tocarPulo();
    puloController.forward(from: 0);
    movimentoHorizontalController.forward(from: 0);
  }

  void _verificarColisao(double posXCiclista, double posYCiclista,
      double posXObstaculo, double posYObstaculo) {
    if (!mounted ||
        gameController.gameOver ||
        !gameController.jogando ||
        !gameController.obstaculoVisivel ||
        gameController.colisaoDetectada) {
      return;
    }

    const double larguraCiclista = 260;
    const double alturaCiclista = 120;
    const double larguraObstaculo = 150;
    bool noChao = !gameController.pulando || puloAnimacao.value < 0.1;

    final bool colidiu =
        posXCiclista + larguraCiclista * 0.6 > posXObstaculo + 20 &&
            posXCiclista + larguraCiclista * 0.4 <
                posXObstaculo + larguraObstaculo - 20 &&
            posYCiclista + alturaCiclista * 0.7 > posYObstaculo &&
            noChao;

    if (colidiu) {
      setState(() {
        gameController.colisaoDetectada = true;
        gameController.setGameOver();
      });
      audioController.tocarErro();
      Vibration.hasVibrator().then((hasVibrator) {
        if (hasVibrator) {
          Vibration.vibrate(duration: 300);
        }
      });
      Future.microtask(() => _finalizarJogo());
    }
  }

  void _finalizarJogo() {
    if (!mounted) return;
    setState(() {
      gameController.setGameOver();
    });
    _pausarAnimacoes();
    mostrarGameOver(context);
  }

  Widget _buildEstrelasExtras(
      double cicloValue, double largura, double altura) {
    final random = Random(123);
    return IgnorePointer(
      child: Opacity(
        opacity: cicloValue,
        child: Stack(
          children: List.generate(85, (i) {
            final left = random.nextDouble() * largura;
            final top = random.nextDouble() * altura * 0.62;
            final size = 1.3 + random.nextDouble() * 2.7;
            final cor = i % 7 == 0
                ? Colors.yellowAccent.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: random.nextDouble() * 0.5 + 0.5);
            return Positioned(
              left: left,
              top: top,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: cor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (size > 2)
                      BoxShadow(
                        color: cor,
                        blurRadius: 3,
                        spreadRadius: 0.5,
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          fundoController,
          nuvensController,
          cicloController,
          puloController,
          obstaculoController,
          movimentoHorizontalController,
        ]),
        builder: (context, _) {
          final cicloValue = cicloController.value;
          const double larguraCiclista = 260;
          if (gameController.pulando) {
            gameController.posicaoHorizontalCiclista = movimentoHorizontalAnimacao.value;
          }
          final double posXCiclista =
              (largura / 2 - larguraCiclista / 2) + gameController.posicaoHorizontalCiclista;

          const double alturaCiclista = 120;
          const double alturaChao = 140;
          const double alturaMaxPulo = 180;

          double alturaPulo =
              alturaChao + sin(pi * puloAnimacao.value) * alturaMaxPulo;
          final double posYCiclista = alturaPulo.clamp(
              0, MediaQuery.of(context).size.height - alturaCiclista - 20);

          const double larguraObstaculo = 150;
          final double posXObstaculo = largura -
              (obstaculoAnimacao.value * (largura + larguraObstaculo));
          const double posYObstaculo = 145.0;
          Future.microtask(() => _verificarColisao(
              posXCiclista, posYCiclista, posXObstaculo, posYObstaculo));

          return GestureDetector(
              onTap: () {
                _pularCiclista();
              },
              child: CenarioBase(
                assetCeuDia: 'assets/ceu_dia.png',
                assetCeuNoite: 'assets/ceu_noite.png',
                cicloValue: cicloValue,
                deslocamento: deslocamento,
                largura: largura,
                altura: altura,
                nuvem1: nuvem1,
                nuvem2: nuvem2,
                estrelas: cicloValue > 0.1
                    ? _buildEstrelasExtras(cicloValue, largura, altura)
                    : null,
                aviao: gameController.mostrarAviao
                    ? AviaoAnimado(
                    animacao: aviaoAnimacao, mostrar: gameController.mostrarAviao)
                    : null,
                passaro: gameController.mostrarPassaro
                    ? PassaroAnimado(
                    animacao: passaroAnimacao,
                    mostrar: gameController.mostrarPassaro,
                    top: gameController.alturaPassaro)
                    : null,
                obstaculo: gameController.obstaculoVisivel
                    ? ObstaculoAnimado(
                  animacao: obstaculoAnimacao,
                  bottom: 145,
                  largura: largura,
                  asset: gameController.obstaculoAtual,
                  larguraObstaculo: 150,
                  alturaObstaculo: 90,
                )
                    : null,
                ciclista: CiclistaAnimado(
                  left: posXCiclista,
                  bottom: posYCiclista,
                  width: 260,
                  rotation: _rotacaoCiclista,
                ),
                hud: HUDJogo(
                  obstaculos: gameController.obstaculos,
                  pontuacao: gameController.pontuacao,
                  velocidade: gameController.velocidade,
                ),
                overlay: null,
              ));
        },
      ),
    );
  }

  void mostrarGameOver(BuildContext context) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) {
        return GameOverDialog(
          obstaculos: gameController.obstaculos,
          pontuacao: gameController.pontuacao,
          onReiniciar: () {
            Navigator.of(context).pop();
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                reiniciarJogo();
              }
            });
          },
        );
      },
    );
  }
}
