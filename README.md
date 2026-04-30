# Voice-Based Multilingual Onboarding App (Flutter + Firebase)

## Overview

This project is a **voice-enabled, multilingual onboarding and profile builder application** developed using **Flutter and Firebase**.

The app allows users to:

* Sign in using **Email/Password or Google**
* Complete onboarding using **voice or text input**
* Interact in **multiple languages (English & Hindi)**
* Store and manage profile data in **Firebase Firestore**
* Edit and update profile seamlessly

---

## Key Features

### Authentication

* Email & Password Login
* Google Sign-In
* Login using Firebase Auth

---

### Smart Onboarding Flow

* Multi-step question-based onboarding:

  * Name
  * Skills
  * Experience
  * Education
  * Interests
* Progress indicator for better UX
* Supports both:

  * Typing input
  * Voice input

---

### Voice Integration

* **Speech-to-Text (STT)** using `speech_to_text`
* Converts user speech to text in real time
* Supports multiple languages
* Mic toggle with listening state

---

### Text-to-Speech (TTS)

* Questions are read aloud automatically
* Enhances accessibility and user experience

---

### Multilingual Support

* Supported languages:

  * English
  * Hindi (regional)
* Dynamic switching:

  * UI text
  * Voice input
  * Voice output

---

### Profile Management

* Displays structured user data:

  * Name
  * Skills
  * Experience
  * Education
  * Interests
* Clean card-based UI

---

### Edit Functionality

* Users can update their profile anytime
* Existing data can be edited
* Changes are synced with Firestore

---

### Firebase Integration

* **Firebase Auth** → Authentication
* **Firestore** → Data storage
* Real-time data persistence

---

## Architecture

The app follows a **clean and scalable architecture** using Provider for state management.

![Architecture](image.png)

---

## Application Flow

1. User logs in (Email/Google)
2. Selects preferred language
3. Starts onboarding
4. Answers questions via:

   * Voice OR typing
5. Data is saved to Firestore
6. Profile screen displays user data
7. User can edit the profile anytime
8. Logout option available

---

## State Management

* Implemented using **Provider**
* Handles:

  * Authentication state
  * Onboarding flow
  * User data

---

## Tech Stack

* **Flutter** (Frontend)
* **Firebase Auth**
* **Cloud Firestore**
* **Provider (State Management)**
* **Speech-to-Text**
* **Text-to-Speech**

---

## Setup Instructions

### 1. Clone the Repository

```
git clone https://github.com/harshavardhanreddy05/voice_profile_builder.git
```

---

### 2. Install Dependencies

```
flutter pub get
```

---

### 3. Firebase Setup

* Create Firebase project
* Add Android app
* Download `google-services.json`
* Place it in:

```
android/app/
```

---

### 4. Enable Firebase Services

* Authentication → Enable Email & Google
* Firestore → Create database

---

### 5. Run App

```
flutter run
```

---

## Demo

https://drive.google.com/file/d/1NqTozBiEL7ze5oo6O4G40QbH66qhChCp/view?usp=drive_link

---

## Challenges & Solutions

### Voice Recognition Accuracy

* Handled using proper locale settings (`en_IN`, `hi_IN`)

### State Persistence

* Used Firebase Auth listener for auto-login

### Edit Flow Issues

* Fixed by preloading existing data into the onboarding provider

---

## Future Improvements

* Add more languages
* AI-based skill extraction from speech
* Voice confirmation system
* Dark mode UI
* Backend validation and analytics

---

## Author

**Baddam Harshavardhan**

* GitHub: https://github.com/harshavardhanreddy05
* LinkedIn: https://www.linkedin.com/in/harshareddy26/

---
