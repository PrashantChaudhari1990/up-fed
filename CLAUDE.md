# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Basic Flutter Commands
```bash
# Install dependencies
flutter pub get

# Run the application for Android
flutter run android

# Run the application (general)
flutter run

# Clean project (useful when pub cache shows errors)
flutter clean

# Analyze code for lint issues
flutter analyze

# Build for Android
flutter build android

# Build APK
flutter build apk

# Build for iOS
flutter build ios
```

### Environment Management
To change the environment, modify the `EnvironmentType` enum value in `lib/config/server_config.dart`:
- `EnvironmentType.develop` - Development environment
- `EnvironmentType.staging` - Staging environment  
- `EnvironmentType.production` - Production environment

The environment configurations are in:
- `lib/environment/develop.dart`
- `lib/environment/staging.dart`
- `lib/environment/production.dart`

## Architecture Overview

### Project Structure
This is a Flutter mobile application for supervisor partners with a hybrid approach using WebView for business logic and native Flutter for authentication and core app functionality.

**Key Architecture Components:**

- **Hybrid App Pattern**: Native Flutter screens for auth flow, WebView for business functionality
- **Environment-based Configuration**: Multi-environment support with configurable base URLs
- **Firebase Integration**: Push notifications and core Firebase services
- **Localization**: Multi-language support using easy_localization package
- **Theme System**: Dynamic theme loading with light/dark mode support

### Core Flow
1. **Splash Screen** → **Slider Screen** (onboarding) → **Authentication Flow**
2. **Authentication**: Login → OTP Verification → PIN Setup/Validation
3. **Main App**: Home Screen with WebView-based business functionality
4. **WebView Integration**: Business logic handled through web app with native-web communication

### Key Directories

- `lib/config/` - Configuration files (server, themes, localization, notifications)
- `lib/environment/` - Environment-specific configurations
- `lib/ui/screens/` - Flutter screens (auth, home, splash, webview)
- `lib/services/` - API services and interceptors
- `lib/utils/` - Utility classes (session management, device info, webview controller)
- `lib/models/` - Data models and API request/response objects
- `lib/web_handler.dart` - JavaScript bridge functions for WebView communication

### WebView Integration
The app uses `flutter_inappwebview` for web content integration:
- Business logic screens are WebView-based
- Native-WebView communication through JavaScript handlers in `web_handler.dart`
- Session management shared between native and web contexts
- App bar and navigation controlled dynamically from web content

### State Management
- Uses provider pattern and ValueNotifier for simple state management
- Global notifiers for app bar visibility and bottom navigation state
- Session management through `AppSession` and `AppSessionStorage`

### Important Files
- `lib/config/server_config.dart` - Environment configuration switcher
- `lib/web_handler.dart` - WebView-Native communication bridge
- `lib/main.dart` - App initialization with Firebase and localization setup
- `lib/app.dart` - Main app widget with routing configuration

## Dependencies
Key packages used:
- `flutter_inappwebview` - WebView integration
- `firebase_core` & `firebase_messaging` - Firebase services
- `easy_localization` - Internationalization
- `dio` - HTTP client with interceptors
- `shared_preferences` - Local data storage
- `pinput` - PIN input UI component

## Asset Structure
- `assets/translations/` - Localization files (en-IN.json, hi-IN.json, mr-IN.json)
- `assets/images/` - App images and logos
- `assets/themes/` - Theme configuration JSON files
- `assets/icons/` - SVG icons used throughout the app