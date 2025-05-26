import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materialapp/data/models/material_model.dart';
import 'package:materialapp/providers/inventory_cubit.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory Management'
          ),
        ),
      body: BlocBuilder<InventoryCubit, List<MaterialModel>>(
        builder: (context, materials) {
          if (materials.isEmpty) {
            return const Center(
              child: Text(
                'No materials added.',
              ),
            );
          }
          return ListView.builder(
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final mat = materials[index];
              final isLowStock = mat.currentQuantity < mat.thresholdQuantity;

              return ListTile(
                title: Text(mat.name),
                subtitle: Text(
                  'Qty: ${mat.currentQuantity} | Threshold: ${mat.thresholdQuantity}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLowStock)
                      const Icon(
                        Icons.warning, 
                        color: Colors.red,
                      ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showAddEditDialog(
                        context, material: mat,
                        ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<InventoryCubit>().deleteMaterial(mat.name);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {MaterialModel? material}) {
    final nameController = TextEditingController(
      text: material?.name ?? ''
    );
    final qtyController = TextEditingController(
      text: material?.currentQuantity.toString() ?? ''
    );
    final thresholdController = TextEditingController(
      text: material?.thresholdQuantity.toString() ?? ''
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          material == null ? 'Add Material' : 'Edit Material',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              readOnly: material != null, 
              decoration: const InputDecoration(
                labelText: 
                'Material Name',
              ),
            ),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 
                'Current Quantity',
              ),
            ),
            TextField(
              controller: thresholdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 
                'Threshold Quantity',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text(
              'Cancel',
              ),
            ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final qty = double.tryParse(
                qtyController.text.trim()) ?? 0;
              final threshold = double.tryParse(
                thresholdController.text.trim()) ?? 0;

              final newMaterial = MaterialModel(
                name: name, 
                currentQuantity: qty, 
                thresholdQuantity: threshold
              );

              if (material == null) {
                context.read<InventoryCubit>().addMaterial(newMaterial);
              } else {
                context.read<InventoryCubit>().updateMaterial(name, newMaterial);
              }

              Navigator.pop(context);
            },
            child: const Text(
              'Save',
            ),
          ),
        ],
      ),
    );
  }
}
