# RAW MATERIAL MANAGER APP

A Flutter application for managing material inventory with Google Sheets sync and local storage using Hive. This app allows users to:

1. Add, update, and delete materials

2. Track quantity and threshold levels

3. Sync materials with Google Sheets

4. Manage manufacturing logs

5. Navigate using a bottom navigation bar

## FEATURES

1. Inventory Management:

Add and manage materials, each with a quantity and a threshold.

2. Manufacturing Logs:

Simulate product manufacturing and update material quantities accordingly.

3. Offline Storage:

Uses Hive for local storage.

4. Flutter BLoC:

Efficient state management using flutter_bloc.

5. Bottom Navigation:

Seamless navigation between Inventory and Logs screens.

### Dependencies

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.0.11
  http: ^0.13.5