import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../data/models.dart';
import '../data/graphql_operations.dart';
import '../services/nhost_service.dart';

class DataProvider with ChangeNotifier {
  List<Customer> _customers = [];
  List<Transaction> _transactions = [];

  List<Customer> get customers => _customers;
  List<Transaction> get transactions => _transactions;

  GraphQLClient get _client => NhostService().graphql;

  Future<void> loadData() async {
    await fetchCustomers();
    await fetchTransactions();
  }

  Future<void> fetchCustomers() async {
    final result = await _client.query(
      QueryOptions(document: gql(GQLQueries.getCustomers)),
    );

    if (result.hasException) {
      debugPrint('Error fetching customers: ${result.exception.toString()}');
      return;
    }

    final List<dynamic> data = result.data?['customers'] ?? [];
    _customers = data.map((e) => Customer.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    final result = await _client.query(
      QueryOptions(document: gql(GQLQueries.getTransactions)),
    );

    if (result.hasException) {
      debugPrint('Error fetching transactions: ${result.exception.toString()}');
      return;
    }

    final List<dynamic> data = result.data?['transactions'] ?? [];
    _transactions = data.map((e) => Transaction.fromJson(e)).toList();
    notifyListeners();
  }

  Future<bool> addCustomer(Customer customer) async {
    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(GQLQueries.addCustomer),
          variables: {
            'name': customer.name,
            'phone': customer.phone,
            'address': customer.address,
            'total_debt': customer.totalDebt,
            'last_transaction_date': customer.lastTransactionDate
                .toIso8601String(),
          },
        ),
      );

      if (result.hasException) {
        debugPrint('Error adding customer: ${result.exception.toString()}');
        return false;
      }

      final newCustomerData = result.data?['insert_customers_one'];
      if (newCustomerData != null) {
        _customers.insert(0, Customer.fromJson(newCustomerData));
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Exception adding customer: $e');
      return false;
    }
  }

  Future<void> updateCustomer(Customer updatedCustomer) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(GQLQueries.updateCustomer),
        variables: {
          'id': updatedCustomer.id,
          'name': updatedCustomer.name,
          'phone': updatedCustomer.phone,
          'address': updatedCustomer.address,
          'total_debt': updatedCustomer.totalDebt,
          'last_transaction_date': updatedCustomer.lastTransactionDate
              .toIso8601String(),
        },
      ),
    );

    if (result.hasException) {
      debugPrint('Error updating customer: ${result.exception.toString()}');
      return;
    }

    final index = _customers.indexWhere((c) => c.id == updatedCustomer.id);
    if (index != -1) {
      _customers[index] = updatedCustomer;
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String id) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(GQLQueries.deleteCustomer),
        variables: {'id': id},
      ),
    );

    if (result.hasException) {
      debugPrint('Error deleting customer: ${result.exception.toString()}');
      return;
    }

    _customers.removeWhere((c) => c.id == id);
    _transactions.removeWhere((t) => t.customerId == id);
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(GQLQueries.addTransaction),
        variables: {
          'customer_id': transaction.customerId,
          'amount': transaction.amount,
          'type': transaction.type,
          'date': transaction.date.toIso8601String(),
          'note': transaction.note,
        },
      ),
    );

    if (result.hasException) {
      debugPrint('Error adding transaction: ${result.exception.toString()}');
      return;
    }

    final newTransactionData = result.data?['insert_transactions_one'];
    if (newTransactionData != null) {
      final newTransaction = Transaction.fromJson(newTransactionData);
      _transactions.insert(0, newTransaction);

      // Update customer debt locally and on server
      final customerIndex = _customers.indexWhere(
        (c) => c.id == transaction.customerId,
      );
      if (customerIndex != -1) {
        final customer = _customers[customerIndex];
        if (transaction.type == 'debt') {
          customer.totalDebt += transaction.amount;
        } else {
          customer.totalDebt -= transaction.amount;
        }
        customer.lastTransactionDate = transaction.date;

        // Update customer on server
        await updateCustomer(customer);
      }
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    final transaction = _transactions.firstWhere(
      (t) => t.id == transactionId,
      orElse: () => throw Exception('Transaction not found'),
    );

    final result = await _client.mutate(
      MutationOptions(
        document: gql(GQLQueries.deleteTransaction),
        variables: {'id': transactionId},
      ),
    );

    if (result.hasException) {
      debugPrint('Error deleting transaction: ${result.exception.toString()}');
      return;
    }

    // Recalculate customer debt
    final customerIndex = _customers.indexWhere(
      (c) => c.id == transaction.customerId,
    );
    if (customerIndex != -1) {
      final customer = _customers[customerIndex];
      if (transaction.type == 'debt') {
        customer.totalDebt -= transaction.amount;
      } else {
        customer.totalDebt += transaction.amount;
      }
      // Update customer on server
      await updateCustomer(customer);
    }

    _transactions.removeWhere((t) => t.id == transactionId);
    notifyListeners();
  }
}
