# Project Overview: LonelyReminder (ChronoScan)

## Purpose
LonelyReminder (internally referred to as ChronoScan in the UI) is an intelligent, offline-first, cross-platform application designed to capture events from images and screenshots, and synchronize them across various devices (Android, iOS, Windows, macOS). The primary goal is to eliminate the manual effort and errors associated with transcribing event details from visual sources into a digital calendar.

## Core Features (Planned)
*   **Image-to-Event Capture:** Instantly create events from photos or screenshots.
*   **Intelligent Text Analysis (OCR):** On-device AI to detect event titles, dates, times, and descriptions.
*   **Offline-First Functionality:** Core scanning and parsing features work without an internet connection.
*   **Seamless Cross-Device Sync:** Local events sync with a central server when online.
*   **Calendar Integration:** Export captured events to device's local calendar.
*   **Secure & Private:** Data synced to a private backend for user ownership.

## Technology Stack (Planned)
*   **Mobile & Desktop:** Flutter (Dart)
*   **Local Database:** Isar Database (currently removed due to build issues)
*   **On-Device AI:** Google ML Kit (Text Recognition) (currently removed/disabled due to build issues)
*   **Backend API:** Go (Golang) with Gin
*   **Cloud Database:** MongoDB

## Current Status & Challenges (as of September 16, 2025)

### Implemented Features
*   **Dart Code Clean-up:** All static analysis issues resolved; `flutter analyze` passes.
*   **Flutter Tests Fixed:** Widget tests in `test/widget_test.dart` are passing, utilizing `mockito` for mocking.
*   **Android Build Fixed:** APK builds successfully, but *without* OCR functionality.
*   **Multiprocessing:** Implemented `Isolate` for image processing, but currently unused as OCR is disabled.
*   **Initial UI Improvements:** Modern Material 3 theme, dark mode by default, `BottomNavigationBar` with "Reminders", "Settings", and "Account" items, and `AppBar` icons.
*   **Basic Settings Page:** `lib/settings_page.dart` provides a basic UI with a dark mode switch placeholder and a "Sign in with Google" placeholder.
*   **Sample Events:** The UI displays dummy `Event` data as the local database is currently removed.

### Current Problems
1.  **Android Build Failure (Isar/AGP Incompatibility):** The `Isar` database and related packages (`isar_flutter_libs`, `isar_generator`) have been **removed** from `pubspec.yaml` to resolve Android build issues (e.g., "Namespace not specified" errors). The application currently lacks local database functionality.
2.  **OCR Functionality (Disabled & Unstable):** `google_mlkit_text_recognition` was removed from `pubspec.yaml` due to persistent `lStar` errors during Android builds. OCR is **temporarily disabled**.
3.  **iOS Build Failure:** Consistent failures due to code signing issues, requiring manual intervention in Xcode.
4.  **Missing Core Functionality:** The absence of a local database and OCR means the app currently lacks its primary features.

## Future Plans

1.  **Re-implement Local Database:**
    *   **Goal:** Re-introduce a stable local database solution for storing reminders.
    *   **Approach:** Investigate alternative local database solutions (e.g., `Hive`, `sqflite`) or find a definitive workaround for `Isar`'s Android Gradle Plugin (AGP) incompatibility.

2.  **Re-enable OCR and Reminder Functionality:**
    *   **Goal:** Integrate OCR back into the app and enable saving extracted reminders.
    *   **Approach:** Once a stable local database is in place, re-add a text recognition library. This will be positioned as a "PRO" feature.

3.  **UI Redesign (Full Implementation):**
    *   **Goal:** Fully implement the UI based on the `UImotivation.jpeg` description, incorporating a "big twist."
    *   **Approach:** Implement a Google Calendar-like toolbar (logo, search, date selector, action items), focus on an agenda view for reminders, recreate `EventListItem` style with pill containers, and ensure smooth animations.

4.  **Settings Page (Full Implementation):**
    *   **Goal:** Complete the settings page with full functionality.
    *   **Approach:** Implement user settings, integrate Google Authentication (`firebase_auth`, `google_sign_in`), and add a dynamic Dark/Light Mode Toggle.

5.  **Manual Text Input for Reminders:**
    *   **Goal:** Add an option for users to manually input reminder text.
    *   **Approach:** Implement a UI for text input that can be parsed into an `Event` and saved to the database.

6.  **Ensure iOS Compatibility:**
    *   **Goal:** Get the app building and running on iOS.
    *   **Approach:** Address the code signing issues manually in Xcode.

## Code Structure Highlights

*   `lib/main.dart`: Entry point of the Flutter application, defines the main UI structure (`MyHomePage`), manages sample events, and handles image picking (with OCR currently disabled).
*   `lib/event_parser.dart`: Contains the `Event` data model and `EventParser` class, which uses regular expressions to extract event details (title, date, time) from raw text.
*   `lib/settings_page.dart`: Implements the basic UI for the settings screen, including placeholders for dark mode toggling and Google Sign-In.
*   `lib/services/database_service.dart`: Defines `DatabaseService` for interacting with `Isar` (though `Isar` is currently removed from `pubspec.yaml` and thus this service is non-functional).
*   `ocr_test.dart`: A standalone Dart script demonstrating OCR functionality using `google_mlkit_text_recognition` and `event_parser`, independent of the main Flutter app.
*   `pubspec.yaml`: Lists project dependencies. Key dependencies like `isar` and `google_mlkit_text_recognition` are currently excluded due to build conflicts.
*   `analysis_options.yaml`: Configures the Dart analyzer with `flutter_lints` for code quality.
*   `.gitignore`: Specifies files and directories to be ignored by Git.
*   `.metadata`: Flutter project metadata, including version and platform migration details.
*   `local_packages/isar_flutter_libs`: A local package related to Isar, but Isar is not actively used in the main project due to the aforementioned build issues.
