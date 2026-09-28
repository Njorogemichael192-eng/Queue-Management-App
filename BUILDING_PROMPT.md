# Queue Management App — Building Prompt

## 1. Project Objective

Build a simple, polished, offline-first **Queue Management App** using:

* Flutter
* Dart
* SQLite
* `sqflite`
* VS Code
* Git/GitHub

The application is intended as a university software development assignment.

The app must remain **simple**. Do not introduce unnecessary features, external APIs, authentication, cloud services, user accounts, networking, or complicated architecture.

The application must work completely offline after installation.

---

# 2. Core Functionality

The application must provide only the following core functionality:

### A. Add New Person

The user can add a person to the queue.

Required information:

* Person name

When a person is added:

* Generate the next queue number automatically.
* Set status to `Waiting`.
* Store the record in SQLite.
* Place the person at the end of the waiting queue.

Example:

```text
Michael
Queue Number: 001
Status: Waiting
```

---

### B. Show Waiting Queue

Display all people whose status is `Waiting`.

The queue must be ordered by the order in which people were added.

Example:

```text
WAITING

#001  Michael
#002  John
#003  Brian
```

The first waiting person is always the next person to be served.

---

### C. Next Person

Provide a clearly visible **NEXT PERSON** button.

When pressed:

1. Find the first person with status `Waiting`.
2. Change their status to `Served`.
3. Record the time they were served.
4. Refresh the UI.
5. The next waiting person becomes first in the queue.

If nobody is waiting, display an appropriate message instead of performing an operation.

Example:

```text
Before:

#001 Michael — Waiting
#002 John    — Waiting
#003 Brian   — Waiting

NEXT PERSON

After:

#001 Michael — Served
#002 John    — Waiting
#003 Brian   — Waiting
```

---

### D. Delete Served People

Provide a button/action to delete people whose status is `Served`.

Deleting served people must NOT delete waiting people.

The application should ask for confirmation before deleting served records.

---

### E. Statistics

Display live statistics based on the database.

The statistics must include:

* Total people
* Number served
* Number waiting
* Percentage served
* Percentage waiting

Example:

```text
TOTAL
20

SERVED
4
20%

WAITING
16
80%
```

Statistics must update immediately after:

* Adding a person
* Serving the next person
* Deleting served people

Do not permanently store calculated percentages in SQLite.

Calculate them dynamically.

---

# 3. UI/UX Requirements

The application must be simple but visually attractive and professional.

Do NOT create a complicated dashboard.

The UI should feel like a modern mobile queue-management application.

## Design Principles

Use:

* Clean spacing
* Rounded cards
* Clear typography
* Consistent margins
* Appropriate icons
* Clear visual hierarchy
* Subtle shadows/elevation
* Smooth but minimal animations
* Good contrast
* Responsive layouts

Avoid:

* Excessive colors
* Excessive animations
* Clutter
* Tiny text
* Unnecessary screens
* Complicated navigation

---

# 4. Suggested Main Screen

The main screen should contain:

```text
------------------------------------------------

              QUEUE MANAGER

     Manage your waiting queue

------------------------------------------------

   TOTAL        SERVED        WAITING

     20           4             16
                 20%            80%

------------------------------------------------

              NOW SERVING

                 #004

             Michael

------------------------------------------------

              WAITING QUEUE

      #005  John
      #006  Brian
      #007  Peter

------------------------------------------------

             + ADD PERSON

------------------------------------------------

             NEXT PERSON

------------------------------------------------

          DELETE SERVED PEOPLE

------------------------------------------------
```

The exact visual implementation is up to the agent, but the information and functionality must remain simple.

---

# 5. Add Person UI

Use a simple dialog, bottom sheet, or dedicated form.

Required field:

```text
Person Name
```

Buttons:

```text
CANCEL
ADD PERSON
```

Validation:

* Name cannot be empty.
* Trim unnecessary whitespace.
* Do not accept a blank name.
* Show a clear validation message.

After successful addition:

* Save to SQLite.
* Close the form.
* Refresh statistics.
* Refresh waiting queue.

---

# 6. Queue Cards

Each person should be displayed in a clean card.

Waiting example:

```text
┌────────────────────────────┐
│ #005                       │
│ John Kamau                 │
│ Waiting                    │
└────────────────────────────┘
```

Served example:

```text
┌────────────────────────────┐
│ #004                       │
│ Michael                    │
│ Served                     │
└────────────────────────────┘
```

Use visual differences between Waiting and Served states while maintaining a consistent design.

---

# 7. Database

Use SQLite through the `sqflite` package.

Use a single table:

```sql
queue_person
```

Fields:

```text
id
name
queueNumber
status
createdAt
servedAt
```

Suggested SQLite types:

```text
id          INTEGER PRIMARY KEY AUTOINCREMENT
name        TEXT NOT NULL
queueNumber INTEGER NOT NULL
status      TEXT NOT NULL
createdAt   TEXT NOT NULL
servedAt    TEXT
```

Valid statuses:

```text
Waiting
Served
```

Do not create unnecessary tables.

---

# 8. Database Rules

Create a dedicated database helper/service.

It should provide operations for:

