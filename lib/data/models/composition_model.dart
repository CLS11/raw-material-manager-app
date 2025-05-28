import 'package:hive/hive.dart';

part 'composition_model.g.dart';

@HiveType(typeId: 1)
class CompositionModel { 

  CompositionModel({
    required this.productName,
    required this.materialQuantities,
  });

  factory CompositionModel.fromJson(Map<String, dynamic> json) {
    return CompositionModel(
      productName: json['productName'] as String,
      materialQuantities: Map<String, double>.from(
        (json['materialQuantities'] as Map).map(
          (key, value) => MapEntry(
            key.toString(), 
            double.parse(value.toString()),
          ),
        ),
      ),
    );
  }

  @HiveField(0)
  final String productName;

  @HiveField(1)
  final Map<String, double> materialQuantities;

   Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'materialQuantities': materialQuantities,
    };
  }
}
