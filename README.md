# 📝 Flutter Notes App

A modern, intuitive note-taking application built with Flutter and SQLite. Create, edit, organize, and manage your notes with a clean, user-friendly interface.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)

## ✨ Features

- **📱 Cross-Platform**: Runs on both Android and iOS
- **💾 Local Storage**: All notes stored locally using SQLite database
- **🎨 Color Coding**: Organize notes with custom color labels
- **✏️ Full CRUD Operations**: Create, Read, Update, and Delete notes
- **🔍 Clean UI**: Material Design with intuitive navigation
- **⚡ Fast Performance**: Optimized database operations with proper indexing
- **🛡️ Input Validation**: Form validation to ensure data integrity
- **🔄 Real-time Updates**: Instant UI refresh after operations

## 📱 Screenshots

> Add screenshots of your app here

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 2.18.0)
- Android Studio / VS Code
- Android SDK / iOS SDK (for device testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter-notes-app.git
   cd flutter-notes-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart              # App entry point
├── MyHomePage.dart        # Home screen with notes list
├── addNote.dart           # Add new note screen
├── edit.dart              # Edit existing note screen
└── sqldb.dart            # Database helper class
```

## 🗄️ Database Schema

The app uses SQLite with the following table structure:

```sql
CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    note TEXT NOT NULL,
    color TEXT DEFAULT 'blue'
);
```

## 📋 Core Functionality

### Home Screen
- Display all notes in a scrollable list
- Color-coded note indicators
- Quick access to add, edit, and delete operations
- Empty state when no notes exist

### Add Note
- Create new notes with title, content, and color
- Form validation for required fields
- Loading states for better UX

### Edit Note
- Modify existing note content
- Pre-populated fields with current data
- Safe update operations with SQL injection prevention

### Database Operations
- **Create**: Add new notes with parameterized queries
- **Read**: Fetch all notes with proper error handling
- **Update**: Modify existing notes safely
- **Delete**: Remove notes with confirmation dialogs

## 🛠️ Technical Implementation

### Database Helper (`SqlDb`)
```dart
class SqlDb {
  // Singleton pattern for database instance
  static Database? _db;
  
  // Safe CRUD operations
  Future<int> insertNote({required String note, String? title, String? color});
  Future<int> updateNote({required int id, required String note, String? title, String? color});
  Future<List<Map>> readData(String sql);
  Future<int> deleteData(String sql);
}
```

### Key Features Implementation

**Form Validation**
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a title';
  }
  return null;
}
```

**Loading States**
```dart
onPressed: isLoading ? null : () async {
  setState(() => isLoading = true);
  // Perform operation
  setState(() => isLoading = false);
}
```

**Safe Navigation**
```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => AddNotePage()),
).then((_) => setState(() {})); // Refresh on return
```

## 🔒 Security Features

- **SQL Injection Prevention**: Parameterized queries for all database operations
- **Input Validation**: Client-side validation for all form inputs
- **Error Handling**: Comprehensive try-catch blocks for database operations

## 🎨 UI/UX Features

- **Material Design**: Consistent design following Material Design guidelines
- **Responsive Layout**: Adapts to different screen sizes
- **Loading Indicators**: Visual feedback during operations
- **Confirmation Dialogs**: Prevent accidental data loss
- **Snackbar Notifications**: User feedback for operations

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0      # SQLite database
  path: ^1.8.3         # Path manipulation

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🧪 Testing

Run the test suite:
```bash
flutter test
```

## 📱 Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow the existing code style and structure
- Add comments for complex logic
- Test your changes thoroughly
- Update documentation as needed

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@Yasserashraf1](https://github.com/Yasserashraf1)
- LinkedIn: [Yasser Ashraf](https://www.linkedin.com/in/yasserashraf/)
- Email: yasserashraf@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- SQLite for robust local database solution
- Material Design for UI guidelines
- Flutter community for helpful resources

## 📈 Version History

- **v1.0.0** - Initial release with basic CRUD operations
- **v1.1.0** - Added color coding and improved UI
- **v1.2.0** - Enhanced error handling and validation

📧 **Have questions or suggestions? Feel free to open an issue or contact me directly.**
