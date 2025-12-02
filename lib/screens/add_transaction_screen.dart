import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../data/models.dart';
import '../providers/data_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final String customerId;
  final String type; // 'debt' or 'payment'

  const AddTransactionScreen({
    super.key,
    required this.customerId,
    required this.type,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final newTransaction = Transaction(
        id: const Uuid().v4(),
        customerId: widget.customerId,
        amount: double.parse(_amountController.text),
        type: widget.type,
        date: _selectedDate,
        note: _noteController.text,
      );

      Provider.of<DataProvider>(
        context,
        listen: false,
      ).addTransaction(newTransaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDebt = widget.type == 'debt';
    return Scaffold(
      appBar: AppBar(
        title: Text(isDebt ? 'Add Debt' : 'Add Payment'),
        backgroundColor: isDebt ? Colors.red.shade100 : Colors.green.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: 'Ks',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Please enter a valid number';
                  }
                  if (amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  
                  // For payment, check if it exceeds total debt
                  if (widget.type == 'payment') {
                    final dataProvider = Provider.of<DataProvider>(
                      context,
                      listen: false,
                    );
                    final customer = dataProvider.customers.firstWhere(
                      (c) => c.id == widget.customerId,
                    );
                    
                    if (customer.totalDebt <= 0) {
                      return 'No debt to repay';
                    }
                    
                    if (amount > customer.totalDebt) {
                      return 'Payment cannot exceed debt: ${NumberFormat("#,##0", "en_US").format(customer.totalDebt)} Ks';
                    }
                  }
                  
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveTransaction,
                  style: FilledButton.styleFrom(
                    backgroundColor: isDebt ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Save', style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
