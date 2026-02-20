import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/face_auth_screen.dart';
import '../screens/transfer_screen.dart';
import '../screens/accounts_screen.dart';
import '../screens/cards_screen.dart';
import '../screens/credit_card_screen.dart';
import '../screens/debit_card_screen.dart';
import '../screens/qr_scanner_screen.dart';

class RoutesConfig {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String faceAuth = '/face-auth';
  static const String transfer = '/transfer';
  static const String accounts = '/accounts';
  static const String cards = '/cards';
  static const String creditCard = '/cards/credit';
  static const String debitCard = '/cards/debit';
  static const String qrScanner = '/qr-scanner';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    dashboard: (context) => const DashboardScreen(),
    faceAuth: (context) => const FaceAuthScreen(),
    transfer: (context) => const TransferScreen(),
    accounts: (context) => const AccountsScreen(),
    cards: (context) => const CardsScreen(),
    creditCard: (context) => const CreditCardScreen(),
    debitCard: (context) => const DebitCardScreen(),
    qrScanner: (context) => const QRScannerScreen(),
  };
}
