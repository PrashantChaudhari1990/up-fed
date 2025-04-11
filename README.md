
## Vendor Partner Mobile Application📱

This project for dealer mobile application for Vendor Partner.


### Supported Versions
This project is compatible with the following versions:

```Dart:``` ^3.5.1

```Flutter:``` 3.24.1

```Android:``` Minimum SDK 23 (Android 6.0) or higher
## Installation

Follow these steps to install and set up the project:

#### 1. Clone the Repository

```bash
  git@github.com:Yatnavat/partner-app-container.git
```
#### 2. Go to Project Repository

```bash
  cd oorjaa-base-mobile-app
```
#### 3. Install Dependencies

```bash
  flutter pub get
```
*Some times show errors due to pub cache then run* ```flutter clean``` *before install dependencies.*

#### 4. Run Application
Run using command line
```bash
  flutter run android
```
Also run using android studio.



## Environment Variables

```
├───lib
│   ├───config
│   │    └───server_config.dart
│   └───environment
│       ├───develop.dart
│       ├───staging.dart
│       └───production.dart

```
Environment variables are define in specific files of environment

*To change environment go to ```lib/config/server_config.dart``` and change enum value of ```EnvironmentType```*\
 