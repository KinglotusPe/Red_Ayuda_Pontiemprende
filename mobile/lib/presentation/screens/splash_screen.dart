import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final ApiService apiService;

  const SplashScreen({super.key, required this.apiService});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await widget.apiService.init();
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    if (widget.apiService.accessToken != null) {
      Navigator.of(context).pushReplacement(
        MaterialBar(builder: (_) => HomeScreen(apiService: widget.apiService)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialBar(builder: (_) => LoginScreen(apiService: widget.apiService)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emergencyRed.withOpacity(0.15),
                border: Border.all(color: AppColors.emergencyRed, width: 2),
              ),
              child: const Icon(
                Icons.health_and_safety_rounded,
                color: AppColors.emergencyRed,
                size: 55,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'RED AYUDA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '“Una población organizada, una ciudad más segura”',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: AppColors.emergencyRed,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaterialBar extends MaterialPageRoute {
  MaterialBar({required super.builder});
}
