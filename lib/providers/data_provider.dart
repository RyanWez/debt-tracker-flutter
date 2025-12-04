import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../data/models.dart';

class DataProvider with ChangeNotifier {
  List<Customer> _customers = [];
  List<Transaction> _transactions = [];

  List<Customer> get customers => _customers;
  List<Transaction> get transactions => _transactions;

  static const String _customersKey = 'customers_data';
  static const String _transactionsKey = 'transactions_data';

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Customers
    final customersJson = prefs.getString(_customersKey);
    if (customersJson != null) {
      final List<dynamic> decoded = json.decode(customersJson);
      _customers = decoded.map((e) => Customer.fromJson(e)).toList();
    }

    // Load Transactions
    final transactionsJson = prefs.getString(_transactionsKey);
    if (transactionsJson != null) {
      final List<dynamic> decoded = json.decode(transactionsJson);
      _transactions = decoded.map((e) => Transaction.fromJson(e)).toList();
    }

    notifyListeners();
  }

  Future<void> _saveCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_customers.map((e) => e.toJson()).toList());
    await prefs.setString(_customersKey, encoded);
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_transactions.map((e) => e.toJson()).toList());
    await prefs.setString(_transactionsKey, encoded);
  }

  Future<bool> addCustomer(Customer customer) async {
    try {
      final newCustomer = Customer(
        id: const Uuid().v4(),
        name: customer.name,
        phone: customer.phone,
        address: customer.address,
        totalDebt: customer.totalDebt,
        lastTransactionDate: customer.lastTransactionDate,
      );

      _customers.insert(0, newCustomer);
      await _saveCustomers();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Exception adding customer: $e');
      return false;
    }
  }

  Future<void> updateCustomer(Customer updatedCustomer) async {
    final index = _customers.indexWhere((c) => c.id == updatedCustomer.id);
    if (index != -1) {
      _customers[index] = updatedCustomer;
      await _saveCustomers();
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String id) async {
    _customers.removeWhere((c) => c.id == id);
    _transactions.removeWhere((t) => t.customerId == id);
    await _saveCustomers();
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final newTransaction = Transaction(
      id: const Uuid().v4(),
      customerId: transaction.customerId,
      amount: transaction.amount,
      type: transaction.type,
      date: transaction.date,
      note: transaction.note,
    );

    _transactions.insert(0, newTransaction);
    await _saveTransactions();

    // Update customer debt locally
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

      await updateCustomer(customer);
    }
    notifyListeners();
  }

  Future<void> deleteTransaction(String transactionId) async {
    final transaction = _transactions.firstWhere(
      (t) => t.id == transactionId,
      orElse: () => throw Exception('Transaction not found'),
    );

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
      await updateCustomer(customer);
    }

    _transactions.removeWhere((t) => t.id == transactionId);
    await _saveTransactions();
    notifyListeners();
  }
}
