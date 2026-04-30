import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts tts = FlutterTts();

  bool _isInitialized = false;

  TTSService() {
    _init();
  }
  Future<void> _init() async {
    await tts.setSpeechRate(0.6);
    await tts.setPitch(1.0);
    await tts.awaitSpeakCompletion(true); 
    _isInitialized = true;
  }
  Future<void> speak(String text, String localeId) async {
    if (!_isInitialized) return;

    await stop(); 

    try {
      await tts.setLanguage(localeId);
      await tts.speak(text);
    } catch (e) {
      print("TTS error: $e");
    }
  }
  Future<void> stop() async {
    await tts.stop();
  }
}
