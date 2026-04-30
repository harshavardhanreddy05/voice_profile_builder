import 'package:flutter/material.dart';
import 'package:profile_builder/screens/auth/login_screen.dart';
import 'package:profile_builder/screens/onboarding/language_screen.dart';
import 'package:profile_builder/screens/onboarding/onboarding_screen.dart';
import 'package:profile_builder/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/auth_provider.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      home: Consumer2<AuthProvider, OnboardingProvider>(
        builder: (context, auth, onboarding, _) {
          if (auth.isLoading) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (auth.isLoggedIn) {
            if (auth.userModel == null) {
              return LoginScreen();
            }

            if (!onboarding.isLanguageSelected) {
              return LanguageScreen();
            }

            if (!auth.userModel!.isOnboardingCompleted) {
              return OnboardingScreen();
            }

            return ProfileScreen();
          }

          return LoginScreen();
        },
      ),
    );
  }
}
