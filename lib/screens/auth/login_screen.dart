import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../onboarding/language_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF9013FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black12)],
              ),
              child: Column(
                children: [
                  Text(
                    isLogin ? "Welcome Back" : "Create Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 20),
                  auth.isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              showError("Please fill all fields");
                              return;
                            }

                            if (isLogin) {
                              await auth.loginWithEmail(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                            } else {
                              await auth.register(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                            }

                            if (auth.isLoggedIn) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LanguageScreen(),
                                ),
                              );
                            } else if (auth.error != null) {
                              showError(auth.error!);
                            }
                          },
                          child: Text(isLogin ? "Login" : "Sign Up"),
                        ),
                      ),

                  SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Login",
                    ),
                  ),

                  Divider(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.login),
                      label: Text("Continue with Google"),
                      onPressed: () async {
                        await auth.loginWithGoogle();

                        if (auth.isLoggedIn) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LanguageScreen()),
                          );
                        } else if (auth.error != null) {
                          showError(auth.error!);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
