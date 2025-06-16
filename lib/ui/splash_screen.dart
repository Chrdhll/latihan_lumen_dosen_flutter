import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:latihan_lumen_dosen_flutter/ui/list_data_dosen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 100, color: Colors.orange.shade900),
          const SizedBox(height: 20),
          const Text(
            "Data Dosen",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      duration: 2000,
      splashIconSize: 250,
      backgroundColor: Colors.white,
      nextScreen: const ListDataDosen(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}

