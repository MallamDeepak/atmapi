import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';
import '../config/routes_config.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left side - Brand (desktop only)
          if (isDesktop) _buildBrandSection(),
          
          // Right side - Login form
          Expanded(
            flex: isDesktop ? 1 : 2,
            child: _buildLoginForm(context, size.height),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandSection() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(gradient: ThemeConfig.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/union_bank_logo.png',
                height: 120,
                color: Colors.white,
                errorBuilder: (c, e, s) => const Icon(
                  Icons.account_balance,
                  size: 120,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Union Bank',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Banking Simplified',
                style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, double viewportHeight) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: viewportHeight),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to your secure banking account',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Login options
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      if (authProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Column(
                        children: [
                          // Face authentication button
                          _buildLoginButton(
                            context,
                            icon: Icons.face,
                            label: 'Face ID Login',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                RoutesConfig.faceAuth,
                              );
                            },
                            isPrimary: true,
                          ),
                          const SizedBox(height: 16),

                          // Biometric authentication button
                          _buildLoginButton(
                            context,
                            icon: Icons.fingerprint,
                            label: 'Biometric Login',
                            onPressed: () async {
                              final success =
                                  await authProvider.loginWithBiometrics();
                              if (success && context.mounted) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  RoutesConfig.dashboard,
                                );
                              }
                            },
                            isPrimary: false,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Error message
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      if (authProvider.errorMessage != null) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            authProvider.errorMessage!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  Center(
                    child: Text(
                      'Secure Banking at Your Fingertips',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
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

  Widget _buildLoginButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? ThemeConfig.primary : Colors.grey[100],
          foregroundColor: isPrimary ? Colors.white : ThemeConfig.primary,
          elevation: isPrimary ? 4 : 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
