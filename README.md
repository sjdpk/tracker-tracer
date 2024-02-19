# Tracker Tracing Application

## Application Documentation

### Overview
This documentation provides information about the application and its requirements. It covers the Flutter version, framework details, architecture, and build description.

```bash
flutter build apk --split-per-abi --flavor
```

### Build Commands

**To Run:**

Prerequisites:
Available flavors are: [tracker, tracer]. 
Also, you have to change the environment for different apps from `lib/src/config/env/application_properties.dart`.

```bash
flutter run --flavor <flavorName>
```
Example: 
```bash
flutter run --flavor tracker
```

**To Build App Bundle:**
```bash
flutter build appbundle --flavor <flavorName>
```
Example:
```bash
flutter build appbundle --flavor tracker
```

**To Build APK:**
```bash
flutter build apk --split-per-abi --flavor <flavorName>
```
Example:
```bash
flutter build apk --split-per-abi --flavor tracker
```

### Application Details
- Flutter 3.16.0 • channel stable • [Flutter Repository](https://github.com/flutter/flutter.git)
- Framework • revision db7ef5bf9f (3 months ago) • 2023-11-15 11:25:44 -0800
- Engine • revision 74d16627b9
- Tools • Dart 3.2.0 • DevTools 2.28.24

### Application Architecture
This application follows the Feature-based Clean architecture. Each feature within the application has its respective files and folders, allowing for modular development and organization.

### Build Description
The application utilizes different flavors for various builds. Please ensure that you have checked and configured the respective build environment file before initiating a build. The necessary build environment details can be found in the `env` folder.

To build or add a new app flavor, follow these steps:

1. Open the `lib/env/application_properties.dart` file and modify it according to the build requirements.
2. To add a new app flavor, locate the `android/app/build.gradle` file and add the necessary configuration. Additionally, ensure that the respective environment file is built to facilitate easy setup and prevent configuration mismatches.

**Note:** It is crucial to update the environment configuration appropriately to ensure smooth and accurate builds.