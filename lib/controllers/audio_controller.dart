import 'package:audioplayers/audioplayers.dart';

class AudioController {
  final AudioPlayer menuPlayer = AudioPlayer();
  final AudioPlayer efeitosPlayer = AudioPlayer();

  Future<void> tocarMusicaMenu() async {
    await menuPlayer.setReleaseMode(ReleaseMode.loop);
    await menuPlayer.play(AssetSource('sons/musica_menu.mp3'), volume: 0.6);
  }

  Future<void> pararMusicaMenu() async {
    await menuPlayer.stop();
  }

  Future<void> tocarPulo() async {
    await efeitosPlayer.play(AssetSource('sons/pulo.mp3'), volume: 0.9);
  }

  Future<void> tocarErro() async {
    await efeitosPlayer.play(AssetSource('sons/erro.mp3'), volume: 1.0);
  }

  void dispose() {
    menuPlayer.dispose();
    efeitosPlayer.dispose();
  }
}
