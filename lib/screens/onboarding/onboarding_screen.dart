import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/speech_service.dart';
import '../../services/tts_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/mic_button.dart';
import '../profile/profile_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isEdit;
  final bool appendMode;

  const OnboardingScreen({
    Key? key,
    this.isEdit = false,
    this.appendMode = false,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = TextEditingController();
  final speech = SpeechService();
  final tts = TTSService();

  bool listening = false;
  bool saving = false;
  String micStatus = "Tap to speak";

  @override
  void initState() {
    super.initState();
    speech.init();
    requestMicPermission();
    _checkSpeechSupport();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final p = Provider.of<OnboardingProvider>(context, listen: false);
      final auth = Provider.of<AuthProvider>(context, listen: false);
      controller.text = widget.appendMode ? "" : p.getCurrentAnswer();

      if (auth.userModel?.name != null &&
          auth.userModel!.name.isNotEmpty &&
          !widget.isEdit) {
        await tts.speak(
          "Hi ${auth.userModel!.name}, let's complete your profile",
          p.lang == "hi" ? "hi_IN" : "en_IN",
        );
      }
      _speakQuestion();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        _speakQuestion();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    speech.stop();
    super.dispose();
  }

  Future<void> _speakQuestion() async {
    final p = Provider.of<OnboardingProvider>(context, listen: false);

    await tts.stop();

    await tts.speak(p.question, p.lang == "hi" ? "hi_IN" : "en_IN");
  }

  void _checkSpeechSupport() {
    final p = Provider.of<OnboardingProvider>(context, listen: false);
    if (p.lang == "hi") {
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          String warningMessage =
              p.lang == "hi"
                  ? "⚠️ अगर हिंदी स्पीच रिकग्निशन समर्थित नहीं है, तो कृपया अंग्रेजी में बोलें"
                  : "⚠️ If Hindi speech recognition is not supported, please speak in English";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(warningMessage),
              duration: Duration(seconds: 5),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Profile" : "Onboarding"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(value: (p.step + 1) / p.questions.length),

            SizedBox(height: 30),

            Text(
              p.question,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),

            SizedBox(height: 20),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type or use mic...",
              ),
            ),

            SizedBox(height: 20),
            Column(
              children: [
                MicButton(
                  listening: listening,
                  onTap: () async {
                    if (!listening) {
                      setState(() {
                        listening = true;
                        micStatus = "Listening...";
                      });

                      speech.listen((text) {
                        if (text.isEmpty) {
                          String errorMessage =
                              p.lang == "hi"
                                  ? "आपकी आवाज़ साफ़ नहीं सुनी गई या हिंदी स्पीच रिकग्निशन समर्थित नहीं है"
                                  : "Couldn't hear clearly or Hindi speech recognition not supported on this device";
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(errorMessage)));
                        } else {
                          controller.text = text;
                        }
                      }, p.lang == "hi" ? "hi_IN" : "en_IN");
                    } else {
                      speech.stop();
                      setState(() {
                        listening = false;
                        micStatus = "Stopped";
                      });
                    }
                  },
                ),

                SizedBox(height: 10),

                Text(
                  micStatus,
                  style: TextStyle(
                    color: listening ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Spacer(),

            saving
                ? CircularProgressIndicator()
                : CustomButton(
                  text:
                      p.step == p.questions.length - 1
                          ? (widget.isEdit ? "Update" : "Finish")
                          : "Next",
                  onTap: () async {
                    if (controller.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter a value")),
                      );
                      return;
                    }

                    p.save(controller.text.trim(), isAppend: widget.appendMode);

                    if (widget.isEdit) {
                      await Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).updateUserData(p.data);

                      Navigator.pop(context);
                    } else {
                      if (p.step == p.questions.length - 1) {
                        p.data["isOnboardingCompleted"] = true;
                        await Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).updateUserData(p.data);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => ProfileScreen()),
                        );
                      } else {
                        p.next();
                        controller.text = p.getCurrentAnswer();
                        _speakQuestion();
                      }
                    }
                  },
                ),
          ],
        ),
      ),
    );
  }

  Future<void> requestMicPermission() async {
    var status = await Permission.microphone.request();

    if (status.isDenied) {
      debugPrint("Mic permission denied");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
