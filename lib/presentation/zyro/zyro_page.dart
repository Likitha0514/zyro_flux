import 'package:flutter/material.dart';

import '../../core/app_dependencies.dart';
import '../../data/models/emi_model.dart';
import 'add_emi_sheet.dart';
import 'edit_emi_sheet.dart';

const Color neonPurple = Color(0xFFC77DFF);
const Color neonCyan = Color(0xFF00E5FF);
const Color neonBlue = Color(0xFF4DA6FF);
const Color neonGreen = Color(0xFF00E676);
const Color neonRed = Color(0xFFFF4F87);
const Color neonViolet = Color(0xFF9B6DFF);
const Color cardBlack = Color(0xFF080A10);
const Color inputBlack = Color(0xFF101116);

class ZyroPage extends StatefulWidget {
  final AppDependencies dependencies;

  const ZyroPage({super.key, required this.dependencies});

  @override
  State<ZyroPage> createState() => _ZyroPageState();
}

class _ZyroPageState extends State<ZyroPage> {
  DateTime selectedMonth = DateTime(2026, 9);

  List<EmiModel> emis = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmis();
  }

  @override
  Widget build(BuildContext context) {
    final activeEmis = emis
        .where((emi) => _isEmiActiveForMonth(emi, selectedMonth))
        .toList();

    final totalEmi = activeEmis.fold<double>(0, (total, emi) {
      return total + _amountForMonth(emi, selectedMonth);
    });

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,

        title: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [neonViolet, neonRed, neonCyan],
            ).createShader(bounds);
          },
          child: const Text(
            'ZYRO',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),

        actions: [
          IconButton(
            onPressed: _showClearEmisSheet,
            icon: const Icon(Icons.delete_sweep_outlined, color: neonPurple),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MONTH SELECTOR
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: cardBlack,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: neonViolet.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: neonViolet.withValues(alpha: 0.4),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedMonth = DateTime(
                            selectedMonth.year,
                            selectedMonth.month - 1,
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        color: neonCyan,
                        size: 28,
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'SELECTED MONTH',
                            style: TextStyle(
                              color: Color(0xFF8E96A8),
                              fontSize: 10,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _monthName(selectedMonth),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedMonth = DateTime(
                            selectedMonth.year,
                            selectedMonth.month + 1,
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.chevron_right,
                        color: neonCyan,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'YOUR EMIs',
                style: TextStyle(
                  color: Color(0xFF9CA3B0),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              // EMI LIST
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: neonCyan),
                      )
                    : activeEmis.isEmpty
                    ? const Center(
                        child: Text(
                          'No EMIs for this month',
                          style: TextStyle(color: Colors.white38, fontSize: 15),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 12),
                        itemCount: activeEmis.length,
                        itemBuilder: (context, index) {
                          final emi = activeEmis[index];

                          return _EmiCard(
                            name: emi.name,
                            amount: _amountForMonth(emi, selectedMonth),
                            accentColor: _emiAccentColor(index),
                            onEdit: () => _editEmi(emi),
                            onDelete: () => _deleteEmi(emi),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 12),

              // TOTAL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: cardBlack,
                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(color: neonViolet.withValues(alpha: 0.55)),

                  boxShadow: [
                    BoxShadow(
                      color: neonViolet.withValues(alpha: 0.5),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: neonCyan.withValues(alpha: 0.04),
                      blurRadius: 20,
                    ),
                  ],
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL MONTHLY EMI',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),

                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [neonGreen, neonCyan],
                        ).createShader(bounds);
                      },
                      child: Text(
                        '₹${totalEmi.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ADD EMI
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [neonViolet, neonPurple, neonCyan],
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
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result =
                        await showModalBottomSheet<Map<String, dynamic>>(
                          context: context,
                          backgroundColor: const Color(0xFF0B0B10),
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) => const AddEmiSheet(),
                        );

                    if (result == null) {
                      return;
                    }

                    final emi = EmiModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: result['name'] as String,
                      startMonth: result['startMonth'] as String,
                      durationMonths: result['durationMonths'] as int,
                      defaultAmount: result['defaultAmount'] as double,
                      monthlyAmounts: {},
                    );

                    await widget.dependencies.addEmi(emi);

                    await _loadEmis();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'ADD EMI',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _emiAccentColor(int index) {
    const colors = [neonPurple, neonCyan, neonBlue];

    return colors[index % colors.length];
  }

  Future<void> _showClearEmisSheet() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF15151B),
          title: const Text(
            'Clear all EMIs?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'This will permanently remove all saved EMIs.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'CLEAR ALL',
                style: TextStyle(color: neonRed, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await widget.dependencies.clearEmis();

    await _loadEmis();
  }

  Future<void> _deleteEmi(EmiModel emi) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF15151B),

          title: const Text(
            'Delete EMI?',
            style: TextStyle(color: Colors.white),
          ),

          content: Text(
            'Are you sure you want to delete "${emi.name}"?',
            style: const TextStyle(color: Colors.white70),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white54),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('DELETE', style: TextStyle(color: neonRed)),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await widget.dependencies.deleteEmi(emi.id);

    await _loadEmis();
  }

  Future<void> _editEmi(EmiModel emi) async {
    final monthKey =
        '${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}';

    final currentAmount = _amountForMonth(emi, selectedMonth);

    final newAmount = await showModalBottomSheet<double>(
      context: context,
      backgroundColor: const Color(0xFF0B0B10),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => EditEmiSheet(
        emi: emi,
        monthKey: monthKey,
        currentAmount: currentAmount,
      ),
    );

    if (newAmount == null) {
      return;
    }

    final updatedMonthlyAmounts = Map<String, double>.from(emi.monthlyAmounts);

    updatedMonthlyAmounts[monthKey] = newAmount;

    final updatedEmi = EmiModel(
      id: emi.id,
      name: emi.name,
      startMonth: emi.startMonth,
      durationMonths: emi.durationMonths,
      defaultAmount: emi.defaultAmount,
      monthlyAmounts: updatedMonthlyAmounts,
    );

    await widget.dependencies.updateEmi(updatedEmi);

    await _loadEmis();
  }

  Future<void> _loadEmis() async {
    final result = await widget.dependencies.getEmis();

    if (!mounted) return;

    setState(() {
      emis = result;
      isLoading = false;
    });
  }

  bool _isEmiActiveForMonth(EmiModel emi, DateTime month) {
    final parts = emi.startMonth.split('-');

    final start = DateTime(int.parse(parts[0]), int.parse(parts[1]));

    final monthDifference =
        (month.year - start.year) * 12 + (month.month - start.month);

    return monthDifference >= 0 && monthDifference < emi.durationMonths;
  }

  double _amountForMonth(EmiModel emi, DateTime month) {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';

    return emi.monthlyAmounts[monthKey] ?? emi.defaultAmount;
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
}

class _EmiCard extends StatelessWidget {
  final String name;
  final double amount;
  final Color accentColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmiCard({
    required this.name,
    required this.amount,
    required this.accentColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: accentColor.withValues(alpha: 0.5)),

        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),

      child: Row(
        children: [
          // EMI ICON
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: accentColor.withValues(alpha: 0.08),

              border: Border.all(color: accentColor.withValues(alpha: 0.25)),

              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.08),
                  blurRadius: 12,
                ),
              ],
            ),

            child: Icon(
              Icons.credit_card_rounded,
              color: accentColor,
              size: 21,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color(0xFF101116),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (context) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              ListTile(
                                contentPadding: EdgeInsets.zero,

                                leading: const Icon(
                                  Icons.edit_outlined,
                                  color: neonCyan,
                                ),

                                title: const Text(
                                  'Edit EMI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),

                                onTap: () {
                                  Navigator.pop(context);
                                  onEdit();
                                },
                              ),

                              ListTile(
                                contentPadding: EdgeInsets.zero,

                                leading: const Icon(
                                  Icons.delete_outline,
                                  color: neonRed,
                                ),

                                title: const Text(
                                  'Delete EMI',
                                  style: TextStyle(
                                    color: neonRed,
                                    fontSize: 16,
                                  ),
                                ),

                                onTap: () {
                                  Navigator.pop(context);
                                  onDelete();
                                },
                              ),

                              const SizedBox(height: 8),

                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },

                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white54,
                                    side: const BorderSide(
                                      color: Colors.white12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),

                                  child: const Text('CANCEL'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },

                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.white54,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
