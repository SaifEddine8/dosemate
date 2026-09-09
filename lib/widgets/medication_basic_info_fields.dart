import 'package:flutter/material.dart';
import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';

class MedicationBasicInfoFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController instructionsController;
  final TextEditingController notesController;

  const MedicationBasicInfoFields({
    super.key,
    required this.nameController,
    required this.instructionsController,
    required this.notesController,
  });

  InputDecoration _buildDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      prefixIcon: Icon(icon, color: ConstantColors.primaryColor, size: 20),
      filled: true,
      fillColor: const Color(0xFFA6E3E9).withOpacity(0.08),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: ConstantColors.primaryColor.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ConstantColors.primaryColor, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اسم الدواء', style: AppStyles.subtitle),
        const SizedBox(height: 8),
        TextFormField(
          controller: nameController,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          decoration: _buildDecoration(
            hint: 'مثال: بانادول، أوميبرازول...',
            icon: Icons.medication_liquid_rounded,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال اسم الدواء';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Text('تعليمات الاستخدام', style: AppStyles.subtitle),
        const SizedBox(height: 8),
        TextFormField(
          controller: instructionsController,
          style: const TextStyle(fontSize: 14),
          decoration: _buildDecoration(
            hint: 'مثال: قبل الطعام، بعد الوجبة...',
            icon: Icons.info_outline_rounded,
          ),
        ),
        const SizedBox(height: 16),
        const Text('ملاحظات إضافية', style: AppStyles.subtitle),
        const SizedBox(height: 8),
        TextFormField(
          controller: notesController,
          maxLines: 2,
          style: const TextStyle(fontSize: 14),
          decoration: _buildDecoration(
            hint: 'أضف أي ملاحظات تود تذكرها...',
            icon: Icons.edit_note_rounded,
          ),
        ),
      ],
    );
  }
}