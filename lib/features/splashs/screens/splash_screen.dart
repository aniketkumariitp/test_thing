import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/features/splashs/provider/splash_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SplashProvider>(
        context,
        listen: false,
      ).handleSplashLogic(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff161617),
      body: Center(
        child: Image(
          width: 300,
          height: 300,
          image: AssetImage("assets/animations/1.png"),
        ),
      ),
    );
  }
}
