import 'package:hive/hive.dart';

part 'composition_model.g.dart';

@HiveType(typeId: 1)
class CompositionModel { 

  CompositionModel({
    required this.productName,
    required this.materialQuantities,
  });
  @HiveField(0)
  final String productName;

  @HiveField(1)
  final Map<String, double> materialQuantities;
}
