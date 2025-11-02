# 💰 Expense Tracker App - Flutter

A comprehensive offline expense tracking application built with Flutter and Dart, featuring local data persistence, beautiful charts, and support for light/dark themes.

## 📱 Features

### Core Functionality
- ✅ **Add Expenses** - Create new expense records with title, amount, date, and category
- ✅ **Edit Expenses** - Modify existing expense entries
- ✅ **Delete Expenses** - Remove expense records with confirmation
- ✅ **View Expenses** - Display all expenses in an organized list view
- ✅ **Real-time Search** - Filter expenses by category and date range

### Analytics & Visualization
- 📊 **Pie Charts** - Visual breakdown of spending by category
- 📈 **Category Summary** - Total spending per category
- 💹 **Statistics** - Total spent, transaction count, and category count
- 🎯 **Visual Indicators** - Color-coded categories with icons

### Data Management
- 💾 **Local Storage** - All data stored locally using Hive database
- 📅 **Date Tracking** - Track expenses with precise timestamps
- 🏷️ **Categories** - Pre-defined categories: Food & Dining, Transportation, Shopping, Entertainment, Bills & Utilities, Healthcare, Education, Travel, and Other
- 🔄 **Data Sync** - Automatic data synchronization on changes

### UI/UX
- 🌓 **Dark/Light Mode** - Beautiful Material Design 3 themed application
- 📱 **Responsive Design** - Adaptive UI for different screen sizes
- ⚡ **Smooth Animations** - Fluid transitions and interactions
- 🎨 **Color-Coded** - Category-specific colors for quick recognition
- 📑 **Tab Navigation** - Easy switching between Expenses list and Analytics

## 🏗️ Technical Architecture

### Framework & Language
- **Flutter** - Cross-platform mobile development framework
- **Dart** - Programming language for Flutter

### Key Technologies
| Component | Package | Version | Purpose |
|-----------|---------|---------|---------|
| State Management | Provider | ^6.1.2 | Efficient state management with ChangeNotifier |
| Local Database | Hive | ^2.2.3 | Fast, lightweight local database |
| Database Integration | hive_flutter | ^1.1.0 | Flutter integration for Hive |
| Data Visualization | fl_chart | ^0.72.0 | Beautiful and interactive charts |
| Date Formatting | intl | ^0.20.1 | Internationalization and date formatting |
| ID Generation | uuid | ^4.0.0 | Unique identifier generation |

### Architecture Pattern
- **Model-View-Provider (MVP)** - Clean separation of concerns
- **Provider Pattern** - Reactive state management
- **Local First** - All data persisted locally for offline access

### Data Model
```dart
class Expense {
  String id;           // Unique identifier (UUID v4)
  String title;        // Expense title/description
  double amount;       // Amount spent
  DateTime date;       // Date and time of expense
  String category;     // Expense category
}
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or newer)
- Dart SDK (included with Flutter)
- Android Studio, Xcode, or VS Code with Flutter extension
- Android Emulator, iOS Simulator, or physical device

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/bichle04/notes-app-flutter.git
cd notes-app-flutter
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate Hive adapters:**
```bash
flutter pub run build_runner build
```

4. **Run the app:**

#### On Android Emulator/Device:
```bash
flutter run
```

#### On Web:
```bash
flutter run -d chrome
```

#### On Windows Desktop:
```bash
flutter run -d windows
```

#### With Release Mode:
```bash
flutter run --release
```

## 📖 Usage Guide

### Adding an Expense
1. Tap the **+** (FloatingActionButton) button at the bottom right
2. Enter the expense **Title**
3. Enter the **Amount** spent
4. Select the **Category** from dropdown
5. Choose the **Date** using the date picker
6. Tap **Add** to save

### Viewing & Editing
- Expenses are displayed in a **chronological list** (newest first)
- Each expense card shows:
  - Category icon and name
  - Amount and date/time
  - Quick action menu
- Tap the **menu icon** (three dots) to:
  - **Edit** - Modify the expense
  - **Delete** - Remove the expense

### Analytics Dashboard
- Switch to **Analytics** tab to view spending summary
- See **pie chart** breakdown by category
- View **total spent** amount
- Check **transaction count** and **category count**
- Category totals displayed in detail below the chart

### Theme Switching
- Light theme (default) - Clean, bright interface
- Dark theme - Comfortable for low-light environments
- Switch via system settings (follows device theme)

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point, Hive initialization
├── models/
│   └── expense.dart                   # Expense model with @HiveType annotation
├── providers/
│   └── expense_provider.dart          # State management with ChangeNotifier
├── screens/
│   ├── home_screen.dart              # Main screen with tabs
│   └── add_edit_expense_screen.dart   # Form for adding/editing expenses
├── widgets/
│   └── expense_chart.dart            # Charts and analytics widget
└── theme/
    └── app_themes.dart               # Light and dark theme definitions
```

