
# 🗂️ Flutter Task Manager App

A modern, **offline-first** task management app built with Flutter.  
Supports local storage with **ObjectBox** and **sqflite**, cloud sync with **Firebase**, and a responsive UI powered by **Provider** state management.

---

## 🚀 Features

- Create, edit, delete tasks
- Offline-first storage with ObjectBox
- Cloud sync with Firebase Firestore
- Priority-based wave animation for tasks
- Deadline reminders and overdue indicators
- Export/Import with SQLite
- Persistent user settings with SharedPreferences
- Animated summary cards

---

## 📁 Folder Structure

```
lib/
├── core/                  # Constants, utils, shared config
├── data/                 
│   ├── controller/        # Provider-based controllers (logic)
│   ├── local/             # ObjectBox helpers and setup
│   ├── remote/            # Firebase sync methods
│   └── task_model/        # TaskModel definition
├── presentation/
│   ├── operation_screens/ # Create & update task screens
│   ├── screens/           # Main screens (Home, All Tasks)
│   └── widgets/           # UI components (cards, buttons)
└── main.dart              # App entry point
```

---

## ✅ How to Run Locally

### 1. ⚙️ Prerequisites
- Flutter SDK (latest stable)
- Android Studio or VS Code
- Firebase project setup (Firestore enabled)

### 2. 🛠️ Setup Instructions

```bash
# 1. Clone this repository
git clone https://github.com/sala1020/task_management.git
cd task-manager

# 2. Install dependencies
flutter pub get

# 3. Generate ObjectBox bindings
flutter pub run build_runner build

# 4. Connect Firebase
# - Create Firebase project from console
# - Download `google-services.json` into android/app/
# - Ensure Firebase is initialized in main.dart

# 5. Run the app
flutter run
```

---

## 🏗️ Architecture Overview

The app uses a **clean architecture-inspired** modular approach:

### ➤ `presentation/`
UI layer (screens, widgets) using **Provider** for state consumption.

### ➤ `data/`
Handles:
- `controller/`: All state logic via `ChangeNotifier`
- `local/`: Local DB via **ObjectBox**
- `remote/`: Firebase Firestore sync functions
- `task_model/`: Task entity annotated with `@Entity` for ObjectBox

### ➤ `core/`
Shared constants, utils, themes (e.g., date utils, colors).

---

## 📦 Dependencies

| Package                | Purpose                            |
|------------------------|------------------------------------|
| **objectbox**          | High-performance local database    |
| **cloud_firestore**    | Remote sync and backup             |
| **provider**           | State management                   |
| **wave**               | Animated progress visuals          |
| **fluttertoast**       | Toast notifications                |
| **connectivity_plus**  | Internet availability checking     |
| **intl**               | Date formatting                    |
| **sqflite**            | Export/import tasks                |
| **shared_preferences** | Persistent user settings           |

---

## ☁️ Offline-First Design

This app prioritizes local-first experience:

- Tasks are stored in **ObjectBox** instantly.
- Sync to **Firebase Firestore** happens Automatically (According to the internet availability).
- Works fully offline — cloud is optional.

### Sync Flow:
1. User adds or edits a task → saved locally.
2. User taps sync → all completed task pushed From Firestore.
3. The Completed task automatically get into the firebase firestore.

---

## 📱 Screenshots

![HomeScreen]( assets\screenshot\home\all_task_screen\home+all_task_screen.jpg )
![overdue]( assets\screenshot\overdue_screen\overdue.jpg )
![CompletedTask]( assets\screenshot\completed_screen\complted_task.jpg )
![Export_Import]( assets\screenshot\drawer\import_export\import_export.jpg )




## 👨‍💻 Developer

Built by Muhammed Salahudheen

---

## 📜 License

This project is licensed under the MIT License. You’re free to use, modify, and distribute it.
