class Transaction {
  final String id;
  final String customerId;
  final double amount;
  final String type; // 'debt' or 'payment'
  final DateTime date;
  final String? note;

  Transaction({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      customerId: json['customerId'],
      amount: json['amount'],
      type: json['type'],
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String phone;
  final String address;
  double totalDebt;
  DateTime lastTransactionDate;

  Customer({
    required this.id,
    required this.name,
    this.phone = '',
    this.address = '',
    this.totalDebt = 0.0,
    required this.lastTransactionDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'totalDebt': totalDebt,
      'lastTransactionDate': lastTransactionDate.toIso8601String(),
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      totalDebt: json['totalDebt'],
      lastTransactionDate: DateTime.parse(json['lastTransactionDate']),
    );
  }
}
