import 'package:flutter/material.dart';

class BotaoMenu extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotaoMenu({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
