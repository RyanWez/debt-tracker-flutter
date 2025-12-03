import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../widgets/add_customer_dialog.dart';
import '../l10n/app_localizations.dart';
import 'customer_detail_screen.dart';

enum SortOption { highestDebt, lowestDebt, nameAz, recentActivity }

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  String _searchQuery = '';
  SortOption _sortOption = SortOption.highestDebt;

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

        customers.sort((a, b) {
          switch (_sortOption) {
            case SortOption.highestDebt:
              return b.totalDebt.compareTo(a.totalDebt);
            case SortOption.lowestDebt:
              return a.totalDebt.compareTo(b.totalDebt);
            case SortOption.nameAz:
              return a.name.toLowerCase().compareTo(b.name.toLowerCase());
            case SortOption.recentActivity:
              return b.lastTransactionDate.compareTo(a.lastTransactionDate);
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.navCustomers),
            actions: [
              PopupMenuButton<SortOption>(
                icon: const Icon(Icons.sort_rounded),
                tooltip: l10n.sortBy,
                onSelected: (SortOption result) {
                  setState(() {
                    _sortOption = result;
                  });
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SortOption>>[
                      PopupMenuItem<SortOption>(
                        value: SortOption.highestDebt,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_downward,
                              color: _sortOption == SortOption.highestDebt
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.sortHighestDebt,
                              style: TextStyle(
                                fontWeight:
                                    _sortOption == SortOption.highestDebt
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _sortOption == SortOption.highestDebt
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<SortOption>(
                        value: SortOption.lowestDebt,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              color: _sortOption == SortOption.lowestDebt
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.sortLowestDebt,
                              style: TextStyle(
                                fontWeight: _sortOption == SortOption.lowestDebt
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _sortOption == SortOption.lowestDebt
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<SortOption>(
                        value: SortOption.nameAz,
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort_by_alpha,
                              color: _sortOption == SortOption.nameAz
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.sortNameAz,
                              style: TextStyle(
                                fontWeight: _sortOption == SortOption.nameAz
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _sortOption == SortOption.nameAz
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<SortOption>(
                        value: SortOption.recentActivity,
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              color: _sortOption == SortOption.recentActivity
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.sortRecentActivity,
                              style: TextStyle(
                                fontWeight:
                                    _sortOption == SortOption.recentActivity
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _sortOption == SortOption.recentActivity
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: SearchBar(
                        hintText: l10n.searchHint,
                        leading: const Icon(Icons.search),
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.grey.shade100,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 56,
                        child: FilledButton(
                          onPressed: () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: l10n.addCustomer,
                              barrierColor: Colors.black54,
                              transitionDuration: const Duration(
                                milliseconds: 300,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                    return const AddCustomerDialog();
                                  },
                              transitionBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
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
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(Icons.person_add),
                        ),
                      ),
                    ),
                  ],
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
                          child: Opacity(opacity: value, child: child),
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
                                builder: (context) => CustomerDetailScreen(
                                  customerId: customer.id,
                                ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customer.name.length > 12
                                            ? '${customer.name.substring(0, 12)}...'
                                            : customer.name,
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
        );
      },
    );
  }
}
