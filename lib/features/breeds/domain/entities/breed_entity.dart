import 'package:equatable/equatable.dart';

/// Represents a dog breed in the domain layer.
/// Contains all breed attributes displayed to the user.
class BreedEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final LifeSpan lifeSpan;
  final Weight maleWeight;
  final Weight femaleWeight;
  final bool hypoallergenic;

  const BreedEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.lifeSpan,
    required this.maleWeight,
    required this.femaleWeight,
    required this.hypoallergenic,
  });

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

/// Represents the life span range of a breed in years.
class LifeSpan extends Equatable {
  final int min;
  final int max;

  const LifeSpan({
    required this.min,
    required this.max,
  });

  @override
  List<Object?> get props => [min, max];
}

/// Represents a weight range in kilograms.
class Weight extends Equatable {
  final double min;
  final double max;

  const Weight({
    required this.min,
    required this.max,
  });

  @override
  List<Object?> get props => [min, max];
}
