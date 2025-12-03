class GQLQueries {
  static const String getCustomers = r'''
    query GetCustomers {
      customers(order_by: {updated_at: desc}) {
        id
        name
        phone
        address
        total_debt
        last_transaction_date
        created_at
        updated_at
      }
    }
  ''';

  static const String addCustomer = r'''
    mutation AddCustomer($name: String!, $phone: String, $address: String, $total_debt: numeric, $last_transaction_date: timestamptz) {
      insert_customers_one(object: {name: $name, phone: $phone, address: $address, total_debt: $total_debt, last_transaction_date: $last_transaction_date}) {
        id
        name
        phone
        address
        total_debt
        last_transaction_date
      }
    }
  ''';

  static const String updateCustomer = r'''
    mutation UpdateCustomer($id: uuid!, $name: String, $phone: String, $address: String, $total_debt: numeric, $last_transaction_date: timestamptz) {
      update_customers_by_pk(pk_columns: {id: $id}, _set: {name: $name, phone: $phone, address: $address, total_debt: $total_debt, last_transaction_date: $last_transaction_date}) {
        id
        name
        phone
        address
        total_debt
        last_transaction_date
      }
    }
  ''';

  static const String deleteCustomer = r'''
    mutation DeleteCustomer($id: uuid!) {
      delete_customers_by_pk(id: $id) {
        id
      }
    }
  ''';

  static const String getTransactions = r'''
    query GetTransactions {
      transactions(order_by: {date: desc}) {
        id
        customer_id
        amount
        type
        date
        note
        created_at
      }
    }
  ''';

  static const String addTransaction = r'''
    mutation AddTransaction($customer_id: uuid!, $amount: numeric!, $type: String!, $date: timestamptz!, $note: String) {
      insert_transactions_one(object: {customer_id: $customer_id, amount: $amount, type: $type, date: $date, note: $note}) {
        id
        customer_id
        amount
        type
        date
        note
      }
    }
  ''';

  static const String deleteTransaction = r'''
    mutation DeleteTransaction($id: uuid!) {
      delete_transactions_by_pk(id: $id) {
        id
      }
    }
  ''';
}
