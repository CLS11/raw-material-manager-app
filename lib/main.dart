import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:materialapp/data/models/composition_model.dart';
import 'package:materialapp/data/models/material_model.dart';
import 'package:materialapp/data/services/google_service.dart';
import 'package:materialapp/data/services/hive_service.dart';
import 'package:materialapp/providers/composition_cubit.dart';
import 'package:materialapp/providers/inventory_cubit.dart';
import 'package:materialapp/screens/inventory_page.dart';
import 'package:materialapp/screens/log_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive
    ..registerAdapter(MaterialModelAdapter())
    ..registerAdapter(CompositionModelAdapter());

  await Hive.openBox<MaterialModel>('inventory');
  await Hive.openBox<CompositionModel>('composition');

  final hiveService = HiveService();
  final googleService = GoogleSheetsService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryCubit(
          hiveService, googleService,
        ),
      ),
        BlocProvider(create: (_) => CompositionCubit(
          hiveService,
        ),
      ),
      ],
      child: const RawMaterialApp(),
    ),
  );
}

class RawMaterialApp extends StatelessWidget {
  const RawMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const InventoryPage(),
      routes: {
        '/log': (_) => const ManufacturingLogPage(),
      },
    );
  }
}
