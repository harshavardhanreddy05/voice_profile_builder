import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_provider.dart';
import 'onboarding_screen.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var p = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.language, size: 70, color: Colors.blue),

              SizedBox(height: 20),

              Text(
                "Choose your language",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                "Select a language to continue",
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  p.selectLanguage("en"); 

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => OnboardingScreen()),
                  );
                },
                child: Text("English"),
              ),

              SizedBox(height: 15),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  p.selectLanguage("hi"); 

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => OnboardingScreen()),
                  );
                },
                child: Text("हिंदी"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
