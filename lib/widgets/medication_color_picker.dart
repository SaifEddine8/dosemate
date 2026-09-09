import 'package:flutter/material.dart';
import 'package:dosemate/core/constant/app_style.dart';

class MedicationColorPicker extends StatelessWidget {
  final Color selectedColor;
  final List<Color> colors;
  final ValueChanged<Color> onColorSelected;

  const MedicationColorPicker({
    super.key,
    required this.selectedColor,
    required this.colors,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('تمييز بدبوس لون', style: AppStyles.subtitle),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: .spaceAround,
          children: colors.map((color) {
            final isSelected = color == selectedColor;
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 44 : 36,
                height: isSelected ? 44 : 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}