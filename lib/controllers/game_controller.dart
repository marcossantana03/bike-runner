import 'dart:math';

class GameController {
  bool pulando = false;
  bool jogando = false;
  bool mostrarPassaro = false;
  bool mostrarAviao = false;
  double alturaPassaro = 100.0;
  double posicaoHorizontalCiclista = 0.0;
  int obstaculos = 0;
  int pontuacao = 0;
  double velocidade = 12.0;
  bool obstaculoVisivel = false;
  bool colisaoDetectada = false;
  bool gameOver = false;
  String obstaculoAtual = 'assets/buraco.png';

  final random = Random();

  final List<String> tiposObstaculos = [
    'assets/buraco.png',
    'assets/pedra.png',
    'assets/planta.png'
  ];

  void iniciarJogo() {
    obstaculos = 0;
    pontuacao = 0;
    velocidade = 12.0;
    gameOver = false;
    jogando = true;
    obstaculoVisivel = true;
    colisaoDetectada = false;
    pulando = false;
    posicaoHorizontalCiclista = 0.0;
    obstaculoAtual = tiposObstaculos[random.nextInt(tiposObstaculos.length)];
    mostrarPassaro = false;
    mostrarAviao = false;
    alturaPassaro = 100.0;
  }

  void novoObstaculo() {
    obstaculoAtual = tiposObstaculos[random.nextInt(tiposObstaculos.length)];
    obstaculoVisivel = true;
  }

  void aumentarVelocidade() {
    if (velocidade < 40.0) {
      velocidade += 1.0;
    }
  }

  void obstaculoUltrapassado() {
    obstaculos++;
    aumentarVelocidade();
    novoObstaculo();
  }

  void resetPuloHorizontal() {
    pulando = false;
    posicaoHorizontalCiclista = 0.0;
  }

  void setGameOver() {
    gameOver = true;
    jogando = false;
  }
}
