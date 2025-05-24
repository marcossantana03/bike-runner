import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runbike/views/widgets/dialog_customizado.dart';
import 'package:url_launcher/url_launcher.dart';
import 'botao_menu.dart';

class OverlayPrincipal extends StatelessWidget {
  const OverlayPrincipal({super.key});

  void mostrarCreditos(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return DialogCustomizado(
          titulo: 'CRÉDITOS',
          mensagem: 'Desenvolvido por Marcos Santana da Silva \n2025 ©',
          acoes: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset('assets/instagram.png', height: 32),
                  tooltip: 'Instagram',
                  onPressed: () => launchUrl(
                      Uri.parse('https://www.instagram.com/marcosant.dev/')),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Image.asset('assets/linkedin.png', height: 32),
                  tooltip: 'LinkedIn',
                  onPressed: () => launchUrl(Uri.parse(
                      'https://www.linkedin.com/in/marcos-santana-459824192/')),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ),
          ],
        );
      },
    );
  }

  void mostrarComoJogar(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return DialogCustomizado(
          titulo: 'COMO JOGAR',
          mensagemWidget: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Toque na tela para pular os obstáculos!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text(
                'Pule no tempo certo para não cair!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text(
                'Ganhe pontos e tente superar seu recorde.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          acoes: [
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
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendi!'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'BIKE\nRUNNER',
              textAlign: TextAlign.center,
              style: GoogleFonts.luckiestGuy(
                fontSize: 68,
                color: Colors.yellow,
                shadows: [
                  Shadow(
                      color: Colors.black, blurRadius: 4, offset: Offset(2, 2))
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BotaoMenu(texto: 'JOGAR', onPressed: () => context.go('/game')),
              const SizedBox(height: 16),
              BotaoMenu(
                  texto: 'COMO JOGAR',
                  onPressed: () => mostrarComoJogar(context)),
              const SizedBox(height: 16),
              BotaoMenu(
                  texto: 'CRÉDITOS', onPressed: () => mostrarCreditos(context)),
            ],
          ),
        ),
      ],
    );
  }
}
