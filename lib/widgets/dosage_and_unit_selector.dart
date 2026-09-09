import 'package:flutter/material.dart';
import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';

class DosageAndUnitSelector extends StatelessWidget {
  final TextEditingController amountController;
  final String selectedUnit;
  final List<String> units;
  final ValueChanged<String?> onUnitChanged;

  const DosageAndUnitSelector({
    super.key,
    required this.amountController,
    required this.selectedUnit,
    required this.units,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('الجرعة والوحدة', style: AppStyles.subtitle),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'الكمية',
                  prefixIcon: const Icon(Icons.pin_outlined, color: ConstantColors.primaryColor, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFA6E3E9).withOpacity(0.08),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: ConstantColors.primaryColor.withOpacity(0.15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: ConstantColors.primaryColor, width: 1.8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل الكمية';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFA6E3E9).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ConstantColors.primaryColor.withOpacity(0.15)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedUnit,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: ConstantColors.primaryColor),
                    items: units.map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit, style: AppStyles.body.copyWith(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: onUnitChanged,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}