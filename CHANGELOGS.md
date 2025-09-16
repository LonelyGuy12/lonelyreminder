# Project Changelog and Future Plans

This document summarizes the work done on the Reminder App, outlines future plans, and details current challenges.

## Implemented Features (as of September 16, 2025)

*   **Dart Code Clean-up:**
    *   **Action:** Resolved all static analysis issues (errors, warnings, and info messages) reported by `flutter analyze`.
    *   **Details:** This involved adding `path_provider` dependency, removing unused `dart:io` imports, fixing string concatenation in `lib/event_parser.dart`, and addressing deprecated `google_ml_kit` API usage by switching to `google_mlkit_text_recognition`.
    *   **Status:** Dart code is clean and passes `flutter analyze`.

*   **Flutter Tests Fixed:**
    *   **Action:** Made widget tests in `test/widget_test.dart` pass.
    *   **Details:** Integrated `mockito` for mocking `DatabaseService` and `Isar` components. Updated test assertions to reflect the app's actual UI (e.g., checking for "No events found" message instead of counter values).
    *   **Status:** All widget tests are passing.

*   **Android Build Fixed (Temporary & Iterative Attempts):**
    *   **Action:** Addressed various Android build issues to achieve a successful APK build.
    *   **Details:**
        *   Initially, faced `lStar` error with `google_mlkit_text_recognition`. Attempts to fix included:
            *   Updating `compileSdk` and `targetSdk` to 34 and then 36 in `android/app/build.gradle.kts`.
            *   Updating Android Gradle Plugin (AGP) version in `android/build.gradle.kts`.
            *   Adding Material Components dependency (`com.google.android.material:material`) and explicitly setting themes to `Theme.Material3.DayNight.NoActionBar` in `android/app/src/main/res/values/styles.xml`.
            *   Adding `resValue` for ML Kit theme in `android/app/build.gradle.kts`.
            *   Explicitly adding `androidx.core:core-ktx` and `androidx.appcompat:appcompat` dependencies.
            *   Attempting a `subprojects` block in `android/build.gradle.kts` to force `compileSdkVersion` and `buildToolsVersion` (which led to Kotlin DSL compilation errors).
        *   Switched to `flutter_tesseract_ocr` to bypass `lStar` error, which initially worked but later caused `ffi` version conflicts with `Isar`.
        *   Ultimately, `google_mlkit_text_recognition` was removed again due to persistent `lStar` errors.
    *   **Status:** Android APK builds successfully *without* OCR functionality.

*   **Multiprocessing Implemented:**
    *   **Action:** Refactored image processing and event parsing logic to run in a separate `Isolate`.
    *   **Details:** Implemented `_ocrAndParseEntry` as a top-level function and used `Isolate.spawn` in `_pickImage`. Ensured `WidgetsFlutterBinding.ensureInitialized()` was called within the Isolate for platform channel communication.
    *   **Status:** The multiprocessing mechanism is in place, but currently unused as OCR is disabled.

*   **UI Improved (Initial Pass):**
    *   **Action:** Enhanced the application's user interface.
    *   **Details:**
        *   Switched to a modern Material 3 theme with `ColorScheme.fromSeed` and `useMaterial3: true`.
        *   Set dark mode as the default theme (`themeMode: ThemeMode.dark`).
        *   Improved the empty state message with an icon and more descriptive text.
        *   Refactored `MyHomePage` to include a `BottomNavigationBar` with "Reminders", "Settings", and "Account" items.
        *   Added leading (menu) and trailing (notifications) `IconButton`s to the `AppBar`.
    *   **Status:** Initial UI improvements are implemented.

*   **Settings Page (Basic UI & Navigation):**
    *   **Action:** Created a basic settings page and integrated navigation.
    *   **Details:** Created `lib/settings_page.dart` with a `SwitchListTile` for dark mode (placeholder) and a "Sign in with Google" `ListTile` (placeholder). Implemented navigation to `SettingsPage` from `lib/main.dart`'s `AppBar` menu icon and `BottomNavigationBar` settings item.
    *   **Status:** Basic settings UI and navigation are in place.

