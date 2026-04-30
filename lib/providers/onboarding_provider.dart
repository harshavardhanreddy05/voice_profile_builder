import 'package:flutter/material.dart';
import '../models/user_model.dart';

class OnboardingProvider extends ChangeNotifier {
  int _step = 0;
  String lang = "en";

  bool isLanguageSelected = false;

  Map<String, dynamic> data = {};

  List questions = [
    {"key": "name", "en": "Your name?", "hi": "आपका नाम क्या है?"},
    {"key": "skills", "en": "Your skills?", "hi": "आपके कौशल क्या हैं?"},
    {"key": "experience", "en": "Experience?", "hi": "अनुभव?"},
    {"key": "education", "en": "Education?", "hi": "शिक्षा?"},
    {"key": "interests", "en": "Interests?", "hi": "रुचियाँ?"},
  ];

  int get step => _step;

  String get question =>
      lang == "hi" ? questions[_step]["hi"] : questions[_step]["en"];

  void selectLanguage(String l) {
    lang = l;
    isLanguageSelected = true;
    notifyListeners();
  }

  void save(String val, {bool isAppend = false}) {
    final key = questions[_step]["key"];

    if (key == "skills") {
      List<String> newValues =
          val
              .split(",")
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      if (isAppend) {
        List<String> existing = (data[key] ?? []).cast<String>();
        data[key] =
            [
              ...existing,
              ...newValues,
            ].map((e) => e.toString()).toSet().toList();
      } else {
        data[key] = newValues;
      }
    } else if (["experience", "education", "interests"].contains(key)) {
      if (isAppend) {
        final existing = (data[key] ?? "").toString().trim();
        final value = val.trim();
        if (existing.isEmpty) {
          data[key] = value;
        } else {
          data[key] = "$existing, $value";
        }
      } else {
        data[key] = val.trim();
      }
    } else {
      data[key] = val.trim();
    }
  }

  void next() {
    if (_step < questions.length - 1) {
      _step++;
      notifyListeners();
    }
  }

  void previous() {
    if (_step > 0) {
      _step--;
      notifyListeners();
    }
  }

  void setStep(int index) {
    if (index >= 0 && index < questions.length) {
      _step = index;
      notifyListeners();
    }
  }

  void reset() {
    _step = 0;
    data.clear();
    notifyListeners();
  }

  void loadExistingData(UserModel user) {
    data = {
      "name": user.name,
      "skills": user.skills,
      "experience": user.experience,
      "education": user.education,
      "interests": user.interests,
    };

    _step = 0;
    notifyListeners();
  }

  String getCurrentAnswer() {
    var key = questions[_step]["key"];
    var value = data[key];

    if (value == null) return "";

    if (key == "skills" && value is List) {
      return value.join(", ");
    }

    return value.toString();
  }
}