```text
initialize database
add person
get waiting people
get all people
serve next person
delete served people
get statistics
```

Use parameterized SQLite queries.

Do not construct unsafe SQL strings using raw user input.

---

# 9. Queue Number Rules

Queue numbers must be generated automatically.

The first person should receive:

```text
001
```

Then:

```text
002
003
004
...
```

The displayed queue number should use three digits.

Examples:

```text
001
009
010
025
100
```

Do not ask the user to enter the queue number.

Queue numbers must be generated by the application.

---

# 10. "Now Serving"

The UI should clearly show the most recently served person.

Example:

```text
NOW SERVING

#005
John Kamau
```

If nobody has been served yet:

```text
NOW SERVING

No one served yet
```

This information can be derived from the most recently served record.

---

# 11. Statistics Algorithm

Calculate:

```text
total = served + waiting
```

Then:

```text
servedPercentage =
(served / total) × 100

waitingPercentage =
(waiting / total) × 100
```

If:

```text
total = 0
```

both percentages must be:

```text
0%
```

Round percentages to a sensible whole number or one decimal place.

Example:

```text
Total = 10
Served = 3
Waiting = 7

Served = 30%
Waiting = 70%
```

---

# 12. Application State

The UI must always reflect the current SQLite data.

After every database-changing operation:

```text
Database update
      ↓
Reload data
      ↓
Recalculate statistics
      ↓
Refresh UI
```

Do not rely only on temporary in-memory lists.

SQLite is the source of truth.

---

# 13. Error Handling

Handle:

* Empty names
* Database initialization errors
* Database insert errors
* Database update errors
* Database deletion errors
* No waiting people
* No served people

Display user-friendly messages.

Do not expose raw SQL/database errors directly to the user.

---

# 14. Navigation

Keep navigation minimal.

Prefer a single main screen with dialogs/bottom sheets where possible.

Do NOT create multiple unnecessary pages.

The application should feel fast and simple.

---

# 15. Architecture

Use a simple architecture appropriate for a small student application.

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

Do not introduce heavy architecture or state-management packages unless genuinely necessary.

For this project, simple Flutter state management is acceptable.

---

# 16. Dependencies

Keep dependencies minimal.

Required:

```text
flutter
sqflite
path
```

Do not add packages merely for convenience if Flutter's built-in functionality can handle the requirement.

---

# 17. Offline Requirement

The application must work without:

* Internet
* Backend server
* Firebase
* MongoDB
* REST API
* External database server

All queue data must remain locally available through SQLite.

---

# 18. Testing Requirements

Before considering the application complete, test:

### Add

* Add one person.
* Add multiple people.
* Verify queue numbers.

### Queue

* Verify people appear in insertion order.
* Verify waiting status.

### Next Person

* Serve the first waiting person.
* Verify their status changes to Served.
* Verify the next person becomes first.

### Empty Queue

Press NEXT PERSON when nobody is waiting.

The application must not crash.

### Delete

* Delete served people.
* Verify waiting people remain.

### Statistics

Verify:

```text
Total = Served + Waiting
```

Verify percentages.

Test:

```text
0 people
1 person
multiple people
all waiting
all served
```

### Persistence

Close the application completely.

Open it again.

Verify that SQLite data remains.

---

# 19. Build and Deployment

The application must be prepared for Android deployment.

Before building:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

If all checks pass, generate the release APK.

The release APK should be located under:

```text
build/app/outputs/flutter-apk/
```

Do not consider the project complete until the release APK builds successfully.

Also verify that the release APK can be installed and the application works correctly on an Android device.

---

# 20. Git Requirements

Initialize Git if necessary.

Use a `.gitignore` appropriate for Flutter.

Do NOT commit:

```text
.dart_tool/
build/
*.apk
.env
IDE temporary files
```

Use clear commits such as:

```text
Initial Flutter project
Add SQLite database
Implement queue operations
Add statistics
Build UI
Add validation
Prepare Android release
```

---

# 21. Code Quality

The code must:

* Be readable.
* Use meaningful names.
* Avoid unnecessary duplication.
* Avoid giant files where practical.
* Contain useful comments only where necessary.
* Follow Dart/Flutter conventions.
* Avoid unused imports and variables.
* Pass `flutter analyze`.

Do not over-engineer the application.

---

# 22. Important Scope Rule

This project must remain SIMPLE.

Do NOT add:

* Login
* Registration
* User accounts
* Cloud synchronization
* Firebase
* REST APIs
* Online authentication
* Notifications
* Payments
* Maps
* Chat
* AI
* Multiple branches
* Multi-device synchronization
* Admin dashboards
* Complex reports
* Unrequested features

Only implement the requirements in this document.

---

# 23. Completion Criteria

The project is complete only when:

* Flutter application runs.
* SQLite database works.
* Person can be added.
* Queue numbers are automatic.
* Waiting people are displayed.
* Next person can be served.
* Served status is recorded.
* Served people can be deleted.
* Statistics work.
* Percentages work.
* Data persists after restarting the application.
* UI is polished and responsive.
* `flutter analyze` passes.
* Tests pass.
* Release APK builds successfully.
* Release APK has been tested on an Android device.

Build the application incrementally and verify each major feature before moving to the next one.
