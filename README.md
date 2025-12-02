# 💰 Debt Tracker - Flutter App

A modern, beautiful Flutter application for tracking debts and payments with customers. Built with Material 3 design principles and smooth animations.

## ✨ Features

### 📊 Dashboard
- **Total Debt Overview**: Real-time calculation of all outstanding debts
- **Customer Count**: Quick view of total customers
- **Recent Transactions**: Last 5 transactions with smooth animations
- **Beautiful Gradient Cards**: Eye-catching summary cards with icons

### 👥 Customer Management
- **Enhanced Add Customer Dialog**: 
  - Beautiful gradient header with animated icon
  - Smooth fade & slide animations
  - Modern form fields with icons and validation
  - **Duplicate Name Prevention**: Automatically checks and prevents duplicate customer names
  - **Toast Notifications**: Success/error messages for better UX
  - Loading states during save operations
- **Search Functionality**: Search by name or phone number
- **Customer Details**: View full transaction history per customer
- **Delete Customer**: Remove customers and their associated transactions

### 💸 Transaction Tracking
- **Debt Recording**: Track money owed by customers
- **Payment Recording**: Record payments received
- **Transaction History**: View all transactions with dates and amounts
- **Smart Calculations**: Automatic debt balance updates

### 💾 Data Persistence
- **Local Storage**: All data saved using SharedPreferences
- **Auto-save**: Data automatically persists on every change
- **No Internet Required**: Works completely offline

### 🎨 UI/UX Features
- **Material 3 Design**: Modern, beautiful interface
- **Smooth Animations**: 
  - Fade & slide transitions
  - Hero animations for customer avatars
  - Staggered list animations
- **Gradient Designs**: Eye-catching colors and gradients
- **Responsive Layout**: Works on all screen sizes
- **Dark Theme Ready**: (Can be implemented)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/RyanWez/debt-tracker-flutter.git
   cd debt-tracker-flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

- `provider: ^6.0.0` - State management
- `shared_preferences: ^2.2.0` - Local data persistence
- `intl: ^0.18.0` - Number and date formatting
- `uuid: ^4.0.0` - Unique ID generation
- `fluttertoast: ^8.2.8` - Toast notifications

## 🏗️ Project Structure

```
lib/
├── data/
│   └── models.dart              # Customer & Transaction models
├── providers/
│   └── data_provider.dart       # State management with Provider
├── screens/
│   ├── main_screen.dart         # Bottom navigation
│   ├── dashboard_screen.dart    # Dashboard with summary
│   ├── customer_list_screen.dart # Customer list with search
│   ├── customer_detail_screen.dart # Individual customer details
│   ├── add_transaction_screen.dart # Add debt/payment
│   └── settings_screen.dart     # App settings
└── widgets/
    └── add_customer_dialog.dart # Enhanced customer dialog
```

## 🎯 Features to Implement

- [ ] Data export/import (JSON/CSV)
- [ ] Backup & restore
- [ ] Charts and analytics
- [ ] Customer categories/tags
- [ ] Payment reminders
- [ ] Currency selection
- [ ] Multi-language support (Burmese/English)
- [ ] Dark mode theme
- [ ] Print receipts
- [ ] Transaction notes/images

## 🐛 Known Issues

None currently! 🎉

## 📝 License

This project is licensed under the MIT License.

## 👨‍💻 Author

RyanWez

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

---

Made with ❤️ using Flutter
