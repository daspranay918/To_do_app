# Simple To-Do App

A clean and responsive Flutter To-Do application developed as part of the **Flutter Developer Intern Technical Assignment for BRT Multi Software LLP**.

The application uses local storage for task persistence and does not require any backend or API.

## Features

* Add new tasks
* Mark tasks as completed or uncompleted
* Delete tasks
* Undo deleted tasks
* Filter tasks by All, Active, and Completed
* Optional date and time for tasks
* Empty state when there are no tasks
* Responsive layout
* Subtle UI animations
* Local task persistence

## Tech Stack

* Flutter
* Dart
* Material 3

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
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

### 2. Open the project

```bash
cd to_do_app
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

* Flutter: **3.41.9**
* Dart: **3.11.5**

## Packages Used

### shared_preferences

Used for simple local persistence of task data so tasks remain available after the application is closed and reopened.

No other third-party packages were used.

## Short Questions

### 1. What is the difference between StatelessWidget and StatefulWidget?

A `StatelessWidget` does not maintain mutable state and its UI depends on the values provided to it.

A `StatefulWidget` has a separate `State` object and can update its UI when its state changes.

### 2. What is setState() used for in Flutter?

`setState()` is used inside a `StatefulWidget` to notify Flutter that the state has changed.

Flutter then rebuilds the widget so the updated state is reflected in the UI.

### 3. What is the difference between ListView and Column?

`Column` arranges its children vertically but does not provide scrolling by itself.

`ListView` is designed for lists and provides scrolling, making it more suitable for displaying a dynamic collection of items.

### 4. How would you handle an API call in Flutter?

I would keep API-related logic in a separate service or repository and use a package such as `http` or `dio`.

I would handle loading, success, and error states before updating the UI.

### 5. What is the purpose of pubspec.yaml?

`pubspec.yaml` contains the project's configuration, SDK constraints, dependencies, assets, fonts, and other project metadata.

Flutter uses it to manage packages and resources required by the application.

### 6. Which Flutter project or feature have you worked on that you are most proud of, and what was your contribution?

I am most proud of my Eventora event-management application built with Flutter and Supabase.

I contributed to UI development, authentication, event management, navigation, backend integration, and the overall application structure.
