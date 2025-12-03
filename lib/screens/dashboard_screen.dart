import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        double totalDebt = dataProvider.customers.fold(
          0,
          (sum, item) => sum + item.totalDebt,
        );
        int totalCustomers = dataProvider.customers.length;
        final recentTransactions = dataProvider.transactions.reversed
            .take(5)
            .toList();

        return Scaffold(
          appBar: AppBar(title: Text(l10n.navDashboard)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: l10n.totalDebt,
                        value:
                            '${NumberFormat("#,##0", "en_US").format(totalDebt.abs())} ${l10n.currencySymbol}',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        icon: Icons.money_off,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SummaryCard(
                        title: l10n.customers,
                        value: '$totalCustomers',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        icon: Icons.people,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.recentTransactions,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (recentTransactions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(l10n.noTransactions),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = recentTransactions[index];
                      final customer = dataProvider.customers.firstWhere(
                        (c) => c.id == transaction.customerId,
                        orElse: () => throw Exception('Customer not found'),
                      );
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(
                          milliseconds: 400 + (index * 80), // Slower, more elegant
                        ),
                        curve: Curves.easeOutCubic, // Smooth easing curve
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)), // Larger slide distance
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: transaction.type == 'debt'
                                  ? Colors.red.shade50
                                  : Colors.green.shade50,
                              child: Icon(
                                transaction.type == 'debt'
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: transaction.type == 'debt'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            title: Text(
                              customer.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat(
                                'MMM d, h:mm a',
                                'en',
                              ).format(transaction.date),
                            ),
                            trailing: Text(
                              '${transaction.type == 'debt' ? '-' : '+'}${NumberFormat("#,##0", "en_US").format(transaction.amount)}',
                              style: TextStyle(
                                color: transaction.type == 'debt'
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Gradient gradient;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
