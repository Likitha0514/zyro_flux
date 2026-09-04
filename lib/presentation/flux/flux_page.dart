import 'package:flutter/material.dart';
import 'package:zyro_flux/data/models/transaction_model.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../core/app_dependencies.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

const Color neonPurple = Color(0xFFC77DFF);
const Color neonCyan = Color(0xFF00E5FF);
const Color neonViolet = Color(0xFF9B6DFF);

const Color cardBlack = Color(0xFF080A10);
const Color inputBlack = Color(0xFF101116);

class FluxPage extends StatefulWidget {
  final AppDependencies dependencies;

  const FluxPage({super.key, required this.dependencies});

  @override
  State<FluxPage> createState() => _FluxPageState();
}

class _FluxPageState extends State<FluxPage> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String transactionType = 'income';
  List<TransactionModel> transactions = [];
  bool isLoading = true;
  bool showSummary = false;
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final result = await widget.dependencies.getTransactions();

      if (!mounted) return;

      setState(() {
        transactions = result.reversed.toList();
      });
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  double get totalIncome {
    return widget.dependencies.calculateBalance.income(transactions);
  }

  double get totalSpent {
    return widget.dependencies.calculateBalance.spent(transactions);
  }

  double get balance {
    return widget.dependencies.calculateBalance.balance(transactions);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addTransaction() async {
    final amount = double.tryParse(_amountController.text.trim());

    final description = _descriptionController.text.trim();

    if (amount == null || amount <= 0 || description.isEmpty) {
      return;
    }

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: transactionType,
      amount: amount,
      description: description,
      date: DateTime.now(),
    );

    await widget.dependencies.addTransaction(transaction);

    _amountController.clear();
    _descriptionController.clear();

    if (!mounted) return;
    final result = await widget.dependencies.getTransactions();

    setState(() {
      transactions = result.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [neonViolet, Color(0xFFFF4F87), neonCyan],
            ).createShader(bounds);
          },
          child: const Text(
            'FLUX',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _startFresh,
            icon: const Icon(Icons.delete_sweep_outlined, color: neonPurple),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ADD TRANSACTION',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 14),

              // TYPE
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: cardBlack,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: neonViolet.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _typeButton(title: 'INCOME', value: 'income'),
                    ),
                    Expanded(
                      child: _typeButton(title: 'SPENT', value: 'spent'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // AMOUNT
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(label: 'Amount', prefix: '₹ '),
              ),

              const SizedBox(height: 16),

              // DESCRIPTION
              TextField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                decoration: _inputDecoration(label: 'Description'),
              ),

              const SizedBox(height: 20),

              // ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: Container(
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
                            color: neonViolet.withValues(alpha: 0.5),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _addTransaction,
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'ADD',
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
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: neonCyan.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: neonCyan.withValues(alpha: 0.08),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            showSummary = true;
                          });
                        },
                        icon: const Icon(Icons.calculate_outlined),
                        label: const Text(
                          'CALCULATE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: neonCyan,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (showSummary) ...[
                const SizedBox(height: 20),
                _buildSummaryCard(),
              ],
              const SizedBox(height: 24),

              const Text(
                'TRANSACTIONS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              if (isLoading)
                const Center(child: CircularProgressIndicator(color: neonCyan))
              else if (transactions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No transactions yet',
                      style: TextStyle(color: Colors.white38, fontSize: 15),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];

                    final isIncome = transaction.type == 'income';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBlack,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (isIncome ? neonCyan : neonViolet).withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isIncome
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            color: isIncome ? neonCyan : neonViolet,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  _formatDate(transaction.date),
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            '${isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: isIncome ? neonCyan : neonViolet,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: neonViolet.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: neonViolet.withValues(alpha: 0.08), blurRadius: 16),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _summaryItem(title: 'INCOME', amount: totalIncome, color: neonCyan),
          _summaryItem(title: 'SPENT', amount: totalSpent, color: neonViolet),
          _summaryItem(
            title: 'BALANCE',
            amount: balance,
            color: balance >= 0 ? neonCyan : neonPurple,
          ),
          IconButton(
            onPressed: _downloadReport,
            icon: const Icon(Icons.download_outlined, color: neonCyan),
            tooltip: 'Download Report',
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required String title,
    required double amount,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _downloadReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Text(
              'FLUX TRANSACTION REPORT',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              'SUMMARY',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 8),

            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _pdfCell('Income', bold: true),
                    _pdfCell('Spent', bold: true),
                    _pdfCell('Balance', bold: true),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _pdfCell('Rs ${totalIncome.toStringAsFixed(2)}'),
                    _pdfCell('Rs ${totalSpent.toStringAsFixed(2)}'),
                    _pdfCell('Rs ${balance.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 24),

            pw.Text(
              'TRANSACTIONS',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 8),

            pw.Table.fromTextArray(
              headers: ['Date', 'Type', 'Description', 'Amount'],
              data: transactions.map((transaction) {
                return [
                  _formatDate(transaction.date),
                  transaction.type.toUpperCase(),
                  transaction.description,
                  '₹${transaction.amount.toStringAsFixed(2)}',
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    final directory = Directory('/storage/emulated/0/Download');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final file = File(
      '${directory.path}/FLUX_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );

    await file.writeAsBytes(await pdf.save(), flush: true);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloaded successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  pw.Widget _pdfCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  Widget _typeButton({required String title, required String value}) {
    final isSelected = transactionType == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          transactionType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: isSelected
              ? const LinearGradient(colors: [neonViolet, neonPurple])
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startFresh() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF15151B),
          title: const Text(
            'Delete all transactions?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'This will permanently remove all FLUX transactions.',
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
                'DELETE',
                style: TextStyle(
                  color: neonPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await widget.dependencies.clearTransactions();

    if (!mounted) return;

    setState(() {
      transactions = [];
      showSummary = false;
    });
  }

  InputDecoration _inputDecoration({required String label, String? prefix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      prefixText: prefix,
      prefixStyle: const TextStyle(color: neonPurple),
      filled: true,
      fillColor: inputBlack,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: neonPurple.withValues(alpha: 0.28)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: neonPurple, width: 1.2),
      ),
    );
  }
}
