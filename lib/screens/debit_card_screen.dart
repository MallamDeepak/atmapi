import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme_config.dart';
import '../models/card_model.dart';
import '../services/biometric_service.dart';

class DebitCardScreen extends StatefulWidget {
  const DebitCardScreen({super.key});

  @override
  State<DebitCardScreen> createState() => _DebitCardScreenState();
}

class _DebitCardScreenState extends State<DebitCardScreen>
    with SingleTickerProviderStateMixin {
  final BiometricService _biometricService = BiometricService();
  bool _isDetailsVisible = false;
  bool _isCardFlipped = false;
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  // Demo debit card data
  final CardModel _card = CardModel(
    id: '2',
    cardNumber: '5262123456789001',
    cardHolderName: 'DEMO USER',
    expiryDate: '09/27',
    cvv: '456',
    cardType: 'debit',
    network: 'Mastercard',
    balance: 45678.90,
    isVirtual: true,
    gradient: 'green',
  );

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _toggleDetails() async {
    if (_isDetailsVisible) {
      setState(() => _isDetailsVisible = false);
      return;
    }

    final authenticated = await _biometricService.authenticate();
    if (authenticated) {
      setState(() => _isDetailsVisible = true);
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
  }

  void _openQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DebitCardQRScannerScreen(),
      ),
    );
  }

  void _toggleCardFace() {
    if (_flipController.isAnimating) return;

    setState(() => _isCardFlipped = !_isCardFlipped);
    if (_isCardFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF11998e),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Debit Card',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
            onPressed: _openQRScanner,
            tooltip: 'Scan QR Code',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 900;
          final double horizontalPadding = isWide ? 32 : 20;
          final double maxWidth = isWide ? 1100 : double.infinity;

          final leftColumn = <Widget>[
            _buildVirtualCard(),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _toggleDetails,
                icon: Icon(
                  _isDetailsVisible ? Icons.visibility_off : Icons.fingerprint,
                ),
                label: Text(
                  _isDetailsVisible ? 'Hide Details' : 'View Full Details',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF11998e),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ];

          final rightColumn = <Widget>[
            _buildCardDetails(),
            const SizedBox(height: 32),
            Text(
              'QUICK ACTIONS',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: ThemeConfig.primaryColor.withValues(alpha: 0.4),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickActions(),
          ];

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 20,
                ),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: leftColumn,
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: rightColumn,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...leftColumn,
                          const SizedBox(height: 32),
                          ...rightColumn,
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  Widget _buildVirtualCard() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: AspectRatio(
          aspectRatio: 1.58,
          child: GestureDetector(
            onTap: _toggleCardFace,
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value * 3.141592653589793;
                final showBack = angle > (3.141592653589793 / 2);

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: showBack
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateY(3.141592653589793),
                          child: _buildCardBack(),
                        )
                      : _buildCardFront(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF11998e).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'VIRTUAL',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl:
                          'https://upload.wikimedia.org/wikipedia/commons/2/2a/Mastercard-logo.svg',
                      height: 24,
                      color: Colors.white,
                      placeholder: (c, url) => const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, __, ___) => const Text(
                        'MC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _card.maskedCardNumber,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
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
                          'CARD HOLDER',
                          style: GoogleFonts.outfit(
                            color: Colors.white60,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _card.cardHolderName,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'EXPIRES',
                          style: GoogleFonts.outfit(
                            color: Colors.white60,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isDetailsVisible ? _card.expiryDate : '**/**',
                          style: GoogleFonts.robotoMono(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0f8a81), Color(0xFF2cd96f)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF11998e).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _isDetailsVisible ? _card.cvv : '***',
                      style: GoogleFonts.robotoMono(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'CVV',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: CachedNetworkImage(
                imageUrl:
                    'https://upload.wikimedia.org/wikipedia/commons/2/2a/Mastercard-logo.svg',
                height: 24,
                color: Colors.white,
                placeholder: (c, url) => const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, __, ___) => const Text(
                  'MC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ThemeConfig.cardShadow,
      ),
      child: Column(
        children: [
          _buildDetailRow('Card Number', 
            _isDetailsVisible ? _formatCardNumber(_card.cardNumber) : _card.maskedCardNumber,
            Icons.credit_card,
          ),
          const Divider(height: 32),
          _buildDetailRow('CVV', 
            _isDetailsVisible ? _card.cvv : '***',
            Icons.lock,
          ),
          const Divider(height: 32),
            _buildDetailRow(
              'Available Balance',
              _isDetailsVisible ? '₹${_card.balance!.toStringAsFixed(2)}' : '₹ ••••••',
              Icons.account_balance_wallet,
              valueColor: Colors.green,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ThemeConfig.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: ThemeConfig.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
                 Text(
                   value,
                   maxLines: 1,
                   softWrap: false,
                   overflow: TextOverflow.ellipsis,
                   style: GoogleFonts.robotoMono(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                     color: valueColor ?? ThemeConfig.primaryColor,
                   ),
                 ),
            ],
          ),
        ),
        if (_isDetailsVisible && label == 'Card Number')
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _card.cardNumber));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card number copied')),
              );
            },
          ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildActionCard('Block Card', Icons.block, Colors.red),
        _buildActionCard('Reset PIN', Icons.lock_reset, Colors.blue),
        _buildActionCard('Limits', Icons.tune, Colors.orange),
        _buildActionCard('ATM Nearby', Icons.local_atm, Colors.green),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: ThemeConfig.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
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
  }

  String _formatCardNumber(String number) {
    return number.replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ').trim();
  }
}

class DebitCardQRScannerScreen extends StatefulWidget {
  const DebitCardQRScannerScreen({super.key});

  @override
  State<DebitCardQRScannerScreen> createState() => _DebitCardQRScannerScreenState();
}

class _DebitCardQRScannerScreenState extends State<DebitCardQRScannerScreen> {
  bool _isProcessing = false;
  final bool _isScannerSupported = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  void _handleScan(String code) {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _showPaymentDialog(code);
        setState(() => _isProcessing = false);
      }
    });
  }

  void _showPaymentDialog(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
        ),
        title: Column(
          children: [
            Icon(
              Icons.qr_code_scanner_rounded,
              color: ThemeConfig.successColor,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'QR Code Scanned',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Merchant Code: $code\n\nProceed with payment?',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment initiated')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.primaryColor,
            ),
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Scan QR Code',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (_isScannerSupported)
            MobileScanner(
              onDetect: (capture) {
                if (_isProcessing) return;
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  _handleScan(barcodes.first.rawValue!);
                }
              },
            )
          else
            Container(
              color: ThemeConfig.background,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.qr_code_scanner_rounded, size: 56),
                      const SizedBox(height: 12),
                      Text(
                        'QR scanner not supported on this device.',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Use Android or iOS to scan QR codes.',
                        style: GoogleFonts.outfit(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          if (_isScannerSupported)
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          
          if (_isScannerSupported)
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white30, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          
          if (_isProcessing)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      'Processing...',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
