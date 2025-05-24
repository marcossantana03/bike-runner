import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverDialog extends StatelessWidget {
  final int obstaculos;
  final int pontuacao;
  final VoidCallback onReiniciar;

  const GameOverDialog({
    super.key,
    required this.obstaculos,
    required this.pontuacao,
    required this.onReiniciar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.yellow, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 16,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GAME OVER',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 54,
                      color: Colors.yellow,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Você pulou\n$obstaculos obstáculos!\n\nPontuação: ${(pontuacao / 10).toInt()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black, blurRadius: 4)
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: onReiniciar,
                      child: const Text('Tentar novamente'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
