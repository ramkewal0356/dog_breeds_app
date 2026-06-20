import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/breed_entity.dart';

class BreedModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final LifeSpanModel lifeSpan;
  final WeightModel maleWeight;
  final WeightModel femaleWeight;
  final bool hypoallergenic;

  const BreedModel({
    required this.id,
    required this.name,
    required this.description,
    required this.lifeSpan,
    required this.maleWeight,
    required this.femaleWeight,
    required this.hypoallergenic,
  });

  /// Parse API response
  factory BreedModel.fromJsonApi(Map<String, dynamic> json) {
    try {
      final attributes = json['attributes'] != null
          ? Map<String, dynamic>.from(json['attributes'] as Map)
          : <String, dynamic>{};

      return BreedModel(
        id: json['id'] as String? ?? '',
        name: attributes['name'] as String? ?? '',
        description: attributes['description'] as String? ?? '',
        hypoallergenic: attributes['hypoallergenic'] as bool? ?? false,
        lifeSpan: LifeSpanModel.fromJson(
          attributes['life'] != null
              ? Map<String, dynamic>.from(attributes['life'] as Map)
              : <String, dynamic>{},
        ),
        maleWeight: WeightModel.fromJson(
          attributes['male_weight'] != null
              ? Map<String, dynamic>.from(attributes['male_weight'] as Map)
              : <String, dynamic>{},
        ),
        femaleWeight: WeightModel.fromJson(
          attributes['female_weight'] != null
              ? Map<String, dynamic>.from(attributes['female_weight'] as Map)
              : <String, dynamic>{},
        ),
      );
    } catch (e) {
      throw ParseException('Failed to parse breed data: $e');
    }
  }

  /// Convert to Hive map
  Map<String, dynamic> toHiveMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lifeSpan': lifeSpan.toMap(),
      'maleWeight': maleWeight.toMap(),
      'femaleWeight': femaleWeight.toMap(),
      'hypoallergenic': hypoallergenic,
    };
  }

  /// Parse Hive map
  factory BreedModel.fromHiveMap(Map<String, dynamic> map) {
    try {
      return BreedModel(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        description: map['description'] as String? ?? '',
        lifeSpan: LifeSpanModel.fromMap(
          map['lifeSpan'] != null
              ? Map<String, dynamic>.from(map['lifeSpan'] as Map)
              : <String, dynamic>{},
        ),
        maleWeight: WeightModel.fromMap(
          map['maleWeight'] != null
              ? Map<String, dynamic>.from(map['maleWeight'] as Map)
              : <String, dynamic>{},
        ),
        femaleWeight: WeightModel.fromMap(
          map['femaleWeight'] != null
              ? Map<String, dynamic>.from(map['femaleWeight'] as Map)
              : <String, dynamic>{},
        ),
        hypoallergenic: map['hypoallergenic'] as bool? ?? false,
      );
    } catch (e) {
      throw ParseException('Failed to parse cached breed data: $e');
    }
  }

  factory BreedModel.fromEntity(BreedEntity entity) {
    return BreedModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      lifeSpan: LifeSpanModel(
        min: entity.lifeSpan.min,
        max: entity.lifeSpan.max,
      ),
      maleWeight: WeightModel(
        min: entity.maleWeight.min,
        max: entity.maleWeight.max,
      ),
      femaleWeight: WeightModel(
        min: entity.femaleWeight.min,
        max: entity.femaleWeight.max,
      ),
      hypoallergenic: entity.hypoallergenic,
    );
  }

  BreedEntity toEntity() {
    return BreedEntity(
      id: id,
      name: name,
      description: description,
      lifeSpan: LifeSpan(min: lifeSpan.min, max: lifeSpan.max),
      maleWeight: Weight(min: maleWeight.min, max: maleWeight.max),
      femaleWeight: Weight(min: femaleWeight.min, max: femaleWeight.max),
      hypoallergenic: hypoallergenic,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    lifeSpan,
    maleWeight,
    femaleWeight,
    hypoallergenic,
  ];
}

class LifeSpanModel extends Equatable {
  final int min;
  final int max;

  const LifeSpanModel({required this.min, required this.max});

  factory LifeSpanModel.fromJson(Map<String, dynamic> json) {
    return LifeSpanModel(
      min: (json['min'] as num?)?.toInt() ?? 0,
      max: (json['max'] as num?)?.toInt() ?? 0,
    );
  }

  factory LifeSpanModel.fromMap(Map<String, dynamic> map) {
    return LifeSpanModel(
      min: (map['min'] as num?)?.toInt() ?? 0,
      max: (map['max'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'min': min, 'max': max};
  }

  @override
  List<Object?> get props => [min, max];
}

class WeightModel extends Equatable {
  final double min;
  final double max;

  const WeightModel({required this.min, required this.max});

  factory WeightModel.fromJson(Map<String, dynamic> json) {
    return WeightModel(
      min: (json['min'] as num?)?.toDouble() ?? 0.0,
      max: (json['max'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory WeightModel.fromMap(Map<String, dynamic> map) {
    return WeightModel(
      min: (map['min'] as num?)?.toDouble() ?? 0.0,
      max: (map['max'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'min': min, 'max': max};
  }

  @override
  List<Object?> get props => [min, max];
}
