import 'package:flutter/material.dart';

class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // All translatable strings
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App Title
      'app_title': 'Debt Tracker',

      // Bottom Navigation
      'nav_dashboard': 'Dashboard',
      'nav_customers': 'Customers',
      'nav_settings': 'Settings',

      // Dashboard Screen
      'total_debt': 'Total Debt',
      'customers': 'Customers',
      'recent_transactions': 'Recent Transactions',
      'no_transactions': 'No transactions yet',

      // Customer List Screen
      'search_hint': 'Search by name or phone',
      'no_customers': 'No customers found',
      'add_customer': 'Add Customer',

      // Customer Detail Screen
      'customer_details': 'Customer Details',
      'add_debt': 'Add Debt',
      'repay': 'Repay',
      'no_transactions_yet': 'No transactions yet',
      'delete_customer': 'Delete Customer',
      'delete_customer_msg':
          'Are you sure? This will delete all transaction history.',
      'cannot_delete': 'Cannot delete customer with outstanding debt: ',

      // Transaction Types
      'debt_added': 'Debt Added',
      'payment_received': 'Payment Received',

      // Add Customer Dialog
      'add_new_customer': 'Add New Customer',
      'edit_customer': 'Edit Customer',
      'customer_name': 'Customer Name',
      'phone_number': 'Phone Number',
      'cancel': 'Cancel',
      'save': 'Save',
      'add': 'Add',
      'name_required': 'Please enter customer name',
      'phone_required': 'Please enter phone number',

      // Add Transaction Screen
      'add_transaction': 'Add Transaction',
      'amount': 'Amount',
      'note': 'Note (Optional)',
      'amount_required': 'Please enter amount',
      'invalid_amount': 'Please enter valid amount',
      'transaction_added': 'Transaction added successfully',

      // Delete Dialog
      'delete': 'Delete',
      'delete_transaction': 'Delete Transaction',
      'delete_transaction_msg':
          'Are you sure you want to delete this transaction?',
      'transaction_deleted': 'Transaction deleted',

      // Settings
      'language': 'Language',
      'myanmar': 'Myanmar',
      'english': 'English',

      // New keys
      'amount_must_be_greater_than_zero': 'Amount must be greater than 0',
      'no_debt_to_repay': 'No debt to repay',
      'payment_cannot_exceed_debt': 'Payment cannot exceed debt: ',
      'date': 'Date',
      'customer_already_exists': 'Customer already exists!',
      'customer_updated_successfully': 'Customer updated successfully!',
      'update_customer_details': 'Update customer details',
      'enter_full_name': 'Enter full name',
      'name_min_length': 'Name must be at least 2 characters',
      'optional': 'Optional',
      'address': 'Address',
      'app_version': 'App Version',
      'fill_in_customer_details': 'Fill in customer details',
      'customer_added_successfully': 'Customer added successfully!',
      'currency_symbol': 'Ks',
      'sort_by': 'Sort by',
      'sort_highest_debt': 'Highest Debt First',
      'sort_lowest_debt': 'Lowest Debt First',
      'sort_name_az': 'Name (A-Z)',
      'sort_recent_activity': 'Recent Activity',

      // Theme
      'theme': 'Theme',
      'system_theme': 'System Default',
      'light_theme': 'Light Mode',
      'dark_theme': 'Dark Mode',
    },
    'my': {
      // App Title
      'app_title': 'အကြွေးစာရင်း',

      // Bottom Navigation
      'nav_dashboard': 'Dashboard',
      'nav_customers': 'Customers',
      'nav_settings': 'Settings',

      // Dashboard Screen
      'total_debt': 'စုစုပေါင်းအကြွေး',
      'customers': 'ဖောက်သည်များ',
      'recent_transactions': 'လတ်တလောမှတ်တမ်းများ',
      'no_transactions': 'မှတ်တမ်းမရှိသေးပါ',

      // Customer List Screen
      'search_hint': 'နာမည် သို့မဟုတ် ဖုန်းနံပါတ်ဖြင့် ရှာပါ',
      'no_customers': 'ဖောက်သည် မတွေ့ပါ',
      'add_customer': 'ဖောက်သည် ထည့်မယ်',

      // Customer Detail Screen
      'customer_details': 'Customer Details',
      'add_debt': 'အကြွေး မှတ်မယ်',
      'repay': 'ပြန်ဆပ်တာ မှတ်မယ်',
      'no_transactions_yet': 'မှတ်တမ်း မရှိသေးပါ',
      'delete_customer': 'ဖောက်သည် ဖျက်မယ်',
      'delete_customer_msg':
          'သေချာပါသလား? စာရင်းများ အားလုံး ပျက်သွားမှာ ဖြစ်ပါတယ်။',
      'cannot_delete': 'အကြွေး ကျန်နေသေးသော ဖောက်သည်ကို ဖျက်၍ မရပါ: ',

      // Transaction Types
      'debt_added': 'အကြွေးယူ',
      'payment_received': 'အကြွေး ရရှိခဲ့',

      // Add Customer Dialog
      'add_new_customer': 'ဖောက်သည်အသစ် ထည့်မယ်',
      'edit_customer': 'ဖောက်သည် ပြင်မယ်',
      'customer_name': 'ဖောက်သည် အမည်',
      'phone_number': 'ဖုန်းနံပါတ်',
      'cancel': 'မလုပ်တော့',
      'save': 'သိမ်းမယ်',
      'add': 'ထည့်မယ်',
      'name_required': 'ဖောက်သည် အမည် ထည့်ပါ',
      'phone_required': 'ဖုန်းနံပါတ် ထည့်ပါ',

      // Add Transaction Screen
      'add_transaction': 'Transaction ထည့်မယ်',
      'amount': 'ပမာဏ',
      'note': 'မှတ်ချက် (ချန်လှပ်နိုင်)',
      'amount_required': 'ပမာဏ ထည့်ပါ',
      'invalid_amount': 'မှန်ကန်သော ပမာဏ ထည့်ပါ',
      'transaction_added': 'Transaction အောင်မြင်စွာ ထည့်ပြီးပါပြီ',

      // Delete Dialog
      'delete': 'ဖျက်မယ်',
      'delete_transaction': 'Transaction ဖျက်မယ်',
      'delete_transaction_msg': 'ဒီ Transaction ကို ဖျက်မှာ သေချာပါသလား?',
      'transaction_deleted': 'Transaction ဖျက်ပြီးပါပြီ',

      // Settings
      'language': 'ဘာသာစကား',
      'myanmar': 'မြန်မာ',
      'english': 'English',

      // New keys
      'amount_must_be_greater_than_zero': 'ပမာဏသည် သုညထက် ကြီးရပါမည်',
      'no_debt_to_repay': 'ပြန်ဆပ်ရန် အကြွေး မရှိပါ',
      'payment_cannot_exceed_debt': 'ပေးချေငွေသည် အကြွေးထက် မများရပါ: ',
      'date': 'နေ့စွဲ',
      'customer_already_exists': 'ဖောက်သည် ရှိပြီးသား ဖြစ်သည်',
      'customer_updated_successfully': 'ဖောက်သည် အချက်အလက် ပြင်ဆင်ပြီးပါပြီ',
      'update_customer_details': 'ဖောက်သည် အချက်အလက်များ ပြင်ဆင်ရန်',
      'enter_full_name': 'နာမည်အပြည့်အစုံ ထည့်ပါ',
      'name_min_length': 'နာမည်သည် အနည်းဆုံး ၂ လုံး ရှိရပါမည်',
      'optional': 'မထည့်သွင်းလည်း ရပါတယ်',
      'address': 'လိပ်စာ',
      'app_version': 'App Version',
      'fill_in_customer_details': 'Customer အချက်အလက်များ ဖြည့်သွင်းပါ',
      'customer_added_successfully': 'Customer အသစ် ထည့်သွင်းပြီးပါပြီ',
      'currency_symbol': 'Ks',
      'sort_by': 'စီစဉ်ရန်',
      'sort_highest_debt': 'အကြွေးအများဆုံး အရင်',
      'sort_lowest_debt': 'အကြွေးအနည်းဆုံး အရင်',
      'sort_name_az': 'အမည် (က-အ)',
      'sort_recent_activity': 'လတ်တလော လှုပ်ရှားမှု',

      // Theme
      'theme': 'အပြင်အဆင်',
      'system_theme': 'စက်၏ မူလပုံစံ',
      'light_theme': 'အလင်း',
      'dark_theme': 'အမှောင်',
    },
  };

  String translate(String key) {
    return _localizedValues[languageCode]![key] ?? key;
  }

  // Shorthand getter
  String get appTitle => translate('app_title');
  String get navDashboard => translate('nav_dashboard');
  String get navCustomers => translate('nav_customers');
  String get navSettings => translate('nav_settings');
  String get totalDebt => translate('total_debt');
  String get customers => translate('customers');
  String get recentTransactions => translate('recent_transactions');
  String get noTransactions => translate('no_transactions');
  String get searchHint => translate('search_hint');
  String get noCustomers => translate('no_customers');
  String get addCustomer => translate('add_customer');
  String get customerDetails => translate('customer_details');
  String get addDebt => translate('add_debt');
  String get repay => translate('repay');
  String get noTransactionsYet => translate('no_transactions_yet');
  String get deleteCustomer => translate('delete_customer');
  String get deleteCustomerMsg => translate('delete_customer_msg');
  String get cannotDelete => translate('cannot_delete');
  String get debtAdded => translate('debt_added');
  String get paymentReceived => translate('payment_received');
  String get addNewCustomer => translate('add_new_customer');
  String get editCustomer => translate('edit_customer');
  String get customerName => translate('customer_name');
  String get phoneNumber => translate('phone_number');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get add => translate('add');
  String get nameRequired => translate('name_required');
  String get phoneRequired => translate('phone_required');
  String get addTransaction => translate('add_transaction');
  String get amount => translate('amount');
  String get note => translate('note');
  String get amountRequired => translate('amount_required');
  String get invalidAmount => translate('invalid_amount');
  String get transactionAdded => translate('transaction_added');
  String get delete => translate('delete');
  String get deleteTransaction => translate('delete_transaction');
  String get deleteTransactionMsg => translate('delete_transaction_msg');
  String get transactionDeleted => translate('transaction_deleted');
  String get language => translate('language');
  String get myanmar => translate('myanmar');
  String get english => translate('english');

  // New keys
  String get amountMustBeGreaterThanZero =>
      translate('amount_must_be_greater_than_zero');
  String get noDebtToRepay => translate('no_debt_to_repay');
  String get paymentCannotExceedDebt => translate('payment_cannot_exceed_debt');
  String get date => translate('date');
  String get customerAlreadyExists => translate('customer_already_exists');
  String get customerUpdatedSuccessfully =>
      translate('customer_updated_successfully');
  String get updateCustomerDetails => translate('update_customer_details');
  String get enterFullName => translate('enter_full_name');
  String get nameMinLength => translate('name_min_length');
  String get optional => translate('optional');
  String get address => translate('address');
  String get appVersion => translate('app_version');
  String get fillInCustomerDetails => translate('fill_in_customer_details');
  String get customerAddedSuccessfully =>
      translate('customer_added_successfully');
  String get currencySymbol => translate('currency_symbol');
  String get sortBy => translate('sort_by');
  String get sortHighestDebt => translate('sort_highest_debt');
  String get sortLowestDebt => translate('sort_lowest_debt');
  String get sortNameAz => translate('sort_name_az');
  String get sortRecentActivity => translate('sort_recent_activity');

  // Theme
  String get theme => translate('theme');
  String get systemTheme => translate('system_theme');
  String get lightTheme => translate('light_theme');
  String get darkTheme => translate('dark_theme');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'my'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale.languageCode);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
