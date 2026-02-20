import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.background,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Insurance',
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
          _buildSectionHeader('INSURANCE PRODUCTS'),
          const SizedBox(height: 16),
          
          _buildInsuranceCard(
            'Life Insurance',
            'Secure your family\'s future',
            'Starting from ₹500/month',
            Icons.favorite_rounded,
            Colors.teal,
            const Color(0xFFE0F2F1),
          ),
          
          const SizedBox(height: 12),
          
          _buildInsuranceCard(
            'Health Insurance',
            'Comprehensive health coverage',
            'Cover up to ₹10 Lakhs',
            Icons.local_hospital_rounded,
            Colors.blue,
            const Color(0xFFE3F2FD),
          ),
          
          const SizedBox(height: 12),
          
          _buildInsuranceCard(
            'Vehicle Insurance',
            'Protect your car & bike',
            'Instant policy issuance',
            Icons.directions_car_rounded,
            Colors.orange,
            const Color(0xFFFFF3E0),
          ),
          
          const SizedBox(height: 12),
          
          _buildInsuranceCard(
            'Home Insurance',
            'Safeguard your property',
            'Coverage from ₹1000/year',
            Icons.home_rounded,
            Colors.purple,
            const Color(0xFFF3E5F5),
          ),
          
          const SizedBox(height: 32),
          
          _buildSectionHeader('MY POLICIES'),
          const SizedBox(height: 16),
          
          _buildPolicyCard(
            'Union Bank Life Shield',
            'Policy No: UNIONB123456789',
            '₹50,00,000',
            'Renews on: 15 Apr 2026',
            Colors.teal,
          ),
          
          const SizedBox(height: 12),
          
          _buildPolicyCard(
            'Health Plus',
            'Policy No: UNIONH987654321',
            '₹5,00,000',
            'Renews on: 22 Jun 2026',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceCard(String title, String description, String price, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ThemeConfig.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
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

  Widget _buildPolicyCard(String name, String policyNumber, String coverage, String renewal, Color color) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.shield_rounded, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ThemeConfig.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      policyNumber,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Active',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coverage',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coverage,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Renewal',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      renewal.split(': ')[1],
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeConfig.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

