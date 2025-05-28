# RAW MATERIAL MANAGER APP

A Flutter application for managing material inventory with Google Sheets sync and local storage using Hive. This app allows users to:

1. Add, update, and delete materials

2. Track quantity and threshold levels

3. Sync materials with Google Sheets

4. Manage manufacturing logs

5. Navigate using a bottom navigation bar

## FEATURES

1. Inventory Management:
![Image 1](https://github.com/user-attachments/assets/0cca9316-b0e8-46d3-abdd-c8ba9277feab)
![Image 2](https://github.com/user-attachments/assets/a42e7778-09ad-44bf-98bd-fbfde0c322c8)


Add and manage materials, each with a quantity and a threshold.

2. Manufacturing Logs:
![Image 3](https://github.com/user-attachments/assets/5111d784-adde-4abb-bc14-b9ff41b9f263)


Simulate product manufacturing and update material quantities accordingly.

3. Offline Storage:

Uses Hive for local storage.

4. Flutter BLoC:

Efficient state management using flutter_bloc.

5. Bottom Navigation:
   ![Image 4](https://github.com/user-attachments/assets/be70f75f-33f9-4b25-9045-58d3647665f0)


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
