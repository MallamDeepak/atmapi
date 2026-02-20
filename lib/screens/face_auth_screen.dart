import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';
import '../config/routes_config.dart';
import '../providers/auth_provider.dart';

class FaceAuthScreen extends StatefulWidget {
  const FaceAuthScreen({super.key});

  @override
  State<FaceAuthScreen> createState() => _FaceAuthScreenState();
}

class _FaceAuthScreenState extends State<FaceAuthScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
      if (!mounted) return;
      setState(() {});

      // Auto-trigger scan after camera is ready
      await Future.delayed(const Duration(seconds: 2));
      if (mounted && !_isProcessing) {
        _captureAndVerify();
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _captureAndVerify() async {
    if (_isProcessing ||
        _controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture) {
      return;
    }

    try {
      if (mounted) {
        setState(() => _isProcessing = true);
      }

      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      final bytes = await image.readAsBytes();
      final base64Image = "data:image/jpeg;base64,${base64Encode(bytes)}";

      if (!mounted) return;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.loginWithFace(base64Image);

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, RoutesConfig.dashboard);
      } else if (mounted) {
        _showError('Face not recognized. Please try again.');
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    } catch (e) {
      debugPrint('Capture error: $e');
      _showError('Camera error. Please try again.');
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller!.pausePreview();
    } else if (state == AppLifecycleState.resumed) {
      _controller!.resumePreview();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConfig.error,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _controller != null) {
            return Stack(
              children: [
                // Camera preview
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final previewSize = _controller!.value.previewSize;
                      if (previewSize == null) {
                        return const SizedBox.shrink();
                      }

                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: previewSize.height,
                          height: previewSize.width,
                          child: CameraPreview(_controller!),
                        ),
                      );
                    },
                  ),
                ),

                // Overlay UI
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Text(
                            'FACE AUTHENTICATION',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 200,
                            height: 1,
                            color: Colors.white30,
                          ),
                        ],
                      ),
                    ),

                    // Center scanning frame
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24, width: 2),
                          borderRadius:
                              BorderRadius.circular(ThemeConfig.radiusLarge),
                        ),
                        child: _isProcessing
                            ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Analyzing...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),

                    // Bottom info
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Position your face in the frame',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(valueColor:
                AlwaysStoppedAnimation<Color>(Colors.white)),
          );
        },
      ),
    );
  }
}
