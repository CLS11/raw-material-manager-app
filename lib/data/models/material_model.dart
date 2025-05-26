import 'package:hive/hive.dart';
part 'material_model.g.dart';


@HiveType(typeId: 0)
class MaterialModel extends HiveObject {

  MaterialModel({
    required this.name,
    required this.currentQuantity,
    required this.thresholdQuantity,
  });
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double currentQuantity;

  @HiveField(2)
  final double thresholdQuantity;

  MaterialModel copyWith({
    String? name,
    double? currentQuantity,
    double? thresholdQuantity,
  }) {
    return MaterialModel(
      name: name ?? this.name,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      thresholdQuantity: thresholdQuantity ?? this.thresholdQuantity,
    );
  }
}
