import 'package:flutter/material.dart';

import '../../data/models/emi_model.dart';

const Color neonPurple = Color(0xFFC77DFF);
const Color neonCyan = Color(0xFF00E5FF);
const Color neonViolet = Color(0xFF9B6DFF);

const Color cardBlack = Color(0xFF080A10);
const Color inputBlack = Color(0xFF101116);

class EditEmiSheet extends StatefulWidget {
  final EmiModel emi;
  final String monthKey;
  final double currentAmount;

  const EditEmiSheet({
    super.key,
    required this.emi,
    required this.monthKey,
    required this.currentAmount,
  });

  @override
  State<EditEmiSheet> createState() => _EditEmiSheetState();
}

class _EditEmiSheetState extends State<EditEmiSheet> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(
      text: widget.currentAmount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    final amount = double.tryParse(
      _amountController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      return;
    }

    Navigator.pop(
      context,
      amount,
    );
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
            Text(
              'Edit ${widget.emi.name}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _formatMonth(widget.monthKey),
              style: const TextStyle(
                color: neonViolet,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _amountController,
              autofocus: true,
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
                onPressed: _save,
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
                  'SAVE CHANGES',
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

  String _formatMonth(String monthKey) {
    final parts = monthKey.split('-');

    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);

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

    return '${months[month - 1]} $year';
  }
}