## 🎯 Key Implementation Details

### State Management
```dart
// ExpenseProvider extends ChangeNotifier
- addExpense()      // Add new expense
- updateExpense()   // Update existing expense
- deleteExpense()   // Delete expense
- getTotalByCategory() // Get category breakdown
- getExpensesByDateRange() // Filter by date
```

### Local Storage
```dart
// Hive configuration in main.dart
Hive.initFlutter()              // Initialize Hive
Hive.registerAdapter()          // Register Expense adapter
expenseProvider.init()          // Load expenses from box
```

### Charts
```dart
// PieChart for category distribution
// Displays percentage, category name, and amount
// Color-coded for easy identification
```

## 🎨 UI Components

### Widgets Used
- `Scaffold` - Main app structure
- `TabBar` - Navigation between Expenses and Analytics
- `ListView.builder` - Efficient expense list rendering
- `Card` - Expense item containers
- `FloatingActionButton` - Add expense button
- `TextField` - Input fields
- `DropdownButton` - Category selection
- `PieChart` - Visual breakdown
- `AlertDialog` - Delete confirmation
- `PopupMenuButton` - Item actions

### Theme Features
- Material Design 3 color schemes
- Adaptive colors for light/dark modes
- Custom input decoration
- Consistent spacing and padding
- Rounded corners and shadows

## 🏗️ Build Instructions

### Debug Build
```bash
flutter build apk --debug
flutter build ios
flutter build web
```

### Release Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle (Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

## 📊 Database Schema

### Hive Box: 'expenses'
- **Type ID**: 0 (Expense class)
- **Field 0 (id)**: String - UUID v4 unique identifier
- **Field 1 (title)**: String - Expense description
- **Field 2 (amount)**: double - Amount spent
- **Field 3 (date)**: DateTime - Expense timestamp
- **Field 4 (category)**: String - Category name

## 🐛 Troubleshooting

### Common Issues

**Issue: Hive adapter not generated**
```bash
# Solution: Run build_runner
flutter pub run build_runner build --delete-conflicting-outputs
```

**Issue: Charts not rendering**
- Ensure `flutter pub get` completed successfully
- Check that `fl_chart` is properly installed
- Verify expenses exist in the list

**Issue: App crashes on launch**
- Delete app data: `flutter clean`
- Clear Hive box: Delete app from device and reinstall
- Check Logcat/console for detailed error messages

**Issue: Dark mode not switching**
- Restart the app after changing system theme
- Or manually set theme in app settings

## ✨ Future Enhancements

- 🔐 **Encryption** - Add PIN/Biometric security
- 📤 **Export** - Export expenses to CSV/PDF
- 📧 **Notifications** - Budget reminders and alerts
- 💰 **Budget Goals** - Set spending targets by category
- 📱 **Sync** - Cloud backup with Firebase
- 🤖 **Smart Categorization** - AI-powered category suggestions
- 📈 **Advanced Analytics** - Monthly trends, spending comparisons
- 🔔 **Recurring Expenses** - Set up automatic recurring expenses
- 📍 **Location Tracking** - Track where expenses were made

## 📝 License

This project is licensed under the MIT License - see LICENSE file for details.


## 📚 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language](https://dart.dev)
- [Hive Database](https://docs.hivedb.dev/)
- [Provider Pattern](https://pub.dev/packages/provider)
- [fl_chart Documentation](https://github.com/imaNNeoFighT/fl_chart)

**Built with ❤️ using Flutter**
