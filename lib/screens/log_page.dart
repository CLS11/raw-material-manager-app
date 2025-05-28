import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materialapp/data/models/composition_model.dart';
import 'package:materialapp/providers/composition_cubit.dart';
import 'package:materialapp/providers/inventory_cubit.dart';

class ManufacturingLogPage extends StatefulWidget {
  const ManufacturingLogPage({super.key});

  @override
  State<ManufacturingLogPage> createState() => _ManufacturingLogPageState();
}

class _ManufacturingLogPageState extends State<ManufacturingLogPage> {
  String? selectedProduct;
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manufacturing Log',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<CompositionCubit, List<CompositionModel>>(
              builder: (context, compositions) {
                if (compositions.isEmpty) {
                  return const Text(
                    'No compositions found.',
                  );
                }

                return DropdownButtonFormField<String>(
                  value: selectedProduct,
                  hint: const Text(
                    'Select a Product',
                  ),
                  onChanged: (value) => setState(() => selectedProduct = value),
                  items: compositions.map((comp) {
                    return DropdownMenuItem<String>(
                      value: comp.productName,
                      child: Text(
                        comp.productName,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity Manufactured',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedProduct == null || _quantityController.text.isEmpty)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all fields',
                      ),
                    ),
                  );
                  return;
                }

                final quantity = int.tryParse(_quantityController.text);
                if (quantity == null || quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter a valid quantity',
                      ),
                    ),
                  );
                  return;
                }

                final compositionCubit = context.read<CompositionCubit>();
                final compositions = compositionCubit.state;

                context.read<InventoryCubit>().manufactureProduct(
                      selectedProduct!,
                      quantity,
                      compositions,
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Inventory Updated',
                    ),
                  ),
                );

                _quantityController.clear();
                setState(() => selectedProduct = null);
              },
              child: const Text(
                'Log Manufacturing',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
