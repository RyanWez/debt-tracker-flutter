import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/data_provider.dart';
import '../widgets/edit_customer_dialog.dart';
import '../l10n/app_localizations.dart';
import 'add_transaction_screen.dart';

class CustomerDetailScreen extends StatelessWidget {
  final String customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final customer = dataProvider.customers.firstWhere(
          (c) => c.id == customerId,
          orElse: () => throw Exception('Customer not found'),
        );

        final transactions =
            dataProvider.transactions
                .where((t) => t.customerId == customerId)
                .toList()
              ..sort((a, b) => b.date.compareTo(a.date));

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.customerDetails),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: l10n.editCustomer,
                    barrierColor: Colors.black54,
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return EditCustomerDialog(customer: customer);
                    },
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                            reverseCurve: Curves.easeInCubic,
                          );

                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -1),
                              end: Offset.zero,
                            ).animate(curvedAnimation),
                            child: FadeTransition(
                              opacity: curvedAnimation,
                              child: child,
                            ),
                          );
                        },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  // Check if customer has debt
                  if (customer.totalDebt > 0) {
                    _showToast(
                      '${l10n.cannotDelete}${NumberFormat("#,##0", "en_US").format(customer.totalDebt)} ${l10n.currencySymbol}',
                      isError: true,
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.deleteCustomer),
                      content: Text(l10n.deleteCustomerMsg),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            dataProvider.deleteCustomer(customerId);
                            Navigator.pop(ctx); // Close dialog
                            Navigator.pop(context); // Go back to list
                          },
                          child: Text(
                            l10n.delete,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Hero(
                      tag: 'avatar_${customer.id}',
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: Text(
                          customer.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer.phone,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.totalDebt,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${NumberFormat("#,##0", "en_US").format(customer.totalDebt)} ${l10n.currencySymbol}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: customer.totalDebt > 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTransactionScreen(
                                    customerId: customerId,
                                    type: 'debt',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_downward),
                            label: Text(l10n.addDebt),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: customer.totalDebt > 0
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddTransactionScreen(
                                              customerId: customerId,
                                              type: 'payment',
                                            ),
                                      ),
                                    );
                                  }
                                : null, // Disabled when no debt
                            icon: const Icon(Icons.arrow_upward),
                            label: Text(l10n.repay),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
                              disabledBackgroundColor: Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noTransactionsYet,
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(
                              milliseconds:
                                  400 + (index * 80), // Slower, more elegant
                            ),
                            curve: Curves.easeOutCubic, // Smooth easing curve
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  30 * (1 - value),
                                ), // Larger slide distance
                                child: child,
                              );
                            },
                            child: Dismissible(
                              key: Key(transaction.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(l10n.deleteTransaction),
                                    content: Text(l10n.deleteTransactionMsg),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: Text(l10n.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: Text(
                                          l10n.delete,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) {
                                dataProvider.deleteTransaction(transaction.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.transactionDeleted),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
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
                                    transaction.type == 'debt'
                                        ? l10n.debtAdded
                                        : l10n.paymentReceived,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat(
                                      'MMM d, yyyy • h:mm a',
                                      'en',
                                    ).format(transaction.date),
                                  ),
                                  trailing: Text(
                                    '${transaction.type == 'debt' ? '-' : '+'}${NumberFormat("#,##0", "en_US").format(transaction.amount)} ${l10n.currencySymbol}',
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
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
