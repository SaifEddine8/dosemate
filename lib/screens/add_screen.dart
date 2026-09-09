import 'package:dosemate/db/user.dart';
import 'package:dosemate/models/medication.dart';
import 'package:dosemate/widgets/medication_basic_info_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dosemate/models/dose_reminder.dart';
import 'package:dosemate/bloc/reminder/reminder_bloc.dart';
import 'package:dosemate/bloc/reminder/reminder_event.dart';
import 'package:dosemate/bloc/reminder/reminder_state.dart';

import 'package:dosemate/widgets/dosage_and_unit_selector.dart';
import 'package:dosemate/widgets/reminder_times_picker.dart';
import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _notesController = TextEditingController();
  final _amountController = TextEditingController(text: '1');

  final _stockController = TextEditingController(text: '30');
  final _refillThresholdController = TextEditingController(text: '5');

  String _selectedUnit = 'قرص / حبة';
  final List<String> _units = ['قرص / حبة', 'مل (ml)', 'كبسولة', 'قطرة', 'بخّة'];

  final List<TimeOfDay> _selectedTimes = [];

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  String _selectedFrequency = 'يومياً';
  final List<String> _frequencies = ['يومياً', 'أسبوعياً', 'حسب الحاجة'];

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _notesController.dispose();
    _amountController.dispose();
    _stockController.dispose();
    _refillThresholdController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }

  void _pickTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((picked) {
      if (picked != null && !_selectedTimes.contains(picked)) {
        setState(() {
          _selectedTimes.add(picked);
        });
      }
    });
  }

  void _pickStartDate() {
    showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    ).then((picked) {
      if (picked != null) {
        setState(() {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate)) {
            _endDate = null;
          }
        });
      }
    });
  }

  void _pickEndDate() {
    showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 7)),
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    ).then((picked) {
      if (picked != null) {
        setState(() {
          _endDate = picked;
        });
      }
    });
  }

  void _saveMedication() {
    if (_formKey.currentState!.validate()) {
      if (_selectedTimes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى إضافة وقت تنبيه واحد على الأقل', textAlign: TextAlign.right),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final double parsedAmount = double.tryParse(_amountController.text.trim()) ?? 1.0;
      final int parsedStock = int.tryParse(_stockController.text.trim()) ?? 30;
      final int parsedThreshold = int.tryParse(_refillThresholdController.text.trim()) ?? 5;
      final String medName = _nameController.text.trim();

      final newMedication = Medication(
        userId: 1, 
        name: medName,
        form: _selectedUnit,
        strength: _notesController.text.trim(), 
        stockQuantity: parsedStock,
        refillThreshold: parsedThreshold,
        instructions: _instructionsController.text.trim(),
      );

      for (final time in _selectedTimes) {
        final newReminder = DoseReminder(
          userId: currentUser!.id,
          name: medName,
          medicationId: newMedication.id, 
          reminderTime: time,
          frequency: _selectedFrequency,
          startDate: _startDate,
          endDate: _endDate,
          isActive: true,
          dosageAmount: parsedAmount,
          status: 'pending',
          snoonzedUntil: null,
        );

        context.read<ReminderBloc>().add(AddReminder(newReminder));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تمت إضافة الدواء والتذكير بنجاح!', textAlign: TextAlign.right),
          backgroundColor: Colors.green,
        ),
      );

      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.tertiaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'إضافة دواء جديد',
          style: AppStyles.pageTitle.copyWith(
            color: ConstantColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<ReminderBloc, ReminderState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: ConstantColors.primaryColor.withOpacity(0.06),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MedicationBasicInfoFields(
                          nameController: _nameController,
                          instructionsController: _instructionsController,
                          notesController: _notesController,
                        ),
                        const SizedBox(height: 22),

                        DosageAndUnitSelector(
                          amountController: _amountController,
                          selectedUnit: _selectedUnit,
                          units: _units,
                          onUnitChanged: (val) {
                            if (val != null) setState(() => _selectedUnit = val);
                          },
                        ),
                        const SizedBox(height: 22),

                        const Text(
                          'إدارة المخزون (الصيدلية)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF135A55),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _stockController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  labelText: 'الكمية المتوفرة',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _refillThresholdController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  labelText: 'تنبيه النفاذ عند',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        DropdownButtonFormField<String>(
                          value: _selectedFrequency,
                          alignment: Alignment.centerRight,
                          decoration: InputDecoration(
                            labelText: 'طريقة التكرار',
                            prefixIcon: const Icon(Icons.repeat),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: _frequencies.map((freq) {
                            return DropdownMenuItem(
                              value: freq,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(freq),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedFrequency = value);
                            }
                          },
                        ),
                        const SizedBox(height: 22),

                        const Text(
                          'فترة العلاج',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF135A55),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickStartDate,
                                icon: const Icon(Icons.calendar_today, size: 18),
                                label: Text(
                                  'البدء: ${_formatDate(_startDate)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickEndDate,
                                icon: const Icon(Icons.event_busy, size: 18),
                                label: Text(
                                  _endDate == null
                                      ? 'الانتهاء: (مزمن)'
                                      : 'الانتهاء: ${_formatDate(_endDate!)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _endDate == null ? Colors.grey.shade600 : Colors.black,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_endDate != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => setState(() => _endDate = null),
                              child: const Text(
                                'جعل الدواء مستمراً (بدون تاريخ انتهاء)',
                                style: TextStyle(fontSize: 12, color: Colors.redAccent),
                              ),
                            ),
                          ),
                        const SizedBox(height: 22),

                        ReminderTimesPicker(
                          selectedTimes: _selectedTimes,
                          onAddTime: _pickTime,
                          onRemoveTime: (index) {
                            setState(() => _selectedTimes.removeAt(index));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ConstantColors.primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _saveMedication,
                      child: const Text(
                        'حفظ الدواء',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}