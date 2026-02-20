import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../config/api_config.dart';

class ApiService {
  static const String _baseUrl = ApiConfig.baseUrl;
  static const Duration _timeout = Duration(seconds: 30);

  // Login endpoint
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Login error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Face verification endpoint
  Future<Map<String, dynamic>> faceVerify(String capturedFace) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/face-verify'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'capturedFace': capturedFace,
            }),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Face verify error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Transfer money endpoint
  Future<Map<String, dynamic>> transfer(
    String fromAccount,
    String toAccount,
    double amount,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/transactions/transfer'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fromAccountNumber': fromAccount,
              'toAccountNumber': toAccount,
              'amount': amount,
            }),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Transfer error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Fetch transaction history endpoint
  Future<Map<String, dynamic>> fetchTransactionHistory(String accountNumber) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/transactions/history/$accountNumber'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Fetch history error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get user profile endpoint
  Future<Map<String, dynamic>> getUserProfile(String accountNumber) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/user/profile/$accountNumber'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Get profile error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Helper method to handle HTTP responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data is Map<String, dynamic>
            ? data
            : {'success': false, 'message': 'Invalid response format'};
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'message': 'Bad request',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Unauthorized',
        };
      } else if (response.statusCode == 500) {
        return {
          'success': false,
          'message': 'Server error',
        };
      } else {
        return {
          'success': false,
          'message': 'Error: ${response.statusCode}',
        };
      }
    } catch (e) {
      debugPrint('Response handling error: $e');
      return {'success': false, 'message': 'Error parsing response'};
    }
  }
}