*   **Sample Events:**
    *   **Action:** Generated and displayed sample `Event` data.
    *   **Details:** Populated a `List<Event>` in `_MyHomePageState`'s `initState` with dummy events to ensure the UI has content, as the database is currently removed.
    *   **Status:** Sample events are displayed.

## Current Problems and Challenges

1.  **Android Build Failure (Isar/AGP Incompatibility - Resolved by Removal):**
    *   **Issue:** Previously, the Android build failed due to incompatibility between `isar_flutter_libs` (requiring older AGP) and Flutter's recent Gradle plugins (requiring newer AGP). This manifested as "Namespace not specified" or "Plugin not found" errors.
    *   **Attempts to Fix:** Extensive attempts were made to downgrade AGP/Gradle, inject `namespace` via `subprojects`, and manage `ffi` conflicts.
    *   **Current Status:** `Isar` and its related packages (`isar_flutter_libs`, `isar_generator`) have been **removed** from `pubspec.yaml` to unblock the Android build. The app currently does *not* use a local database. This resolves the build error, but removes a core feature.

2.  **OCR Functionality (Currently Disabled & Unstable):**
    *   **Issue:** OCR functionality (`google_mlkit_text_recognition`) was causing persistent `lStar` errors during Android builds. Even after re-enabling it and applying various Android build fixes, the `lStar` error returned.
    *   **Current Status:** OCR functionality has been **temporarily removed/disabled** from the app to allow the Android build to pass. The `_ocrAndParseEntry` isolate function and its calls are still in `lib/main.dart` but are not actively used for processing. The `google_mlkit_text_recognition` package is removed from `pubspec.yaml`.

3.  **iOS Build Failure:**
    *   **Issue:** The iOS build consistently fails due to code signing issues.
    *   **Current Status:** This requires manual intervention in Xcode (setting up provisioning profiles and certificates) and cannot be resolved automatically through the CLI.

4.  **Missing Core Functionality:**
    *   **Issue:** The app currently lacks its core functionality: saving reminders to a local database and performing OCR for event extraction.
    *   **Current Status:** These features are disabled/removed due to the aforementioned build and compatibility issues.

## Future Plans (from User Requirements)

1.  **Re-implement Local Database:**
    *   **Goal:** Re-introduce a local database solution for storing reminders.
    *   **Approach:** Investigate alternative local database solutions (e.g., `Hive`, `sqflite`) that are known to be more compatible with current Flutter/Android environments, or find a definitive workaround for `Isar`'s AGP incompatibility.

2.  **Re-enable OCR and Reminder Functionality:**
    *   **Goal:** Integrate OCR back into the app and enable saving extracted reminders.
    *   **Approach:** Once a stable local database is in place, re-add a text recognition library. This will be a "PRO" feature, implying a distinction between free and premium features.

3.  **UI Redesign (Full Implementation):**
    *   **Goal:** Fully implement the UI based on the `UImotivation.jpeg` description with the "big twist".
    *   **Approach:**
        *   Implement the described toolbar (Google Calendar-like with logo, search, date selector, action items).
        *   Focus on an agenda view for reminders as the primary content.
        *   Recreate `EventListItem` style with pill containers and appropriate styling.
        *   Ensure smooth animations throughout the UI.

4.  **Settings Page (Full Implementation):**
    *   **Goal:** Complete the settings page with full functionality.
    *   **Approach:**
        *   Implement user settings (details to be defined).
        *   Integrate Google Authentication using `firebase_auth` and `google_sign_in`.
        *   Implement a dynamic Dark/Light Mode Toggle.

5.  **Manual Text Input for Reminders:**
    *   **Goal:** Add an option for users to manually input reminder text.
    *   **Approach:** Implement a UI for text input that can be parsed into an `Event` and saved to the database.

6.  **Ensure iOS Compatibility:**
    *   **Goal:** Get the app building and running on iOS.
    *   **Approach:** Address the code signing issues manually in Xcode.