import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_dependencies.dart';
import '../login/login_page.dart';

const Color neonPurple = Color(0xFFC77DFF);
const Color neonCyan = Color(0xFF00E5FF);
const Color neonViolet = Color(0xFF9B6DFF);

class SplashPage extends StatefulWidget {
  final AppDependencies dependencies;

  const SplashPage({
    super.key,
    required this.dependencies,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(
              dependencies: widget.dependencies,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.08 + (_controller.value * 0.04),
                child: Transform.translate(
                  offset: Offset(
                    (_controller.value - 0.5) * 20,
                    (_controller.value - 0.5) * 20,
                  ),
                  child: child,
                ),
              );
            },
            child: Image.asset(
              'assets/images/zyro_flux_login_background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 145,
                  height: 145,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: neonCyan.withValues(alpha: 0.7),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: neonViolet.withValues(alpha: 0.5),
                        blurRadius: 35,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: neonCyan.withValues(alpha: 0.25),
                        blurRadius: 50,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/zyro_flux_app_icon.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        neonViolet,
                        neonPurple,
                        neonCyan,
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'ZYRO & FLUX',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'PLAN TODAY  •  LIVE BRIGHTER',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 45),

                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      neonCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}