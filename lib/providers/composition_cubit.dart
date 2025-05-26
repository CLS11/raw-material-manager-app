import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materialapp/data/models/composition_model.dart';
import 'package:materialapp/data/services/hive_service.dart';

class CompositionCubit extends Cubit<List<CompositionModel>> {

  CompositionCubit(this.hiveService) : super([]) {
    loadCompositions();
  }
  final HiveService hiveService;

  void loadCompositions() {
    emit(hiveService.getAllCompositions());
  }

  void addComposition(CompositionModel model) {
    hiveService.addComposition(model);
    loadCompositions();
  }

  void deleteComposition(String productName) {
    hiveService.deleteComposition(productName);
    loadCompositions();
  }

  void updateComposition(String productName, CompositionModel updated) {
    hiveService.updateComposition(productName, updated);
    loadCompositions();
  }
}
