import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';

class YonoPayScreen extends StatelessWidget {
  const YonoPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.background,
      appBar: AppBar(
        title: Text(
          'Union Bank Pay',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 900;
          final double horizontalPadding = isWide ? 32 : 16;
          final double maxWidth = isWide ? 900 : double.infinity;

          final options = [
            (
              'Scan QR',
              Icons.qr_code,
              'Pay with QR code',
              () {},
            ),
            (
              'Mobile Number',
              Icons.phone,
              'Send to contact',
              () {},
            ),
            (
              'Bank Account',
              Icons.account_balance,
              'Transfer to bank',
              () {},
            ),
          ];

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: isWide
                    ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.6,
                        ),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final (title, icon, subtitle, onTap) = options[index];
                          return _buildPaymentOption(
                            title,
                            icon,
                            subtitle,
                            onTap,
                          );
                        },
                      )
                    : ListView.separated(
                        itemCount: options.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final (title, icon, subtitle, onTap) = options[index];
                          return _buildPaymentOption(
                            title,
                            icon,
                            subtitle,
                            onTap,
                          );
                        },
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentOption(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
      ),
      tileColor: Colors.white,
      leading: Icon(icon, color: ThemeConfig.primary, size: 28),
      title: Text(
        title,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}

