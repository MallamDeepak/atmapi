import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme_config.dart';
import 'config/routes_config.dart';
import 'providers/auth_provider.dart';
import 'providers/banking_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BankingProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
        title: 'Union Bank',
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: ThemeMode.light,
        home: authProvider.isAuthenticated
            ? const DashboardScreen()
            : const LoginScreen(),
        routes: RoutesConfig.routes,
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Route not found')),
            ),
          );
        },
          );
        },
      ),
    );
  }
}
