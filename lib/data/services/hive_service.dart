import 'package:hive/hive.dart';
import 'package:materialapp/data/models/composition_model.dart';
import 'package:materialapp/data/models/material_model.dart';

class HiveService {
  late final Box<MaterialModel> _inventoryBox;
  late final Box<CompositionModel> _compositionBox;

  void init() {
  _inventoryBox = Hive.box('inventory');
  _compositionBox = Hive.box('composition');
}


  //************FOR INVENTORY CUBIT****************

  List<MaterialModel> getAllMaterials() => _inventoryBox.values.toList();

  void addMaterial(MaterialModel material) {
    _inventoryBox.put(material.name, material);
  }

  void deleteMaterial(String name) {
      _inventoryBox.delete(name);
    }

  void updateMaterial(String name, MaterialModel updated) {
      _inventoryBox.put(name, updated);
    }

   //************FOR COMPOSITION CUBIT****************


List<CompositionModel> getAllCompositions() =>
    _compositionBox.values.toList();

  void addComposition(CompositionModel composition) {
    _compositionBox.put(composition.productName, composition);
  }

  void deleteComposition(String productName) {
    _compositionBox.delete(productName);
  }

  void updateComposition(String productName, CompositionModel updated) {
    _compositionBox.put(productName, updated);
  }
}
