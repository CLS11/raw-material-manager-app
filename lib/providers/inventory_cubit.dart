import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materialapp/data/models/composition_model.dart';
import 'package:materialapp/data/models/material_model.dart';
import 'package:materialapp/data/services/google_service.dart';
import 'package:materialapp/data/services/hive_service.dart';

class InventoryCubit extends Cubit<List<MaterialModel>> {
  InventoryCubit(this.hiveService, this.googleService) : super([]) {
    loadMaterials();
  }

  final HiveService hiveService;
  final GoogleSheetsService googleService;

  Future<void> loadMaterials() async {
    emit(hiveService.getAllMaterials());

    try {
      final remoteMaterials = await googleService.fetchMaterials();
      for (final material in remoteMaterials) {
        hiveService.addMaterial(material);
      }
      emit(hiveService.getAllMaterials());
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching remote materials: $e');
      }
    }
  }

  Future<void> addMaterial(MaterialModel material) async {
    hiveService.addMaterial(material);
    try {
      await googleService.upsertMaterial(material); 
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing with Google Sheets on add: $e');
      }
    }
    await loadMaterials();
  }

  Future<void> deleteMaterial(String name) async {
    hiveService.deleteMaterial(name);
    try {
      await googleService.deleteMaterial(name); 
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing with Google Sheets on delete: $e');
      }
    }
    await loadMaterials();
  }

  Future<void> updateMaterial(String name, MaterialModel updated) async {
    hiveService.updateMaterial(name, updated);
    try {
      await googleService.upsertMaterial(updated); 
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing with Google Sheets on update: $e');
      }
    }
    await loadMaterials();
  }

  Future<void> manufactureProduct(
    String productName,
    int quantity,
    List<CompositionModel> compositions,
  ) async {
    final productComposition = compositions.firstWhere(
      (comp) => comp.productName == productName,
      orElse: () => throw Exception('Composition not found'),
    );

    final currentInventory = hiveService.getAllMaterials();

    for (final entry in productComposition.materialQuantities.entries) {
      final materialName = entry.key;
      final requiredPerUnit = entry.value;
      final totalRequired = requiredPerUnit * quantity;

      final material = currentInventory.firstWhere(
        (mat) => mat.name == materialName,
        orElse: () => throw Exception('Material not found'),
      );
      final updatedMaterial = material.copyWith(
        currentQuantity: material.currentQuantity - totalRequired,
      );
      hiveService.updateMaterial(materialName, updatedMaterial);
      try {
        await googleService.upsertMaterial(updatedMaterial); 
      } catch (e) {
        if (kDebugMode) {
          print('Error syncing with Google Sheets on manufacture: $e');
        }
      }
    }
    await loadMaterials();
  }
}
