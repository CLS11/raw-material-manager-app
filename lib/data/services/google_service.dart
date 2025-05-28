import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:materialapp/data/models/material_model.dart';
import 'package:materialapp/util/config.dart';

class GoogleSheetsService {
  
  Future<List<MaterialModel>> fetchMaterials() async {
    final url = Uri.parse('${Config.scriptUrl}?apiKey=${Config.apiKey}&action=fetch');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final materialsJson = data['materials'] as List<dynamic>;

      return materialsJson.map((json) => MaterialModel.fromJson(
        json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load data from Google Sheets');
    }
  }

  Future<void> upsertMaterial(MaterialModel material) async {
    final url = Uri.parse('${Config.scriptUrl}?apiKey=${Config.apiKey}&action=upsert');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(material.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to upsert material on Google Sheets');
    }
  }

  Future<void> deleteMaterial(String name) async {
    final url = Uri.parse('${Config.scriptUrl}?apiKey=${Config.apiKey}&action=delete&name=$name');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete material from Google Sheets');
    }
  }
}
