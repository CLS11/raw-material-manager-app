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
          'Inventory Management',
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
                        context, 
                        material: mat,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                      ),
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

  Future<void> _showAddEditDialog(
    BuildContext context, 
    {MaterialModel? material}) async {
    final nameController = TextEditingController(
      text: material?.name ?? ''
    );
    final quantityController = TextEditingController(
      text: material?.currentQuantity.toString() ?? '0'
    );
    final thresholdController = TextEditingController(
      text: material?.thresholdQuantity.toString() ?? '0'
    );

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(material == null ? 'Add Material' : 'Edit Material'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController, 
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: thresholdController,
                    decoration: const InputDecoration(
                      labelText: 'Threshold',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
              ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final qty = double.tryParse(
                      quantityController.text
                    ) ?? -1;
                    final threshold = double.tryParse(
                      thresholdController.text
                    ) ?? -1;

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Name cannot be empty',
                          ),
                        ),
                      );
                      return;
                    }
                    if (qty < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Quantity cannot be negative',
                          ),
                        ),
                      );
                      return;
                    }
                    if (threshold < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Threshold cannot be negative',
                          ),
                        ),
                      );
                      return;
                    }

                    if (material == null) {
                      context.read<InventoryCubit>().addMaterial(
                            MaterialModel(
                              name: name,
                              currentQuantity: qty,
                              thresholdQuantity: threshold,
                            ),
                          );
                    } else {
                      context.read<InventoryCubit>().updateMaterial(
                            material.name,
                            material.copyWith(
                              name: name,
                              currentQuantity: qty,
                              thresholdQuantity: threshold,
                            ),
                          );
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Save',
                  ),
                ),
            ],
          );
        });
      },
    );

    
    nameController.dispose();
    quantityController.dispose();
    thresholdController.dispose();
  }
}
