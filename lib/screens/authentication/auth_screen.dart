import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  PageController pageController = PageController();
  bool showSignin = true;

  void toggleScreen() {
    setState(() {
      showSignin = !showSignin;
      pageController.jumpToPage(showSignin ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            SigninScreen(toggleScreen: toggleScreen),
            SignupScreen(toggleScreen: toggleScreen),
          ],
        ),
    );
  }
}