# QCards 📚

QCards is a mobile flashcard app built with Flutter. It allows users to create, edit, and flip through custom flashcards for any subject. Users can register with email/password or sign in with Google, and all their data is securely stored using Firebase.

---

## 🚀 Features

-   Register and log in securely with Firebase Auth (email or Google)
-   Create flashcard collections by subject
-   Flip cards to reveal answers
-   Edit or delete existing cards
-   Data synced and stored in Firebase Firestore
-   Dark and light mode toggle

---

## 💠 Tech Stack

-   Flutter (UI)
-   Firebase Authentication
-   Cloud Firestore
-   Google Sign-In
-   Provider (state management)

---

## 📂 Project Structure

```plaintext
/lib
  ├── models/           # Data models like QCUser
  ├── services/         # Firebase logic (Auth, Firestore)
  ├── widgets/          # Reusable UI components (FlippableCardWidget, CardFormWidget)
  └── main.dart         # App entry point
```

---

## 🧑‍💻 Getting Started

### 1. Prerequisites

-   Flutter SDK (3.x)
-   Firebase CLI
-   A configured Firebase project

### 2. Clone the project

```bash
git clone https://github.com/CorHandikaSawai/QCards.git
cd qcards
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Firebase Setup

-   Add your Firebase project’s `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) in the correct platform folder.
-   Configure Firestore and Auth in your Firebase console.

> For detailed setup, see [`docs/FIREBASE_SETUP.md`](docs/FIREBASE_SETUP.md)

---

## 📱 Running the App

```bash
flutter run
```

---

## 🔐 Authentication

-   Firebase Email/Password Sign-Up
-   Google Sign-In (Web & Mobile)
-   Email Verification required before access

---

## 🐛 Troubleshooting

-   If Google Sign-In doesn't work, make sure OAuth client IDs are configured in Firebase Console.
-   Ensure Firebase rules allow read/write access to `users` and `cards` collections.

---

## 📸 Screenshots

_You can include some optional screenshots or a demo GIF here._

---

## 🤝 Contact

Created by [Cor Sawai]
Contact: [[handika033@gmail.com](mailto:handika033@gmail.com)]

---
