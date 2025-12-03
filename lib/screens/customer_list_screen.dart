import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../widgets/add_customer_dialog.dart';
import '../l10n/app_localizations.dart';
import 'customer_detail_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final customers = dataProvider.customers.where((customer) {
          return customer.name.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              customer.phone.contains(_searchQuery);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.navCustomers),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SearchBar(
                  hintText: l10n.searchHint,
                  leading: const Icon(Icons.search),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.grey.shade100,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),
          ),
          body: customers.isEmpty
              ? Center(child: Text(l10n.noCustomers))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomerDetailScreen(customerId: customer.id),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'avatar_${customer.id}',
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    child: Text(
                                      customer.name[0].toUpperCase(),
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customer.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        customer.phone,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Add Customer',
                barrierColor: Colors.black54,
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const AddCustomerDialog();
                },
                transitionBuilder: (context, animation, secondaryAnimation, child) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  );
                  
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -1), // Start from top (off screen)
                      end: Offset.zero, // End at normal position
                    ).animate(curvedAnimation),
                    child: FadeTransition(
                      opacity: curvedAnimation,
                      child: child,
                    ),
                  );
                },
              );
            },
            label: Text(l10n.addCustomer),
            icon: const Icon(Icons.person_add),
          ),
        );
      },
    );
  }
}
