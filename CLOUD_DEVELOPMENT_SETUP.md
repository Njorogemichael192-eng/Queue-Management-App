# CLOUD FLUTTER DEVELOPMENT & ANDROID BUILD SETUP

## 1. Project Objective

Build the **Queue Management App** exactly according to these existing project documents:

1. `BUILDING_PROMPT.md`
2. `LOGIC_AND_ALGORITHM.md`
3. `TECH_STACK.md`

**These documents are authoritative. Do not change the app requirements, functionality, architecture, database design, or technology choices.**

The app remains:

* Flutter
* Dart
* SQLite
* `sqflite`
* `path`
* Simple offline-first Android application
* No backend
* No Firebase
* No REST API
* No MongoDB
* No PostgreSQL
* No authentication
* No unnecessary dependencies

The purpose of this document is ONLY to define how the project will be developed and built using cloud development tools so that the local Windows laptop does not need the full Android SDK/emulator installation.

---

# 2. Development Environment

Use a **cloud development/build environment**, preferably **GitHub Codespaces**, for:

* Flutter SDK
* Dart SDK
* Android SDK
* Android SDK Platform
* Android Build Tools
* Android Platform Tools
* Gradle/Android build dependencies
* Flutter package installation
* APK generation
* Testing and validation

The developer's Windows laptop should NOT be required to install the full Android SDK or Android Emulator.

The local laptop may only need:

* VS Code
* Git
* GitHub access
* GitHub Copilot

The project source code should remain inside the Git repository/Codespace.

---

# 3. Cloud Environment Requirements

Configure the cloud environment so it provides the following:

### Flutter

Install a stable Flutter SDK.

Verify:

```bash
flutter --version
```

Then:

```bash
dart --version
```

Flutter must be available globally in the terminal.

Verify:

```bash
which flutter
which dart
```

---

# 4. Android SDK

The cloud environment must contain an Android SDK.

Verify:

```bash
flutter doctor -v
```

The Android toolchain should be detected.

Also verify:

```bash
echo $ANDROID_HOME
echo $ANDROID_SDK_ROOT
```

If required, configure the environment variables appropriately.

Typical SDK location may be something such as:

```text
$HOME/android-sdk
```

or:

```text
/opt/android-sdk
```

Do NOT assume a specific location without checking the environment.

---

# 5. Android SDK Components

Install only the components required to build the application.

The cloud environment should have:

* Android SDK Platform
* Android SDK Build-Tools
* Android SDK Platform-Tools
* Android SDK Command-Line Tools
* Android SDK licenses accepted

Use the Android SDK version compatible with the Flutter project.

Do not install unnecessary Android versions or large emulator images unless required.

The project does NOT require an Android Emulator in the cloud.

---

# 6. Android Build Tools

Ensure Android Build Tools are available.

Verify with:

```bash
sdkmanager --list
```

Check that an appropriate Android platform and Build Tools version are installed.

The Flutter project should use the installed compatible Android SDK/build tools.

Do not arbitrarily upgrade versions just because newer versions exist.

Keep the configuration stable and simple.

---

# 7. Flutter Project Setup

If the Flutter project does not yet exist, create it in the cloud workspace:

```bash
flutter create .
```

Only do this if the project has not already been created.

If the Flutter project already exists, DO NOT recreate it.

Preserve all existing project files.

Then run:

```bash
flutter pub get
```

---

# 8. Required Dependencies

The application must remain simple.

Use only the required packages:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite:
  path:
```

Do not add:

* Firebase
* HTTP clients
* REST frameworks
* MongoDB
* PostgreSQL
* Authentication packages
* State-management frameworks unless genuinely necessary
* Networking packages
* Cloud database packages
* Unnecessary UI libraries

The SQLite database must remain local to the Android application.

---

# 9. Project Structure

Maintain the structure defined in the existing project documentation:

```text
lib/
├── main.dart
├── models/
│   └── queue_person.dart
├── database/
│   └── database_helper.dart
├── screens/
│   └── home_screen.dart
└── widgets/
    ├── statistics_card.dart
    ├── queue_person_card.dart
    └── add_person_dialog.dart
```

Do not introduce unnecessary architecture.

The goal is a simple university project that is easy to understand, maintain, demonstrate, and explain.

---

# 10. SQLite Database

SQLite runs inside the Android application.

There is NO separate SQLite server to install.

Use:

```yaml
sqflite
path
```

The database must be created automatically by the application.

Database design must remain exactly as defined in:

```text
LOGIC_AND_ALGORITHM.md
```

Do not change the database schema without a specific reason.

---

# 11. VS Code Workflow

The developer will use VS Code to work with the project.

The preferred workflow is:

```text
Windows Laptop
      |
      | VS Code
      |
      v
GitHub / GitHub Codespace
      |
      +-- Flutter SDK
      +-- Dart SDK
      +-- Android SDK
      +-- Android Build Tools
      +-- Gradle
      |
      v
