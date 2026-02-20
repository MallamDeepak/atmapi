import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';
import '../providers/banking_provider.dart';
import '../services/biometric_service.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final BiometricService _biometricService = BiometricService();
  bool _isBalanceRevealed = false;

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    final bankingProvider = Provider.of<BankingProvider>(context, listen: false);

    Future(() {
      if (mounted) {
        bankingProvider.transfer(
          fromAccount: '****1234',
          toAccount: _accountController.text,
          amount: double.parse(_amountController.text),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.background,
      appBar: AppBar(
        title: Text(
          'Transfer Money',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // From account section
              _buildSectionCard(
                'FROM ACCOUNT',
                [
                  _buildInfoRow('Account', '****1234'),
                  _buildBalanceRow('Balance', '₹45,678.90'),
                ],
              ),
              const SizedBox(height: 24),

              // To account field
              _buildSectionCard(
                'TO ACCOUNT',
                [
                  TextFormField(
                    controller: _accountController,
                    decoration: InputDecoration(
                      hintText: 'Enter account number',
                      prefixIcon: const Icon(Icons.account_balance),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ThemeConfig.radiusMedium,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter account number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Amount field
              _buildSectionCard(
                'AMOUNT',
                [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: '₹ ',
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ThemeConfig.radiusMedium,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter amount';
                      }
                      if (double.tryParse(value!) == null) {
                        return 'Please enter valid amount';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Transfer button
              Consumer<BankingProvider>(
                builder: (context, bankingProvider, _) {
                  return ElevatedButton(
                    onPressed: bankingProvider.isLoading ? null : _handleTransfer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: bankingProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'TRANSFER',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),

              // Error message
              Consumer<BankingProvider>(
                builder: (context, bankingProvider, _) {
                  if (bankingProvider.errorMessage != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ThemeConfig.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          bankingProvider.errorMessage!,
                          style: TextStyle(color: ThemeConfig.error),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: ThemeConfig.primary.withValues(alpha: 0.6),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
            boxShadow: ThemeConfig.defaultShadow,
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(color: Colors.grey[600]),
          ),
          Row(
            children: [
              Text(
                _isBalanceRevealed ? value : '₹ ••••••',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  if (_isBalanceRevealed) {
                    if (mounted) setState(() => _isBalanceRevealed = false);
                    return;
                  }

                  final messenger = ScaffoldMessenger.of(context);
                  final authenticated = await _biometricService.authenticate();
                  if (authenticated) {
                    if (mounted) setState(() => _isBalanceRevealed = true);
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Authentication failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Icon(
                  _isBalanceRevealed ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
      
