import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';

class DepositsScreen extends StatelessWidget {
  const DepositsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.background,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Deposits',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildDepositTypeCard(
            'Fixed Deposit',
            'Earn up to 7.5% p.a.',
            'Lock your savings for guaranteed returns',
            Icons.lock_clock_rounded,
            Colors.orange,
            const Color(0xFFFFF3E0),
          ),
          
          const SizedBox(height: 16),
          
          _buildDepositTypeCard(
            'Recurring Deposit',
            'Save monthly, earn more',
            'Build wealth with small monthly deposits',
            Icons.calendar_month_rounded,
            Colors.deepOrange,
            const Color(0xFFFBE9E7),
          ),
          
          const SizedBox(height: 32),
          
          _buildSectionHeader('ACTIVE DEPOSITS'),
          const SizedBox(height: 16),
          
          _buildActiveDepositCard(
            'FD - 365 Days',
            '₹2,00,000',
            '7.25% p.a.',
            'Matures on: 15 Aug 2026',
            Colors.orange,
          ),
          
          const SizedBox(height: 12),
          
          _buildActiveDepositCard(
            'RD - Monthly ₹5,000',
            '₹60,000',
            '6.75% p.a.',
            'Next due: 1 Mar 2026',
            Colors.deepOrange,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'New Deposit',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDepositTypeCard(String title, String subtitle, String description, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeConfig.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: color, size: 18),
        ],
      ),
    );
  }

  Widget _buildActiveDepositCard(String title, String amount, String rate, String info, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.savings_rounded, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ThemeConfig.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeConfig.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rate,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: ThemeConfig.primaryColor.withValues(alpha: 0.4),
        letterSpacing: 1.5,
      ),
    );
  }
}

