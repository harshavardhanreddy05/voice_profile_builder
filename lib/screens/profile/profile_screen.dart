
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../onboarding/onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context);
    var user = auth.userModel;
    var p = Provider.of<OnboardingProvider>(context);

    return Scaffold(
   
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text("Profile"),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language),
            onSelected: (value) {
              final p = Provider.of<OnboardingProvider>(context, listen: false);

              p.selectLanguage(value); 
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: "en", child: Text("English")),
                  PopupMenuItem(value: "hi", child: Text("हिंदी")),
                ],
          ),

          auth.isLoading
              ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await auth.logout();
                },
              ),
        ],
      ),

      body:
          auth.isLoading || user == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : "U",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),

                    SizedBox(height: 10),

                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: 8),

                        GestureDetector(
                          onTap: () {
                            final p = Provider.of<OnboardingProvider>(
                              context,
                              listen: false,
                            );

                            p.loadExistingData(user);
                            p.setStep(0); 

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OnboardingScreen(isEdit: true),
                              ),
                            );
                          },
                          child: Icon(Icons.edit, size: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Expanded(
                      child: ListView(
                        children: [
                          buildCard(
                            context,
                            p.lang == "hi" ? "कौशल" : "Skills",
                            user.skills.join(", "),
                            user,
                            1,
                            appendMode: true,
                          ),
                          buildCard(
                            context,
                            p.lang == "hi" ? "अनुभव" : "Experience",
                            user.experience,
                            user,
                            2,
                            appendMode: true,
                          ),
                          buildCard(
                            context,
                            p.lang == "hi" ? "शिक्षा" : "Education",
                            user.education,
                            user,
                            3,
                            appendMode: true,
                          ),
                          buildCard(
                            context,
                            p.lang == "hi" ? "रुचियाँ" : "Interests",
                            user.interests,
                            user,
                            4,
                            appendMode: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<OnboardingProvider>(
                          context,
                          listen: false,
                        ).loadExistingData(user);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OnboardingScreen(isEdit: true),
                          ),
                        );
                      },
                      child: Text("Edit Full Profile"),
                    ),
                  ],
                ),
              ),
    );
  }
  Widget buildCard(
    BuildContext context,
    String title,
    String value,
    dynamic user,
    int stepIndex, {
    bool appendMode = false,
  }) {
    final p = Provider.of<OnboardingProvider>(context, listen: false);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    p.loadExistingData(user);
                    p.setStep(stepIndex);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OnboardingScreen(isEdit: true),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 6),

            Text(value.isEmpty ? "-" : value),

            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  p.loadExistingData(user);
                  p.setStep(stepIndex);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => OnboardingScreen(
                            isEdit: true,
                            appendMode: appendMode,
                          ),
                    ),
                  );
                },
                child: Text("+ Add More"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
