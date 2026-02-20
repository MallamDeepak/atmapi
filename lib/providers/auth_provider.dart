import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/biometric_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final BiometricService _biometricService = BiometricService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  // Login with face authentication
  Future<bool> loginWithFace(String base64Image) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.faceVerify(base64Image);
      
      if (response['success'] == true && response['user'] != null) {
        _currentUser = UserModel.fromJson(response['user']);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        _setError('Face recognition failed. Please try again.');
        return false;
      }
    } catch (e) {
      _setError('Login error: $e');
      debugPrint('Face login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login with biometrics
  Future<bool> loginWithBiometrics() async {
    _setLoading(true);
    _clearError();

    try {
      final authenticated = await _biometricService.authenticate();
      
      if (authenticated) {
        // In production, send token to backend
        // For demo, use mock login
        final response = await _apiService.login('demo', 'password');
        
        if (response['success'] == true && response['user'] != null) {
          _currentUser = UserModel.fromJson(response['user']);
          _isAuthenticated = true;
          notifyListeners();
          return true;
        }
      }
      
      _setError('Authentication failed');
      return false;
    } catch (e) {
      _setError('Biometric error: $e');
      debugPrint('Biometric login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    _clearError();
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
