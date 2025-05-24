import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogCustomizado extends StatelessWidget {
  final String titulo;
  final String? mensagem;
  final Widget? mensagemWidget;
  final List<Widget> acoes;

  const DialogCustomizado({
    Key? key,
    required this.titulo,
    this.mensagem,
    this.mensagemWidget,
    required this.acoes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
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
                titulo,
                textAlign: TextAlign.center,
                style: GoogleFonts.luckiestGuy(
                  fontSize: 44,
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
              const SizedBox(height: 20),
              if (mensagemWidget != null)
                mensagemWidget!
              else if (mensagem != null)
                Text(
                  mensagem!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 30),
              ...acoes,
            ],
          ),
        ),
      ),
    );
  }
}
