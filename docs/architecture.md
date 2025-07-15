# QCards Architecture Overview

This document provides a high-level understanding of the QCards app architecture, describing how the components interact and how the overall structure supports maintainability and scalability.

---

## 🧱 Layered Architecture

QCards follows a **layered architecture** approach to separate responsibilities:

### 1. **Presentation Layer (UI)**
- **Location:** `/lib/`, `/lib/widgets/`, and screen files like `register_user_screen.dart`, `study_screen.dart`
- **Role:** Displays the UI using Flutter widgets
- **Widgets:**
  - `FlippableCardWidget` – renders flip animations
  - `CardFormWidget` – used for creating/editing cards

### 2. **State Management Layer**
- **Library:** `provider`
- **Main State Classes:**
  - `AuthenticationService`
  - `UserPreference`
- **Usage:** Provides authentication status, user preferences (theme), and triggers UI updates via `notifyListeners()`

### 3. **Service Layer**
- **Location:** `/lib/services/`
- **Responsibilities:**
  - Encapsulate Firebase logic
  - Handle user registration, login, Google sign-in
  - Read/write from Firestore
- **Key Services:**
  - `auth_service.dart` – authentication logic
  - `user_service.dart` – stores and retrieves user profiles
  - `card_service.dart` – manages flashcards by subject and card ID
  - `user_preference_service.dart` – handles light/dark theme toggle

### 4. **Model Layer**
- **Location:** `/lib/models/`
- **Purpose:** Defines the structure of data used in the app
- **Model Used:**
  - `QCUser` – wraps basic user info like first name, last name, and ID

---

## 🔁 Data Flow Summary

1. **User signs in** via email/password or Google
2. `AuthenticationService` creates user (if new) and stores info in Firestore via `UserService`
3. Auth state is tracked using `Provider`
4. On success, the user is routed to a dashboard or card screen
5. In `StudyScreen`, flashcards are fetched by subject using `CardService`
6. Flip card widgets (`FlippableCardWidget`) are rendered in sequence
7. Changes to card content (via `CardFormWidget`) are reflected in Firestore

---

## 🧠 Notable Patterns

- **Dismissible cards:** Swiping deletes content on the fly
- **Google Sign-In support for web and mobile** via dual methods
- **Controller-based form editing** with state syncing for card questions and answers

---

## 🌗 Theme Support

- Managed by `UserPreference` using a `ThemeData` toggle
- Can be extended to persist theme using local storage in future

---

## 🛠 Future Improvements (optional)

- Add repository layer for further decoupling
- Add unit tests for service methods
- Persist theme using `SharedPreferences` or `Hive`
- Add error tracking (e.g., Sentry)
- Add card deck sorting or tags

---

