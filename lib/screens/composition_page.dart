import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materialapp/data/models/composition_model.dart';
import 'package:materialapp/providers/composition_cubit.dart';

class CompositionPage extends StatefulWidget {
  const CompositionPage({super.key});

  @override
  State<CompositionPage> createState() => _CompositionPageState();
}

class _CompositionPageState extends State<CompositionPage> {
  final TextEditingController productController = TextEditingController();

  List<TextEditingController> materialControllers = [];
  List<TextEditingController> quantityControllers = [];

  @override
  void initState() {
    super.initState();
    _addMaterialField(); 
  }

  void _addMaterialField() {
    setState(() {
      materialControllers.add(TextEditingController());
      quantityControllers.add(TextEditingController());
    });
  }

  void _removeMaterialField(int index) {
    setState(() {
      materialControllers[index].dispose();
      quantityControllers[index].dispose();
      materialControllers.removeAt(index);
      quantityControllers.removeAt(index);
    });
  }

  void _saveComposition() {
    final productName = productController.text.trim();
    if (productName.isEmpty) return;

    final materials = <String, double>{};

    for (var i = 0; i < materialControllers.length; i++) {
      final name = materialControllers[i].text.trim();
      final quantity = double.tryParse(quantityControllers[i].text.trim()) ?? 0;

      if (name.isNotEmpty && quantity > 0) {
        materials[name] = quantity;
      }
    }

    if (materials.isEmpty) return;

    final model = CompositionModel(
      productName: productName,
      materialQuantities: materials,
    );

    context.read<CompositionCubit>().addComposition(model);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Composition saved',
          ),
        ),
    );

    productController.clear();
    for (final c in materialControllers) {
      c.clear();
    }
    for (final c in quantityControllers) {
      c.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Composition',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: productController,
              decoration: const InputDecoration(
                labelText: 
                'Product Name',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: materialControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: materialControllers[index],
                          decoration: const InputDecoration(
                            labelText: 'Material',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: quantityControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 
                            'Quantity',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle, 
                          color: Colors.red,
                          ),
                        onPressed: () => _removeMaterialField(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addMaterialField,
              child: const Text(
                'Add Material',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveComposition,
              child: const Text(
                'Save Composition',
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const Text(
              'Saved Compositions:',
            ),
            Expanded(
              child: BlocBuilder<CompositionCubit, List<CompositionModel>>(
                builder: (context, compositions) {
                  return ListView.builder(
                    itemCount: compositions.length,
                    itemBuilder: (context, index) {
                      final item = compositions[index];
                      return ListTile(
                        title: Text(item.productName),
                        subtitle: Text(item.materialQuantities.entries
                            .map((e) => '${e.key}: ${e.value}')
                            .join(', ')),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<CompositionCubit>().deleteComposition(
                              item.productName,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
