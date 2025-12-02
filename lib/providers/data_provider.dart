import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models.dart';

class DataProvider with ChangeNotifier {
  List<Customer> _customers = [];
  List<Transaction> _transactions = [];

  List<Customer> get customers => _customers;
  List<Transaction> get transactions => _transactions;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final customersString = prefs.getString('customers');
    final transactionsString = prefs.getString('transactions');

    if (customersString != null) {
      final List<dynamic> jsonList = jsonDecode(customersString);
      _customers = jsonList.map((e) => Customer.fromJson(e)).toList();
    }

    if (transactionsString != null) {
      final List<dynamic> jsonList = jsonDecode(transactionsString);
      _transactions = jsonList.map((e) => Transaction.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final customersString = jsonEncode(
      _customers.map((e) => e.toJson()).toList(),
    );
    final transactionsString = jsonEncode(
      _transactions.map((e) => e.toJson()).toList(),
    );

    await prefs.setString('customers', customersString);
    await prefs.setString('transactions', transactionsString);
  }

  void addCustomer(Customer customer) {
    _customers.add(customer);
    saveData();
    notifyListeners();
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);

    // Update customer debt
    final customerIndex = _customers.indexWhere(
      (c) => c.id == transaction.customerId,
    );
    if (customerIndex != -1) {
      if (transaction.type == 'debt') {
        _customers[customerIndex].totalDebt += transaction.amount;
      } else {
        _customers[customerIndex].totalDebt -= transaction.amount;
      }
      _customers[customerIndex].lastTransactionDate = transaction.date;
    }

    saveData();
    notifyListeners();
  }

  void deleteCustomer(String id) {
    _customers.removeWhere((c) => c.id == id);
    _transactions.removeWhere((t) => t.customerId == id);
    saveData();
    notifyListeners();
  }
}
