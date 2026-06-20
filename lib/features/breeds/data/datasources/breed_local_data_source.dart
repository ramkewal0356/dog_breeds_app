import 'package:hive/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../models/breed_model.dart';

abstract class BreedLocalDataSource {
  Future<List<BreedModel>> getCachedBreeds();

  Future<void> cacheBreeds(List<BreedModel> breeds);

  Future<void> clearBreeds();
}

class BreedLocalDataSourceImpl implements BreedLocalDataSource {
  final Box<Map> breedsBox;

  BreedLocalDataSourceImpl({required this.breedsBox});

  @override
  Future<List<BreedModel>> getCachedBreeds() async {
    try {
      final values = breedsBox.values.toList();
      return values
          .map(
            (data) => BreedModel.fromHiveMap(Map<String, dynamic>.from(data)),
          )
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached breeds: $e');
    }
  }

  @override
  Future<void> cacheBreeds(List<BreedModel> breeds) async {
    try {
      await breedsBox.clear();
      for (final breed in breeds) {
        await breedsBox.put(breed.id, breed.toHiveMap());
      }
    } catch (e) {
      throw CacheException('Failed to cache breeds: $e');
    }
  }

  @override
  Future<void> clearBreeds() async {
    try {
      await breedsBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear breeds cache: $e');
    }
  }
}
