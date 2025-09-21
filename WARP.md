# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

LonelyReminder is an intelligent, offline-first, cross-platform Flutter application designed to capture events from images and screenshots using OCR technology. The app creates reminders from scanned text and syncs across devices.

## Development Commands

### Build and Run
```bash
# Install dependencies
flutter pub get

# Run on connected device/simulator
flutter run

# Run on specific platform
flutter run -d chrome          # Web
flutter run -d macos           # macOS
flutter run -d android         # Android

# Build for release
flutter build apk              # Android APK
flutter build ios              # iOS
flutter build web              # Web
flutter build macos            # macOS
```

### Testing and Quality
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage

# Check for issues
flutter analyze

# Format code
flutter format lib/ test/
```

### Development Setup
```bash
# Check Flutter environment
flutter doctor

# Clean and rebuild
flutter clean && flutter pub get

# Generate platform files if needed
flutter create --platforms=android,ios,web,macos .
```

## Architecture Overview

### Core Architecture Pattern
- **Offline-First Architecture**: Local data storage with background sync
- **Provider Pattern**: State management using `provider` package
- **Service Layer**: Separated business logic in services/
- **Model Layer**: Data models in models/

### Key Components

#### Data Flow
1. **Event Creation**: OCR text → `EventParser` → `Event` model
2. **Local Storage**: `DatabaseService` (file-based JSON storage)
3. **UI Updates**: Provider pattern with `ThemeProvider`
4. **Authentication**: Firebase Auth with Google Sign-In

#### Directory Structure
```
lib/
├── main.dart              # App entry point with Provider setup
├── models/
│   └── event_model.dart   # Event data model
├── services/
│   ├── database_service.dart    # File-based JSON storage
│   ├── event_parser.dart        # OCR text parsing with chrono_dart
│   ├── google_auth_service.dart # Firebase/Google authentication
│   └── calendar_service.dart    # Google Calendar integration
├── providers/
│   └── theme_provider.dart      # Theme state management
└── settings_page.dart           # Settings UI
```

### Database Implementation
- **Current**: File-based JSON storage in `DatabaseService`
- **Planned**: Isar Database (currently avoided due to build issues)
- **Location**: Documents directory with `events.json`
- **Operations**: CRUD operations with event deduplication

### Text Parsing
Uses `chrono_dart` package for intelligent date/time extraction:
- Parses natural language dates ("tomorrow at 10am")
- Extracts event titles from remaining text
- Creates structured `Event` objects with metadata

## Key Dependencies

### Core Flutter Packages
- `provider: ^6.1.1` - State management
- `path_provider: ^2.1.2` - File system access
- `image_picker: ^1.0.7` - Camera/gallery access
- `get_storage: ^2.1.1` - Simple key-value storage

### Text Processing
- `chrono_dart: ^2.0.2` - Natural language date parsing
- `intl: ^0.18.1` - Date/time formatting

### Firebase & Google Services
- `firebase_core: ^2.24.2` - Firebase initialization
- `firebase_auth: ^4.17.9` - Authentication
- `google_sign_in: ^6.2.1` - Google OAuth
- `googleapis: ^12.0.0` - Google Calendar API

## Configuration Requirements

### Firebase Setup
Update `config.json` with your Firebase project details:
- Project ID, API keys, client IDs
- Platform-specific configuration files needed

### Google Calendar API
- Requires Google Cloud Console setup
- OAuth 2.0 credentials configuration
- Currently placeholder implementation in `CalendarService`

## Testing Considerations

### Current Test Issues
- Tests fail due to Provider setup in widget tests
- Need to wrap test widgets with `MultiProvider`
- `main.dart` expects `ThemeProvider` in widget tree

### Test Structure
- Widget tests in `test/widget_test.dart`
- Tests for initial UI state and navigation
- Firebase initialization may need mocking in tests

## Development Notes

### State Management
- Uses Provider pattern with `ChangeNotifier`
- `ThemeProvider` manages dark/light theme switching
- Persists theme preference with `GetStorage`

### Error Handling
- Comprehensive try-catch in database operations
- User-friendly error messages via SnackBar
- Graceful degradation for offline scenarios

### UI/UX Patterns
- Material Design with custom teal theme
- Animated transitions and hero animations
- Empty state handling with guidance messages
- Loading indicators during async operations

### OCR Integration (Planned)
- Google ML Kit for on-device text recognition
- Image processing pipeline not yet implemented
- Currently uses sample text for event parsing

## Debugging Tips

### Common Issues
1. **Provider Errors**: Ensure widgets are wrapped with appropriate providers
2. **Firebase Setup**: Verify platform configuration files exist
3. **File Permissions**: Check document directory access on target platform

### Platform-Specific Notes
- **iOS**: Requires CocoaPods installation (`sudo gem install cocoapods`)
- **Android**: Minimum SDK version considerations
- **Web**: CORS issues with Firebase services
- **macOS**: Entitlements for file access and network requests