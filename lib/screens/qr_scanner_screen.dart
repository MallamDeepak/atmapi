import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  final bool _isScannerSupported = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  void _handleScan(String code) {
    Future(() {
      if (mounted) {
        setState(() => _isProcessing = true);
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _showSuccessDialog(code);
        setState(() => _isProcessing = false);
      }
    });
  }

  void _showSuccessDialog(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
        ),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: ThemeConfig.success,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Connection Successful',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Terminal ID: $code\nYou can proceed with your transaction.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanSize = size.width * 0.72;
    final frameCenter = Offset(size.width / 2, size.height * 0.46);
    final frameRect = Rect.fromCenter(
      center: frameCenter,
      width: scanSize,
      height: scanSize,
    );

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
        centerTitle: true,
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
            Positioned.fill(
              child: CustomPaint(
                painter: _ScannerOverlayPainter(
                  scanSize: scanSize,
                  borderRadius: ThemeConfig.radiusLarge,
                  center: frameCenter,
                ),
              ),
            ),

          if (_isScannerSupported)
            const SizedBox.shrink(),

          if (_isScannerSupported)
            Positioned(
              left: frameRect.left,
              top: frameRect.top,
              width: frameRect.width,
              height: frameRect.height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
                child: AnimatedBuilder(
                  animation: _scanController,
                  builder: (context, child) {
                    final lineY = _scanController.value * (frameRect.height - 6);
                    return Stack(
                      children: [
                        Positioned(
                          left: 16,
                          right: 16,
                          top: lineY,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: ThemeConfig.info.withValues(alpha: 0.9),
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeConfig.info.withValues(alpha: 0.5),
                                  blurRadius: 12,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

          if (_isScannerSupported)
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.qr_code_2, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Align the QR inside the frame',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scanning starts automatically',
                    style: GoogleFonts.outfit(color: Colors.white70),
                  ),
                ],
              ),
            ),

          // Loading overlay
          if (_isProcessing)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Processing...',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({
    required this.scanSize,
    required this.borderRadius,
    required this.center,
  });

  final double scanSize;
  final double borderRadius;
  final Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    final cutOutRect = Rect.fromCenter(
      center: center,
      width: scanSize,
      height: scanSize,
    );
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.65);
    final cutOutRRect = RRect.fromRectAndRadius(
      cutOutRect,
      Radius.circular(borderRadius),
    );

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(cutOutRRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);

    final cornerPaint = Paint()
      ..color = ThemeConfig.info
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const double cornerLength = 28;
    final r = cutOutRect;

    // Top-left corner
    canvas.drawLine(r.topLeft, r.topLeft.translate(cornerLength, 0), cornerPaint);
    canvas.drawLine(r.topLeft, r.topLeft.translate(0, cornerLength), cornerPaint);

    // Top-right corner
    canvas.drawLine(r.topRight, r.topRight.translate(-cornerLength, 0), cornerPaint);
    canvas.drawLine(r.topRight, r.topRight.translate(0, cornerLength), cornerPaint);

    // Bottom-left corner
    canvas.drawLine(r.bottomLeft, r.bottomLeft.translate(cornerLength, 0), cornerPaint);
    canvas.drawLine(r.bottomLeft, r.bottomLeft.translate(0, -cornerLength), cornerPaint);

    // Bottom-right corner
    canvas.drawLine(r.bottomRight, r.bottomRight.translate(-cornerLength, 0), cornerPaint);
    canvas.drawLine(r.bottomRight, r.bottomRight.translate(0, -cornerLength), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) {
    return scanSize != oldDelegate.scanSize ||
        borderRadius != oldDelegate.borderRadius;
  }
}
