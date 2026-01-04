# FitTrack AI 🏋️‍♂️🤖

FitTrack AI is a sophisticated, AI-enhanced fitness tracking mobile application built with **Flutter** and **GetX**. It combines traditional workout logging with intelligent coaching insights to provide users with a comprehensive fitness management experience.

---

## 🌟 Key Features

### 🧠 AI Coaching & Insights
*   **AI Coach Feedback**: Personalized weekly feedback based on your performance data.
*   **AI Workout Logging**: Log entire workouts using natural language—our AI parses your text and creates structured logs automatically.

### 📋 Workout Management
*   **Interactive Logging**: Easily record sets, reps, and weights for any exercise.
*   **Smart History**: A clean, chronological list of your training sessions.
*   **Infinite Scrolling**: Highly optimized pagination for browsing large workout histories smoothly.
*   **Session Metadata**: Track duration, mood, and specific training notes for every entry.

### 📚 Exercise Library
*   **Comprehensive Database**: Browse and manage a diverse range of exercises.
*   **Media Support**: Upload and view exercise-specific images to ensure perfect form.

### 🔐 Robust Foundation
*   **Secure Authentication**: Full login and registration system with persistent session handling.
*   **Dashboard**: A centralized hub for quick actions, weekly performance stats, and AI insights.

---

## 🛠 Tech Stack & Architecture

*   **Framework**: [Flutter](https://flutter.dev/) (Cross-platform Excellence)
*   **State Management**: [GetX](https://pub.dev/packages/get) (High-performance Reactive Programming)
*   **Networking**: [Dio](https://pub.dev/packages/dio) with custom Interceptors for API handling.
*   **Serialization**: JSON Mapping with robust model validation.
*   **Pattern**: Modular Feature-based Architecture (Clean, Scalable, and Testable).

---

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK: `^3.x.x`
*   Dart: `^3.x.x`

### Installation
1.  **Clone the repository**:
    ```bash
    git clone https://github.com/BirukTesfaye0940/fittrack_mobile.git
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

---

## 🏗 Project Structure

```text
lib/
├── app/
│   ├── core/           # Networking, Themes, Constants
│   ├── data/           # Models, Providers, Repositories
│   ├── modules/        # Feature modules (Auth, Home, Workouts, Exercises)
│   │   ├── [feature]/
│   │   │   ├── bindings.dart
│   │   │   ├── controller.dart
│   │   │   ├── service.dart
│   │   │   └── views/
│   └── routes/         # App Routing configuration
└── main.dart           # Entry point
```

---

## 📈 Future Roadmap
- [ ] Integration with wearable health devices (Apple Health / Google Fit).
- [ ] Social features for sharing achievements.
- [ ] Progress photo gallery with AI body fat estimation.
- [ ] Dark Mode Support.

---

## 🤝 Contact
**FitTrack AI Developer** - Biruk Tesfaye (mailto:biruktesfayeakabu@gmail.com)

---
*Developed with ❤️ for the fitness community.*
