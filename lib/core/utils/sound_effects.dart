import 'package:audioplayers/audioplayers.dart';

class SoundEffects {
  SoundEffects._();

  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _loopPlayer = AudioPlayer();
  static String? _currentLoop;

  static Future<void> init() async {
    try {
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _loopPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (_) {}
  }

  static Future<void> playMovex() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.play(AssetSource('sounds/movex.mp3'));
    } catch (_) {}
  }

  static Future<void> playMoveo() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.play(AssetSource('sounds/moveo.mp3'));
    } catch (_) {}
  }

  static Future<void> playStart({bool loop = false}) async {
    try {
      _currentLoop = 'start';
      await _loopPlayer.stop();
      await _loopPlayer.setReleaseMode(
        loop ? ReleaseMode.loop : ReleaseMode.stop,
      );
      await _loopPlayer.play(AssetSource('sounds/start.mp3'));
    } catch (_) {}
  }

  static Future<void> playWinLoop() async {
    try {
      _currentLoop = 'win';
      await _loopPlayer.stop();
      await _loopPlayer.setReleaseMode(ReleaseMode.loop);
      await _loopPlayer.play(AssetSource('sounds/win.mp3'));
    } catch (_) {}
  }

  static Future<void> playDrawLoop() async {
    try {
      _currentLoop = 'draw';
      await _loopPlayer.stop();
      await _loopPlayer.setReleaseMode(ReleaseMode.loop);
      await _loopPlayer.play(AssetSource('sounds/draw.mp3'));
    } catch (_) {}
  }

  static Future<void> stopLoop() async {
    try {
      _currentLoop = null;
      await _loopPlayer.stop();
    } catch (_) {}
  }

  static Future<void> pauseAll() async {
    try {
      await _sfxPlayer.pause();
      await _loopPlayer.pause();
    } catch (_) {}
  }

  static Future<void> resumeLoop() async {
    try {
      // Resume current loop if any
      if (_currentLoop != null) {
        await _loopPlayer.resume();
      }
    } catch (_) {}
  }
}
