import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/api_service.dart';

class BankingProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  double _balance = 0.0;

  // Getters
  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get balance => _balance;

  // Fetch transaction history
  Future<void> fetchTransactionHistory(String accountNumber) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.fetchTransactionHistory(accountNumber);
      
      if (response['success'] == true && response['history'] != null) {
        _transactions = (response['history'] as List)
            .map((item) => TransactionModel.fromJson(item))
            .toList();
      } else {
        _setError('Failed to fetch transactions');
      }
    } catch (e) {
      _setError('Error: $e');
      debugPrint('Fetch history error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Transfer money
  Future<bool> transfer({
    required String fromAccount,
    required String toAccount,
    required double amount,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.transfer(
        fromAccount,
        toAccount,
        amount,
      );

      if (response['success'] == true) {
        _balance = response['newBalance'] ?? _balance;
        // Refresh transaction history
        await fetchTransactionHistory(fromAccount);
        notifyListeners();
        return true;
      } else {
        _setError(response['message'] ?? 'Transfer failed');
        return false;
      }
    } catch (e) {
      _setError('Transfer error: $e');
      debugPrint('Transfer error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update balance
  void setBalance(double newBalance) {
    _balance = newBalance;
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

  void clearTransactions() {
    _transactions = [];
    notifyListeners();
  }
}
