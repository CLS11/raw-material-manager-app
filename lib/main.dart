import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:materialapp/data/models/material_model.dart';
import 'package:materialapp/data/models/composition_model.dart';
import 'package:materialapp/data/services/hive_service.dart';
import 'package:materialapp/providers/composition_cubit.dart';
import 'package:materialapp/providers/inventory_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive..registerAdapter(MaterialModelAdapter())
  ..registerAdapter(CompositionModelAdapter());

  await Hive.openBox<MaterialModel>('inventory');
  await Hive.openBox<CompositionModel>('composition');

  final hiveService = HiveService(); 

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryCubit(hiveService)),
        BlocProvider(create: (_) => CompositionCubit(hiveService)),
      ],
      child: const RawMaterialApp(),
    ),
  );
}

class RawMaterialApp extends StatelessWidget {
  const RawMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Raw Material App',
          ),
        ),
      ), // Placeholder
    );
  }
}
