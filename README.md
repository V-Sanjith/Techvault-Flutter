# TechVault — Personal Tech Asset Manager

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![State Management](https://img.shields.io/badge/Riverpod-2.x-00599C)](https://riverpod.dev)
[![Local Storage](https://img.shields.io/badge/Database-Hive-FF6F00)](https://docs.hivedb.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**TechVault** is an offline-first Flutter application designed for managing personal technology assets, purchase details, warranty expirations, and device specifications in one place.

---

## 🌟 Key Features

- **📱 Physical Asset Inventory**: Track laptops, smartphones, tablets, monitors, audio gear, and peripherals with photos, serial numbers, and purchase prices.
- **🛡️ Automated Warranty Tracking**: Dynamic calculation of warranty statuses:
  - 🟢 **Active** (> 30 days remaining)
  - 🟡 **Expiring Soon** (Within 30 days)
  - 🔴 **Expired** (Past expiry date)
  - ⚪ **No Warranty** (No date specified)
- **🔔 Local Expiry Reminders**: Local device notifications for approaching warranty expiration dates without relying on external cloud servers.
- **📊 Real Metrics Dashboard**: Dynamic summary showing total asset valuation, active warranties, expiring coverage, and recently added devices.
- **💾 Offline-First Local Storage**: Powered by Hive database for data persistence.
- **🎨 Material 3 Design System**: Custom slate/indigo color tokens with dynamic System, Light, and Dark theme toggles.
- **📐 Responsive UI**: Tailored layouts for mobile devices (BottomNavigationBar) and tablets/desktops (NavigationRail).

---

## 🏗️ Architecture & Project Structure

TechVault follows a **Feature-First Clean Architecture**:

```text
lib/
├── core/
│   ├── router/          # GoRouter shell & modal routes
│   ├── services/        # Local notification service
│   ├── theme/           # Color tokens, typography & M3 ThemeData
│   ├── utils/           # Responsive breakpoints & date/currency formatters
│   └── widgets/         # Reusable UI primitives (AppCard, StatusBadge, MetricTile)
└── features/
    ├── dashboard/       # Real-time metrics & onboarding screen
    ├── devices/         # Device domain models, Hive repository, Riverpod state & form screens
    ├── warranty/        # Warranty status overview screen
    ├── analytics/       # Asset analytics roadmap
    └── settings/        # Theme switcher & app information
```

---

## 🛠️ Technology Stack

| Layer | Technology |
|---|---|
| **Framework** | [Flutter SDK](https://flutter.dev) |
| **State Management** | [Riverpod](https://riverpod.dev) (`flutter_riverpod`) |
| **Routing** | [GoRouter](https://pub.dev/packages/go_router) (`go_router`) |
| **Local Database** | [Hive](https://pub.dev/packages/hive) & `hive_flutter` |
| **Notifications** | [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications) |
| **Formatting** | `intl` for localized dates & currencies |
| **Image Picker** | `image_picker` & `path_provider` |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (v3.19+)
- Android Studio / VS Code with Flutter extension
- Android Emulator or physical device

### Installation & Execution

1. **Clone the repository**:
   ```bash
   git clone https://github.com/V-Sanjith/Techvault-Flutter.git
   cd Techvault-Flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run static analysis & tests**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

TechVault includes both **unit tests** and **widget tests**:

- **Warranty Status Logic**: Unit tests for date-based warranty status calculations (`Active`, `Expiring Soon`, `Expired`).
- **Repository CRUD Operations**: Tests for device creation, retrieval, updates, and deletion using an in-memory repository.
- **Widget Testing**: Tests verifying shell navigation and dashboard initialization.

Run the test suite using:
```bash
flutter test
```

---

## 👤 Author

**V-Sanjith**  
GitHub: [@V-Sanjith](https://github.com/V-Sanjith)

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
