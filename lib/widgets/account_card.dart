import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/biometric_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme_config.dart';
import '../providers/auth_provider.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({super.key});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool _isBalanceVisible = false;
  final BiometricService _biometricService = BiometricService();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;
        
        if (user == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: ThemeConfig.primaryGradient,
            borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
            boxShadow: ThemeConfig.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SAVINGS ACCOUNT',
                    style: GoogleFonts.outfit(
                      color: Colors.white60,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Image.asset(
                    'assets/images/union_bank_logo.png',
                    height: 18,
                    color: Colors.white,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Balance section
              Row(
                children: [
                  Text(
                    _isBalanceVisible
                        ? '₹${user.balance.toStringAsFixed(2)}'
                        : '₹ ••••••',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: _isBalanceVisible ? 0 : 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () async {
                      if (_isBalanceVisible) {
                        if (mounted) setState(() => _isBalanceVisible = false);
                        return;
                      }

                      final messenger = ScaffoldMessenger.of(context);
                      final authenticated = await _biometricService.authenticate();
                      if (authenticated) {
                        if (mounted) setState(() => _isBalanceVisible = true);
                      } else {
                        if (mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Authentication failed'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Icon(
                      _isBalanceVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Account number
              Text(
                user.accountNumber,
                style: GoogleFonts.outfit(
                  color: Colors.white54,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 32),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.fullName.toUpperCase(),
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/100px-Mastercard-logo.svg.png',
                    width: 32,
                    color: Colors.white,
                    placeholder: (c, url) => const SizedBox(
                      width: 32,
                      height: 18,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (c, url, err) => const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
