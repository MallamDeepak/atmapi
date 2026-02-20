import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        // Fallback for emulators or desktop versions without biometric hardware
        debugPrint("Biometrics not supported on this device. Using bypass for demo.");
        return true; 
      }

      authenticated = await auth.authenticate(
        localizedReason: 'Scan your face or fingerprint to authenticate',
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return authenticated;
  }

  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
  }
}
