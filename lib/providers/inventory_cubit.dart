import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materialapp/data/models/composition_model.dart';
import 'package:materialapp/data/models/material_model.dart';
import 'package:materialapp/data/services/hive_service.dart';

class InventoryCubit extends Cubit<List<MaterialModel>> {
  InventoryCubit(this.hiveService) : super([]) {
    loadMaterials();
  }
  final HiveService hiveService;

  void loadMaterials() {
    emit(hiveService.getAllMaterials());
  }

  void addMaterial(MaterialModel material) {
    hiveService.addMaterial(material);
    loadMaterials();
  }

  void deleteMaterial(String name) {
    hiveService.deleteMaterial(name);
    loadMaterials();
  }

  void updateMaterial(String name, MaterialModel updated) {
    hiveService.updateMaterial(name, updated);
    loadMaterials();
  }

  void manufactureProduct(
    String productName,
    int quantity,
    List<CompositionModel> compositions,
  ) {
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
    }

    loadMaterials();
  }
}