Flutter Android APK
      |
      v
Physical Android Phone
```

The cloud environment is responsible for Android compilation.

---

# 12. GitHub Codespaces

If GitHub Codespaces is used, configure the development container so that the environment can build Flutter Android applications.

The environment should provide:

```text
Flutter SDK
Dart SDK
Android SDK
Android Build Tools
Android Platform Tools
Java/JDK
Git
```

Before starting development, run:

```bash
flutter doctor -v
```

Resolve only the issues relevant to Android APK development.

Do not install unrelated software.

---

# 13. Do NOT Require an Android Emulator

The project does NOT require an Android Emulator.

Testing can be performed using a physical Android phone.

The cloud environment is primarily responsible for:

* Installing dependencies
* Running Flutter analysis
* Running tests
* Building the APK

The final APK can be downloaded and installed on the physical Android phone.

---

# 14. Development Validation

After setup, run:

```bash
flutter doctor -v
```

Then:

```bash
flutter pub get
```

Then:

```bash
flutter analyze
```

Then:

```bash
flutter test
```

Fix all relevant errors before building the APK.

---

# 15. Build the Android APK

When the application is complete:

```bash
flutter clean
```

Then:

```bash
flutter pub get
```

Then:

```bash
flutter analyze
```

Then:

```bash
flutter test
```

Finally:

```bash
flutter build apk --release
```

The expected APK should be generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Verify that the file exists.

---

# 16. Physical Phone Testing

After generating the APK:

1. Download the APK from the cloud environment.
2. Transfer/install it on the Android phone.
3. Open the application.
4. Test the complete queue workflow.

Test:

### Adding people

* Add one person.
* Add multiple people.
* Verify queue numbers.
* Verify names.
* Verify Waiting status.

### Queue order

Confirm that people are served in FIFO order:

```text
First Added
     ↓
First Served
```

### Serving

Test:

```text
Next Person
```

Confirm:

* Waiting person becomes Served.
* Served timestamp is recorded.
* Waiting count decreases.
* Served count increases.
* Statistics update.

### Empty queue

Press:

```text
Next Person
```

when nobody is waiting.

The application should handle this gracefully.

### Delete Served

Verify that:

* Served people can be deleted.
* Waiting people cannot be deleted through the served-delete function.
* Confirmation is shown before deleting served records.

### Statistics

Verify:

```text
Total
Waiting
Served
Waiting %
Served %
```

Percentages must be calculated dynamically.

### Persistence

Close the application.

Open it again.

Verify that SQLite data is still available.

---

# 17. Important Cloud Storage Rule

Do not unnecessarily download large SDKs, emulator images, or Android system images to the Windows laptop.

The purpose of this setup is to keep the laptop lightweight.

Large development components should remain in the cloud environment.

The local machine should primarily contain:

```text
VS Code
Git
Project source files
```

---

# 18. Git Workflow

Commit the project regularly.

Initial commit:

```bash
git add .
git commit -m "Initial Flutter queue management app"
```

After major completed stages:

```bash
git add .
git commit -m "Implement queue management functionality"
```

and:

```bash
git add .
git commit -m "Complete UI and statistics"
```

Do not commit:

```text
.dart_tool/
build/
*.apk
.env
```

Use `.gitignore` appropriately.

---

# 19. Code Agent Rules

The coding agent must follow these rules:

1. Read `BUILDING_PROMPT.md` first.
2. Read `LOGIC_AND_ALGORITHM.md`.
3. Read `TECH_STACK.md`.
4. Read this `CLOUD_DEVELOPMENT_SETUP.md`.
5. Treat those documents as the project specification.
6. Do not invent additional application functionality.
7. Do not make the application unnecessarily complex.
8. Do not replace SQLite with another database.
9. Do not introduce a backend.
10. Do not add authentication.
11. Do not add cloud synchronization.
12. Do not add unnecessary dependencies.
13. Keep the UI modern and eye-catching but simple.
14. Keep the code understandable for a university student.
15. Build incrementally.
16. Run validation commands after implementation.
17. Fix errors rather than ignoring them.
18. Do not change requirements simply to make implementation easier.

---

# 20. Final Acceptance Condition

The project is considered complete only when:

```text
Flutter environment works
        ↓
Android SDK works
        ↓
Android Build Tools work
        ↓
flutter pub get succeeds
        ↓
flutter analyze succeeds
        ↓
flutter test succeeds
        ↓
flutter build apk --release succeeds
        ↓
APK installs on physical Android phone
        ↓
Queue functionality works
        ↓
SQLite persistence works
        ↓
Statistics work
        ↓
UI is polished
```

The final application must remain the **simple Queue Management App** specified in the other three project documents.

This document only controls the **cloud development and Android build environment**. It does not replace or modify the application's functional specification.
