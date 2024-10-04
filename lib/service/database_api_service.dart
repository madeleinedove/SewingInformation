import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:sewing_information/models/ModelProvider.dart';

class DatabaseApiService {
  DatabaseApiService();

  static Future<List<Pattern?>> getPatterns() async {
    try {
      final request = ModelQueries.list(Pattern.classType);
      final response = await Amplify.API.query(request: request).response;
      final patterns = response.data;
      if (patterns != null) {
        return patterns.items;
      }
      return const [];
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return const [];
    }
  }

  static Future<void> createPattern(
      String name, String desc, String manufactor, List<String> tags) async {
    final pattern = Pattern(
        name: name,
        description: desc,
        tags: "{\"tags\": ${jsonEncode(tags)}}",
        manufactor: manufactor);
    try {
      final request = ModelMutations.create(pattern);
      final response = await Amplify.API.mutate(request: request).response;

      final createdPattern = response.data;
      if (createdPattern == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Created pattern: ${createdPattern.name}');
    } on ApiException catch (e) {
      safePrint('Create failed: $e');
    }
  }

  static Future<List<Fabric?>> getFabrics() async {
    try {
      final request = ModelQueries.list(Fabric.classType);
      final response = await Amplify.API.query(request: request).response;
      final fabrics = response.data;
      if (fabrics != null) {
        return fabrics.items;
      }
      return const [];
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return const [];
    }
  }

  static Future<void> createFabric(
      String name, String desc, String imageKey, List<String> tags) async {
    final fabric = Fabric(
        name: name,
        description: desc,
        tags: "{\"tags\": ${jsonEncode(tags)}}",
        imageKey: imageKey);

    try {
      final request = ModelMutations.create(fabric);
      final response = await Amplify.API.mutate(request: request).response;

      final createFabric = response.data;
      if (createFabric == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Created pattern: ${createFabric.name}');
    } on ApiException catch (e) {
      safePrint('Create failed: $e');
    }
  }
}
