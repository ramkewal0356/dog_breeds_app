import 'package:flutter/material.dart';

import '../../domain/entities/breed_entity.dart';

class BreedCard extends StatelessWidget {
  final BreedEntity breed;

  const BreedCard({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breed name and hypoallergenic badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    breed.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (breed.hypoallergenic)
                  Chip(
                    label: const Text('Hypoallergenic'),
                    labelStyle: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                    backgroundColor: colorScheme.secondaryContainer,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              breed.description,
              style: textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Life span, male weight, female weight
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.schedule,
                  label: '${breed.lifeSpan.min}–${breed.lifeSpan.max} years',
                  colorScheme: colorScheme,
                ),
                _InfoChip(
                  icon: Icons.male,
                  label:
                      '${_formatWeight(breed.maleWeight.min)}–${_formatWeight(breed.maleWeight.max)} kg',
                  colorScheme: colorScheme,
                ),
                _InfoChip(
                  icon: Icons.female,
                  label:
                      '${_formatWeight(breed.femaleWeight.min)}–${_formatWeight(breed.femaleWeight.max)} kg',
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Formats a weight value, removing the decimal point if it's a whole number.
  String _formatWeight(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }
}

/// A small info chip displaying an icon and label for breed metadata.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
