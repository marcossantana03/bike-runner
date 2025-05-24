import 'package:flutter/material.dart';

class HUDJogo extends StatelessWidget {
  final int obstaculos;
  final int pontuacao;
  final double velocidade;

  const HUDJogo({
    super.key,
    required this.obstaculos,
    required this.pontuacao,
    required this.velocidade,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 52,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildObstaculos(),
          _buildPontuacao(),
          _buildVelocidade(),
        ],
      ),
    );
  }

  Widget _buildObstaculos() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_bike, color: Colors.yellow, size: 26),
          const SizedBox(width: 6),
          Text(
            '$obstaculos',
            style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPontuacao() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.score, color: Colors.orange, size: 26),
          const SizedBox(width: 6),
          Text(
            '$pontuacao',
            style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildVelocidade() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.speed, color: Colors.cyanAccent, size: 26),
          const SizedBox(width: 6),
          Text(
            '${velocidade.toStringAsFixed(1)} km/h',
            style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
