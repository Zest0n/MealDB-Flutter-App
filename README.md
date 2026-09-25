# 🍴 MealDB Flutter App

A Flutter-based recipe discovery application powered by the **TheMealDB API**.

The app allows users to search for meals, browse recipes by category or ingredient, view detailed meal information, discover random recipes, and authenticate using Firebase, including Google Sign-In.

---

## ✨ Features

### 🍽️ Recipe & API Features

* 🔎 Search meals by name
* 🗂️ Browse meals by category
* 🥕 Filter meals by ingredient
* 📖 View detailed meal information
* 🎲 Discover a random meal
* 📋 Display relevant recipe data from the API
* ⚡ Loading, empty, and error states
* 🔍 Search suggestions while typing
* 🎛️ Dynamic filtering and parameter customization

### 🎨 UI & Animations

* Custom loading animations
* Interactive button and card animations
* Smooth navigation transitions
* Ripple and scale effects
* Animated search and filter results
* Fade transitions when meal data changes
* Smooth appearance of newly loaded items

### 🔐 Authentication

* Firebase Authentication
* User registration / sign-up
* User login / sign-in
* Logout
* Authentication state handling
* Input validation and error handling
* Protected application content where applicable
* Google Sign-In
* Display of authenticated user's basic information

---

## 🔄 Application Flow

```text
REST API
   ↓
Search & Filters
   ↓
Meal Data Display
   ↓
Loading / Empty / Error Handling
   ↓
Custom Animations
   ↓
Firebase Authentication
   ↓
Google Sign-In
```

---

## 🌐 TheMealDB API

This project uses [TheMealDB](https://www.themealdb.com/) as its recipe data source.

### Base URL

```text
https://www.themealdb.com/api/json/v1/1/
```

### API Endpoints

| Feature              | Endpoint                      |
| -------------------- | ----------------------------- |
| Search meal          | `search.php?s=chicken`        |
| Meal details         | `lookup.php?i=52772`          |
| Categories           | `categories.php`              |
| Filter by category   | `filter.php?c=Seafood`        |
| Filter by ingredient | `filter.php?i=chicken_breast` |

**API Documentation:**
https://www.themealdb.com/docs_api_guide.php

---

## 🛠️ Tech Stack

* **Flutter**
* **Dart**
* **TheMealDB REST API**
* **Firebase Authentication**
* **Google Sign-In**

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd <repository-folder>
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Create/configure a Firebase project and connect it to the Flutter application.

Enable:

* Firebase Authentication
* Email/Password authentication
* Google Sign-In

Add the required Firebase configuration files for your target platforms.

> Firebase configuration files are intentionally not included in this repository.

### 4. Run the application

```bash
flutter run
```

---

## 📱 Core Functionality

### Search

Users can enter a meal name in the search bar and receive matching recipes from TheMealDB API.

### Categories

Users can select a category to browse meals belonging to that category.

### Ingredients

Users can filter recipes based on available ingredients.

### Meal Details

Selecting a meal opens a detailed view containing the relevant information returned by the API, such as:

* Meal name
* Category
* Area / cuisine
* Ingredients
* Measurements
* Instructions
* Meal image
* Source information where available

### Random Meal

The random meal feature allows users to quickly discover a recipe without manually searching.

---

## 🔐 Authentication Flow

```text
Application
    │
    ├── Sign Up / Sign In
    │
    ├── Continue with Google
    │
    ↓
Firebase Authentication
    │
    ├── Success → Authenticated User
    │
    └── Error → Display Error
    │
    ↓
Application Content
```

---

## 🎯 Project Requirements

This project was developed around the following requirements:

### Part 1 — API Integration

* REST API integration
* Search functionality
* Search suggestions
* Category filtering
* Ingredient filtering
* Meal details
* Dynamic API parameters
* Data display
* Loading states
* Empty states
* Error handling

### Part 2 — Animations & Firebase

* Custom loading animations
* Interactive element animations
* Data-change animations
* Smooth transitions
* Firebase authentication
* User registration and login
* Logout and authentication state management
* Google Sign-In
* Authentication validation and error handling

---

## 📂 Project Structure

A typical structure for the application is:

```text
lib/
├── models/
├── services/
│   ├── api/
│   └── authentication/
├── screens/
├── widgets/
├── animations/
├── utils/
└── main.dart
```

The exact structure may vary depending on the implementation.

---

## 📌 Future Improvements

Possible additions include:

* ❤️ Favorite meals
* 💾 Offline recipe caching
* 📝 Personal recipe collections
* 🛒 Shopping-list generation from ingredients
* 🌙 Dark mode
* 🔔 Personalized recipe recommendations
* 👤 Expanded user profiles

---

## 📜 License

This project is intended for educational and development purposes.

Recipe data is provided by **TheMealDB** and is subject to its own terms and usage policies.
