import 'package:flutter/material.dart';

import '../../core/app_dependencies.dart';
import '../home/home_page.dart';

const Color neonPurple = Color(0xFFC77DFF);
const Color neonCyan = Color(0xFF00E5FF);
const Color neonViolet = Color(0xFF9B6DFF);

class LoginPage extends StatefulWidget {
  final AppDependencies dependencies;

  const LoginPage({
    super.key,
    required this.dependencies,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();

  late final AnimationController _backgroundController;

  bool isLoading = true;
  bool hasPassword = false;
  bool obscurePassword = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _checkPassword();
  }

  Future<void> _checkPassword() async {
    final result = await widget.dependencies.passwordStorage.hasPassword();

    if (!mounted) return;

    setState(() {
      hasPassword = result;
      isLoading = false;
    });
  }

  Future<void> _login() async {
    final password = _passwordController.text;

    if (password.isEmpty) {
      setState(() {
        errorMessage = 'Enter your password';
      });
      return;
    }

    final isValid = hasPassword
        ? await widget.dependencies.passwordStorage.verifyPassword(password)
        : true;

    if (!isValid) {
      setState(() {
        errorMessage = 'Incorrect password';
      });
      return;
    }

    if (!hasPassword) {
      await widget.dependencies.passwordStorage.savePassword(password);
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          dependencies: widget.dependencies,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: neonCyan,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated neon background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.08 + (_backgroundController.value * 0.04),
                child: Transform.translate(
                  offset: Offset(
                    (_backgroundController.value - 0.5) * 25,
                    (_backgroundController.value - 0.5) * 20,
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

          // Dark overlay so login card remains clear
          Container(
            color: Colors.black.withValues(alpha: 0.58),
          ),

          // Login content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF080A10).withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: neonViolet.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: neonViolet.withValues(alpha: 0.18),
                        blurRadius: 25,
                      ),
                      BoxShadow(
                        color: neonCyan.withValues(alpha: 0.06),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Logo
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: neonViolet.withValues(alpha: 0.35),
                              blurRadius: 25,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(
                            'assets/images/zyro_flux_app_icon.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

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
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        hasPassword
                            ? 'ENTER PASSWORD'
                            : 'CREATE PASSWORD',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      TextField(
                        controller: _passwordController,
                        obscureText: obscurePassword,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                            color: Colors.white38,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: neonCyan,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white54,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF101116),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: neonViolet.withValues(alpha: 0.35),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: neonCyan,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _login(),
                      ),

                      if (errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFFF4F87),
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [
                                neonViolet,
                                neonPurple,
                                neonCyan,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: neonPurple.withValues(alpha: 0.25),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              hasPassword ? 'LOGIN' : 'SET PASSWORD',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}