# Queue Management App — Technology Stack

## 1. Project Overview

A small offline-first mobile queue management application.

The application allows a user to:

* Add people.
* View waiting people.
* Serve the next person.
* Delete served people.
* View queue statistics.
* View served and waiting percentages.

The application will be deployed as an Android application.

---

# 2. Core Technology

## Flutter

Framework:

```text
Flutter
```

Purpose:

* Build the Android user interface.
* Manage screens and widgets.
* Handle user interaction.
* Build the release APK.

---

## Dart

Programming language:

```text
Dart
```

Purpose:

* Application logic.
* Database operations.
* Models.
* Statistics calculations.
* UI state management.

---

# 3. Database

## SQLite

Database:

```text
SQLite
```

Purpose:

* Store queue records locally.
* Provide persistent offline storage.
* Eliminate the need for a backend.

The database is stored locally on the device running the application.

There is no remote database.

---

# 4. SQLite Flutter Package

Use:

```text
sqflite
```

Purpose:

* Create/open the SQLite database.
* Execute SQL queries.
* Insert records.
* Update records.
* Delete records.
* Query records.

---

# 5. Database Path Package

Use:

```text
path
```

Purpose:

Construct the platform-safe database file path.

The application should use the standard application database directory.

---

# 6. Dependencies

Keep dependencies minimal.

Required:

```yaml
dependencies:
  flutter:
    sdk: flutter

  sqflite: ^latest-compatible-version
  path: ^latest-compatible-version
```

The coding agent must select versions compatible with the installed Flutter SDK rather than blindly using incompatible versions.

Do not add unnecessary packages.

---

# 7. Architecture

Use a lightweight architecture.

Suggested structure:

```text
lib/
│
├── main.dart
│
├── models/
│   └── queue_person.dart
│
├── database/
│   └── database_helper.dart
│
├── screens/
│   └── home_screen.dart
│
└── widgets/
    ├── statistics_card.dart
    ├── queue_person_card.dart
    └── add_person_dialog.dart
```

This project does not require:

* Clean Architecture
* BLoC
* Riverpod
* Provider
* Redux
* Dependency injection frameworks

unless the agent determines a minimal package is genuinely required.

Prefer Flutter's built-in state-management capabilities for this small application.

---

# 8. Data Model

SQLite table:

```text
queue_person
```

Schema:

```sql
CREATE TABLE queue_person (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    queueNumber INTEGER NOT NULL,
    status TEXT NOT NULL,
    createdAt TEXT NOT NULL,
    servedAt TEXT
);
```

Valid status values:

```text
Waiting
Served
```

---

# 9. Database Operations

The database helper should expose simple operations for:

```text
insertPerson()
getWaitingPeople()
getAllPeople()
getNextWaitingPerson()
servePerson()
getLastServedPerson()
deleteServedPeople()
getStatistics()
```

Keep database logic out of UI widgets.

---

# 10. UI Technology

Use Flutter's built-in Material components.

Recommended:

```text
MaterialApp
Scaffold
AppBar
Card
Container
Column
Row
ListView
FloatingActionButton
AlertDialog
TextField
ElevatedButton
OutlinedButton
Icon
CircularProgressIndicator
SnackBar
```

Use modern Material styling where appropriate.

---

# 11. UI Design

The interface should be:

* Modern
* Clean
* Eye-catching
* Responsive
* Easy to understand
* Suitable for a university project demonstration

Use a consistent design system for:

* Colors
* Border radius
* Typography
* Spacing
* Buttons
* Cards
* Icons

Avoid visual clutter.

The main screen should prioritize:

```text
Statistics
    ↓
Now Serving
    ↓
Waiting Queue
    ↓
Actions
```

---

# 12. Application Screens

Keep the number of screens minimal.

Primary screen:

```text
Home / Queue Dashboard
```

Use dialogs or bottom sheets for adding people and confirmations rather than creating unnecessary pages.

---

# 13. Offline Architecture

The application follows:

```text
Flutter UI
     ↓
Dart Application Logic
     ↓
SQLite
     ↓
Local Device Storage
```

There is no:

```text
Internet
Backend
REST API
Firebase
MongoDB
PostgreSQL
Cloud database
```

required for the application.

---

# 14. Development Environment

Recommended development environment:

```text
VS Code
Flutter SDK
Dart SDK
Android SDK
Android Emulator or physical Android device
Git
GitHub
GitHub Copilot
```

The coding agent should verify the environment before implementation.

Run:

```bash
flutter doctor
```

Then resolve any critical Flutter/Android setup issues before development.

---

# 15. Project Creation

Create the project using:

```bash
flutter create queue_management_app
```

Enter the project:

```bash
cd queue_management_app
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

# 16. Development Commands

Check Flutter environment:

```bash
flutter doctor
```

Check project dependencies:

```bash
flutter pub get
```

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Run application:

```bash
flutter run
```

Clean generated files:

```bash
flutter clean
```

Reinstall dependencies:

```bash
flutter pub get
```

---

# 17. Testing

At minimum verify:

```text
Add person
Queue number generation
Waiting list
Next person
Served status
Delete served
Statistics
Percentages
Database persistence
Empty queue handling
Input validation
```

Test on an actual Android device before deployment when possible.

---

# 18. Android Release Build

Before creating the release APK:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

Then:

```bash
flutter build apk --release
```

Expected output location:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The APK should be installed and tested on an Android device.

---

# 19. Deployment

The initial deployment target is:

```text
Android APK
```

The application must work independently after installation.

The user's laptop does not need to remain powered on.

The SQLite database belongs to the installed application on the device.

---

# 20. Database Deployment Behavior

Important:

SQLite is local to each installed application.

For example:

```text
Laptop development database
        ≠
Phone database
```

When the APK is installed on a phone:

```text
Phone
 ├── Flutter Application
 └── SQLite Database
```

The phone's application accesses its own local database.

No laptop or server is required after installation.

---

# 21. Data Limitation

Because SQLite is local:

```text
Phone A
    ↓
Database A

Phone B
    ↓
Database B
```

Data is not automatically shared between devices.

This is intentional because the project is designed as a simple offline queue application.

---

# 22. Git

Use Git for source-code version control.

Recommended initial commands:

```bash
git init
git add .
git commit -m "Initial Flutter queue management app"
```

Connect the repository to GitHub as required.

Do not commit generated build files or unnecessary local files.

---

# 23. Release Checklist

Before declaring the project complete:

```text
[ ] Flutter project builds
[ ] SQLite initializes
[ ] Person can be added
[ ] Queue numbers are generated
[ ] Waiting queue works
[ ] Next person works
[ ] Served status works
[ ] Served people can be deleted
[ ] Statistics work
[ ] Percentages work
[ ] Data persists after restart
[ ] Empty states work
[ ] Input validation works
[ ] UI is polished
[ ] flutter analyze passes
[ ] flutter test passes
[ ] Release APK builds
[ ] APK installs successfully
[ ] APK tested on Android
[ ] Git repository is clean
```

---

# 24. Scope Control

The technology stack must remain intentionally small.

Do not introduce additional infrastructure unless explicitly requested.

The final stack should remain approximately:

```text
Flutter
   +
Dart
   +
SQLite
   +
sqflite
   +
path
   +
VS Code
   +
Git/GitHub
   +
GitHub Copilot
```

No backend is required.

No internet connection is required.

No cloud database is required.
