import 'package:audioplayers/audioplayers.dart';

class BGMPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playBGM(String path) async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
    await _audioPlayer.play(AssetSource(path)); // Play audio from assets
  }

  Future<void> stopBGM() async {
    await _audioPlayer.stop();
  }

  Future<void> pauseBGM() async {
    await _audioPlayer.pause();
  }

  Future<void> resumeBGM() async {
    await _audioPlayer.resume();
  }
}

// Global instance of BGMPlayer
final bgmPlayer = BGMPlayer();
