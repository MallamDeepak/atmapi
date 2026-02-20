import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';
import '../config/routes_config.dart';
import '../providers/auth_provider.dart';
import '../widgets/account_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;

        if (user == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: ThemeConfig.background,
          appBar: _buildAppBar(user.fullName),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth >= 900;
              final double horizontalPadding = isWide ? 32 : 16;
              final double maxWidth = isWide ? 1100 : double.infinity;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16,
                    ),
                    children: [
                      // Account card
                      const AccountCard(),
                      const SizedBox(height: 32),

                      // Quick actions
                      _buildSectionTitle('Quick Actions'),
                      const SizedBox(height: 16),
                      _buildQuickActionsGrid(context, constraints.maxWidth),
                      const SizedBox(height: 32),

                      // Recent transactions section
                      _buildSectionTitle('Recent Transactions'),
                      const SizedBox(height: 16),
                      _buildTransactionsList(),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(String userName) {
    return AppBar(
      backgroundColor: ThemeConfig.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'Welcome, $userName',
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'profile':
                // navigate to profile if you have a route
                Navigator.pushNamed(context, RoutesConfig.accounts);
                break;
              case 'settings':
                showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Settings'),
                    content: const Text('Settings screen is not implemented yet.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c), child: const Text('Close')),
                    ],
                  ),
                );
                break;
              case 'help':
                showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Help'),
                    content: const Text('Open help or support contact.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c), child: const Text('Close')),
                    ],
                  ),
                );
                break;
              case 'logout':
                _showLogoutDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'profile', child: Text('Profile')),
            const PopupMenuItem(value: 'settings', child: Text('Settings')),
            const PopupMenuItem(value: 'help', child: Text('Help')),
            const PopupMenuDivider(),
            const PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ThemeConfig.primary,
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, double width) {
    final actions = [
      ('Transfer', Icons.send, () {
        Navigator.pushNamed(context, RoutesConfig.transfer);
      }),
      ('Pay', Icons.qr_code_2, () {
        Navigator.pushNamed(context, RoutesConfig.qrScanner);
      }),
      ('Accounts', Icons.account_balance, () {
        Navigator.pushNamed(context, RoutesConfig.accounts);
      }),
      ('Cards', Icons.credit_card, () {
        Navigator.pushNamed(context, RoutesConfig.cards);
      }),
    ];

    int crossAxisCount = 4;
    if (width >= 1200) {
      crossAxisCount = 5;
    } else if (width >= 900) {
      crossAxisCount = 4;
    } else if (width >= 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final (label, icon, onTap) = actions[index];
        return _buildActionButton(label, icon, onTap);
      },
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: ThemeConfig.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      children: [
        _buildTransactionItem(
          'Transfer to Account',
          '₹5,000',
          'Today',
          Icons.arrow_forward,
          ThemeConfig.success,
        ),
        const SizedBox(height: 12),
        _buildTransactionItem(
          'Salary Credit',
          '+ ₹50,000',
          'Yesterday',
          Icons.arrow_downward,
          ThemeConfig.success,
        ),
        const SizedBox(height: 12),
        _buildTransactionItem(
          'Bill Payment',
          '₹1,500',
          '2 days ago',
          Icons.arrow_forward,
          ThemeConfig.error,
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String amount,
    String date,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConfig.radiusLarge),
        boxShadow: ThemeConfig.defaultShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.pushReplacementNamed(context, RoutesConfig.login);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }
}
