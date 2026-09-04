import 'package:flutter/material.dart';

const Color neonPurple = Color(0xFFC77DFF);
const Color neonCyan = Color(0xFF00E5FF);
const Color neonViolet = Color(0xFF9B6DFF);

const Color cardBlack = Color(0xFF080A10);
const Color inputBlack = Color(0xFF101116);

class AddEmiSheet extends StatefulWidget {
  const AddEmiSheet({super.key});

  @override
  State<AddEmiSheet> createState() => _AddEmiSheetState();
}

class _AddEmiSheetState extends State<AddEmiSheet> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime selectedStartMonth = DateTime(2026, 9);

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addEmi() {
    final name = _nameController.text.trim();

    final duration = int.tryParse(
      _durationController.text.trim(),
    );

    final amount = double.tryParse(
      _amountController.text.trim(),
    );

    if (name.isEmpty ||
        duration == null ||
        duration <= 0 ||
        amount == null ||
        amount <= 0) {
      return;
    }

    Navigator.pop(
      context,
      {
        'name': name,
        'startMonth': _monthKey(selectedStartMonth),
        'durationMonths': duration,
        'defaultAmount': amount,
      },
    );
  }

  String _monthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  String _monthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add EMI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // EMI NAME
            TextField(
              controller: _nameController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: 'EMI Name',
                labelStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: inputBlack,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: neonPurple.withValues(alpha: 0.28),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: neonPurple,
                    width: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // START MONTH
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedStartMonth,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2050),
                  initialDatePickerMode: DatePickerMode.year,
                );

                if (picked == null) return;

                setState(() {
                  selectedStartMonth = DateTime(
                    picked.year,
                    picked.month,
                  );
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: inputBlack,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: neonViolet.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: neonViolet.withValues(alpha: 0.08),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: neonViolet,
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Month',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          _monthName(selectedStartMonth),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // DURATION
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: 'Duration (Months)',
                labelStyle: const TextStyle(
                  color: Colors.white54,
                ),
                suffixText: 'months',
                suffixStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: inputBlack,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: neonPurple.withValues(alpha: 0.28),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: neonPurple,
                    width: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // DEFAULT AMOUNT
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: 'Monthly Amount',
                prefixText: '₹ ',
                prefixStyle: const TextStyle(
                  color: neonPurple,
                ),
                labelStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: inputBlack,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: neonPurple.withValues(alpha: 0.28),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: neonPurple,
                    width: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ADD BUTTON
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    neonViolet,
                    neonPurple,
                    neonCyan,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: neonViolet.withValues(alpha: 0.25),
                    blurRadius: 18,
                  ),
                  BoxShadow(
                    color: neonCyan.withValues(alpha: 0.12),
                    blurRadius: 22,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _addEmi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'ADD EMI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}