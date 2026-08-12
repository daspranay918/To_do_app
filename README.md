# Simple To-Do App

A clean and responsive Flutter To-Do application developed as part of the **Flutter Developer Intern Technical Assignment for BRT Multi Software LLP**.

The application uses local storage for task persistence and does not require any backend or API.

## Features

- Add new tasks
- Mark tasks as completed or uncompleted
- Delete tasks
- Undo deleted tasks
- Filter tasks by All, Active, and Completed
- Optional date and time for tasks
- Empty state when there are no tasks
- Responsive layout
- Subtle UI animations
- Local task persistence

## Tech Stack

- Flutter
- Dart
- Material 3

## Local Storage

The application uses `shared_preferences` to save tasks locally on the device.

No backend, API, Firebase, or database is used.

## Project Structure

```text
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme.dart
│
├── models/
│   └── task_model.dart
│
├── services/
│   └── task_storage.dart
│
├── screens/
│   └── home_screen.dart
│
├── widgets/
│   ├── add_task_bottom_sheet.dart
│   ├── empty_task_view.dart
│   ├── task_input.dart
│   └── task_tile.dart
│
└── main.dart
```

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/daspranay918/To_do_app.git
```

### 2. Open the project

```bash
cd To_do_app
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

### 5. Build the release APK

```bash
flutter build apk --release
```

The generated APK is located at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Flutter Version

- Flutter: **3.41.9**
- Dart: **3.11.5**

## Packages Used

### `shared_preferences`

Used for simple local persistence of task data so tasks remain available after the application is closed and reopened.

### `flutter_lints`

Used as a development dependency for recommended Flutter and Dart code analysis rules.

## Short Questions

### 1. What is the difference between StatelessWidget and StatefulWidget?

A `StatelessWidget` is used when the UI does not need to change, such as a `Text` or `Icon`. It does not store changing data.

A `StatefulWidget` is used when the UI can change. It has a separate `State` object that stores the changing data.

**Example:** `HomeScreen` in this app is a `StatefulWidget` because tasks can be added, completed, and deleted.

### 2. What is setState() used for in Flutter?

`setState()` tells Flutter that some data has changed and the widget needs to rebuild its UI.

**Example:** When a task is completed, `isCompleted` is changed inside `setState()`, so Flutter updates the checkbox and task text.

### 3. What is the difference between ListView and Column?

A `Column` arranges widgets vertically but does not scroll by itself.

A `ListView` is designed for displaying a list of items and provides scrolling. For a large number of tasks, `ListView.builder` can build items efficiently as needed.

### 4. How would you handle an API call in Flutter?

I would keep API-related code in a separate service and use a package such as `http` or `dio` to make the request.

I would use `try-catch` to handle API or network errors and manage **loading, success, and error states** so the UI shows the correct result.

### 5. What is the purpose of pubspec.yaml?

`pubspec.yaml` is the main configuration file of a Flutter project.

It contains project information such as the version, SDK constraints, dependencies, assets, and other configuration. **Example:** `shared_preferences` is added there as a dependency.

### 6. Which Flutter project or feature have you worked on that you are most proud of, and what was your contribution?

I am most proud of my **Eventora** event-management application built with Flutter and Supabase.

I worked on the UI, authentication, event management features, navigation, backend integration, and overall project structure.

## Submission

- **GitHub Repository:** https://github.com/daspranay918/To_do_app
- **APK:** https://drive.google.com/drive/folders/1Mzd4qd5ojMkAbIuCHmXU_qkmi90hf9yO?usp=sharing

The APK is provided in the Google Drive folder for testing.