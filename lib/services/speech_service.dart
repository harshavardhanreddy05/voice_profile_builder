
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText speech = SpeechToText();

  bool _isInitialized = false;

  Future<void> init() async {
    _isInitialized = await speech.initialize(
      onError: (error) {
        print("Speech error: $error");
      },
      onStatus: (status) {
        print("Speech status: $status");
      },
    );
  }
  Future<void> listen(Function(String) onResult, String localeId) async {
    if (!_isInitialized) {
      print("Speech not initialized");
      onResult(""); 
      return;
    }
    if (!speech.isAvailable) {
      print("Speech recognition not available on this device");
      onResult("");
      return;
    }

    final availableLocales = await speech.locales();
    if (!availableLocales.any((locale) => locale.localeId == localeId)) {
      print("Speech recognition not available for locale: $localeId");
      print(
        "Available locales: ${availableLocales.map((l) => l.localeId).join(', ')}",
      );
      onResult(""); 
      return;
    }

    final success = await speech.listen(
      onResult: (res) {
        if (res.recognizedWords.isNotEmpty) {
          print("Recognized: ${res.recognizedWords} (locale: $localeId)");
          onResult(res.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 5),
      partialResults: true, 
      localeId: localeId,
      onSoundLevelChange: (level) {
        print("Sound level: $level");
      },
    );

    if (!success) {
      print("Failed to start listening for locale: $localeId");
      onResult(""); 
    }
  }
  void stop() {
    if (speech.isListening) {
      speech.stop();
    }
  }
  bool get isListening => speech.isListening;
}
