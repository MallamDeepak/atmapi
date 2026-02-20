import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/biometric_service.dart';
import '../config/theme_config.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final BiometricService _biometricService = BiometricService();
  final Set<int> _revealed = {}; // indices of revealed balances

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.background,
      appBar: AppBar(
        title: Text(
          'My Accounts',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAccountCard(
            0,
            'Savings Account',
            '****1234',
            '₹45,678.90',
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildAccountCard(
            1,
            'Current Account',
            '****5678',
            '₹1,23,456.00',
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildAccountCard(
            2,
            'Fixed Deposit',
            '****9012',
            '₹5,00,000.00',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(
    int idx,
    String title,
    String number,
    String balance,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: ThemeConfig.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Icon(Icons.account_balance_wallet, color: Colors.white),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Account Number',
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          Text(
            number,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _revealed.contains(idx) ? balance : '₹ ••••••',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  if (_revealed.contains(idx)) {
                    setState(() => _revealed.remove(idx));
                    return;
                  }
                  final authenticated = await _biometricService.authenticate();
                  if (authenticated) {
                    setState(() => _revealed.add(idx));
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Authentication failed'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: Icon(
                  _revealed.contains(idx) ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
