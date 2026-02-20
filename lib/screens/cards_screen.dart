import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';
import '../config/routes_config.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.background,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Cards',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_card_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 900;
            final double horizontalPadding = isWide ? 32 : 20;
            final double maxWidth = isWide ? 1200 : double.infinity;

            // Card previews removed — cards are available in their respective pages
            final cardWidgets = <Widget>[];

            final detailWidgets = <Widget>[
              _buildSectionHeader('CARD SERVICES'),
              const SizedBox(height: 16),
              _buildServiceGrid(),
              const SizedBox(height: 32),
              _buildSectionHeader('RECENT TRANSACTIONS'),
              const SizedBox(height: 16),
              _buildTransactionItem(
                'Amazon.in',
                '15 Feb 2026',
                '₹2,499',
                Icons.shopping_bag_rounded,
                Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildTransactionItem(
                'Swiggy',
                '14 Feb 2026',
                '₹456',
                Icons.restaurant_rounded,
                Colors.red,
              ),
              const SizedBox(height: 12),
              _buildTransactionItem(
                'Uber',
                '13 Feb 2026',
                '₹234',
                Icons.local_taxi_rounded,
                Colors.black,
              ),
            ];

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    20,
                  ),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: cardWidgets,
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: detailWidgets,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...cardWidgets,
                            if (cardWidgets.isNotEmpty) const SizedBox(height: 32),
                            ...detailWidgets,
                          ],
                        ),
                ),
              ),
            );
          },
        ),
    );
  }

  // Card previews removed — kept helper methods removed to avoid duplication

  // Debit card helper removed as card previews are handled elsewhere

  Widget _buildServiceGrid() {
    final services = [
      {
        'icon': Icons.credit_card_rounded,
        'label': 'Credit Card',
        'color': Colors.purple,
        'route': RoutesConfig.creditCard,
      },
      {
        'icon': Icons.account_balance_wallet_rounded,
        'label': 'Debit Card',
        'color': Colors.green,
        'route': RoutesConfig.debitCard,
      },
      {
        'icon': Icons.qr_code_scanner_rounded,
        'label': 'Scan QR',
        'color': Colors.teal,
        'route': RoutesConfig.qrScanner,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 600;
        final int crossAxisCount = isWide ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: isWide ? 1.6 : 1.4,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            final route = service['route'] as String?;
            return Container(
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: route == null
                      ? null
                      : () => Navigator.pushNamed(context, route),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        service['icon'] as IconData,
                        color: service['color'] as Color,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service['label'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ThemeConfig.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTransactionItem(
    String merchant,
    String date,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ThemeConfig.primaryColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: ThemeConfig.primaryColor,
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

