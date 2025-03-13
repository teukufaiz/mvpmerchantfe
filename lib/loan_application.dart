import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:new_apps/loan_asset.dart';

class LoanApplications extends StatefulWidget {
  const LoanApplications({Key? key}) : super(key: key);

  @override
  State<LoanApplications> createState() => _LoanApplicationsState();
}

class _LoanApplicationsState extends State<LoanApplications> {
  final TextEditingController _nominalController = TextEditingController();
  int _selectedTenorIndex = -1; // No tenor selected initially
  final List<int> _tenorOptions = [3, 6, 12, 24]; // Tenor options in months
  
  // Loan details that will be calculated - using BigInt for very large numbers
  BigInt _loanAmount = BigInt.zero;
  int _tenor = 0;
  BigInt _totalInterest = BigInt.zero;
  BigInt _totalPayment = BigInt.zero;
  BigInt _monthlyPayment = BigInt.zero;
  BigInt _dailyPayment = BigInt.zero;
  String _firstPaymentDate = '';
  double _lateFeePercentage = 0.1; // 0.1% per day

  bool _isFormFilled = false;
  
  // Indonesian Rupiah formatter
  final NumberFormat _formatter = NumberFormat('#,###', 'id_ID');

  // Using the math library for more precise calculations
  void _calculateLoan() {
    if (_nominalController.text.isEmpty || _selectedTenorIndex == -1) {
      setState(() {
        _isFormFilled = false;
      });
      return;
    }

    // Parse the loan amount from the input - properly handling commas
    String numericString = _nominalController.text.replaceAll(RegExp(r'[^0-9]'), '');
    _loanAmount = BigInt.tryParse(numericString) ?? BigInt.zero;
    
    _tenor = _tenorOptions[_selectedTenorIndex];

    // Calculate loan details using BigInt for handling very large numbers
    // Interest rate: 3% per month
    double interestRate = 0.03;
    
    // Calculate total interest (loan amount * interest rate * tenure)
    double interestFactor = interestRate * _tenor;
    _totalInterest = BigInt.from((_loanAmount.toDouble() * interestFactor).round());
    
    // Total payment = principal + interest
    _totalPayment = _loanAmount + _totalInterest;
    
    // Monthly payment (total payment / tenure)
    _monthlyPayment = _totalPayment ~/ BigInt.from(_tenor);
    
    // Daily payment (monthly payment / 30 days)
    _dailyPayment = _monthlyPayment ~/ BigInt.from(30);
    
    // Set first payment date using math for date calculation
    final now = DateTime.now();
    final nextMonth = now.month < 12 ? now.month + 1 : 1;
    final nextYear = now.month < 12 ? now.year : now.year + 1;
    final firstPayment = DateTime(nextYear, nextMonth, math.min(now.day, 28));
    _firstPaymentDate = DateFormat('dd MMMM yyyy', 'id_ID').format(firstPayment);

    setState(() {
      _isFormFilled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Masukkan Detail Pengajuan',
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nominal Input Section
              Row(
                children: [
                  const Text(
                    'Masukkan Nominal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ex: 50,000,000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    return;
                  }
                  
                  // Remove all non-numeric characters
                  String numericOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                  
                  if (numericOnly.isNotEmpty) {
                    // Using BigInt to handle extremely large numbers
                    BigInt parsedValue = BigInt.tryParse(numericOnly) ?? BigInt.zero;
                    
                    // Convert to regular int for formatting if within int range
                    String formatted;
                    if (parsedValue < BigInt.from(9007199254740991)) { // JavaScript's Number.MAX_SAFE_INTEGER
                      formatted = _formatter.format(parsedValue.toInt());
                    } else {
                      // Custom formatting for extremely large numbers
                      String valueStr = parsedValue.toString();
                      String result = '';
                      for (int i = 0; i < valueStr.length; i++) {
                        if (i > 0 && (valueStr.length - i) % 3 == 0) {
                          result += ',';
                        }
                        result += valueStr[i];
                      }
                      formatted = result;
                    }
                    
                    // Only update if the formatted value is different
                    if (formatted != value) {
                      _nominalController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  }
                  _calculateLoan();
                },
              ),
              const SizedBox(height: 4),
              Text(
                'Ambil pinjaman hingga Rp50.000.000',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Tenor Selection
              Row(
                children: [
                  const Text(
                    'Pilih Tenggat Waktu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(
                  _tenorOptions.length,
                  (index) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index < _tenorOptions.length - 1 ? 8.0 : 0,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedTenorIndex = index;
                          });
                          _calculateLoan();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedTenorIndex == index
                              ? Colors.blue.shade50
                              : Colors.grey.shade200,
                          foregroundColor: _selectedTenorIndex == index
                              ? Colors.blue
                              : Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: _selectedTenorIndex == index
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: Text(
                          '${_tenorOptions[index]} bulan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: _selectedTenorIndex == index
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Loan Details Summary
              if (_isFormFilled) ...[
                const Text(
                  'Rincian Peminjaman',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Jumlah Pinjaman', 'Rp${_formatBigInt(_loanAmount)}'),
                      _buildDetailRow('Tenggat Waktu', '$_tenor bulan'),
                      _buildDetailRow('Total Bunga (3%)', 'Rp${_formatBigInt(_totalInterest)}'),
                      _buildDetailRow('Total Cicilan', 'Rp${_formatBigInt(_totalPayment)}'),
                      _buildDetailRow('Cicilan per Bulan', 'Rp${_formatBigInt(_monthlyPayment)}'),
                      _buildDetailRow('Potongan Harian', 'Rp${_formatBigInt(_dailyPayment)}'),
                      _buildDetailRow('Jatuh Tempo Pertama', _firstPaymentDate),
                      _buildDetailRow(
                        'Denda Keterlambatan',
                        '',
                        showBorder: false,
                        valueWidget: Container(
                          constraints: const BoxConstraints(maxWidth: 180),  // Limit width here
                          child: Text(
                            '$_lateFeePercentage% dari jumlah pinjaman yang tertunggak/hari',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'Rincian Pencairan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Jumlah Pinjaman', 'Rp${_formatBigInt(_loanAmount)}'),
                      _buildDetailRow(
                        'Total Pencairan',
                        'Rp${_formatBigInt(_loanAmount)}',
                        showBorder: false,
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormFilled ? () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoanAssets()));
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0C50EF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.blue.withOpacity(0.5),
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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

  // Custom formatter for BigInt values
  String _formatBigInt(BigInt value) {
    if (value < BigInt.from(9007199254740991)) { // JavaScript's MAX_SAFE_INTEGER
      return _formatter.format(value.toInt());
    } else {
      // Manual formatting for extremely large numbers
      String valueStr = value.toString();
      String result = '';
      for (int i = 0; i < valueStr.length; i++) {
        if (i > 0 && (valueStr.length - i) % 3 == 0) {
          result += ',';
        }
        result += valueStr[i];
      }
      return result;
    }
  }

  Widget _buildDetailRow(String label, String value, {bool showBorder = true, Widget? valueWidget}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(bottom: BorderSide(color: Colors.grey.shade300))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          valueWidget ?? Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        ],
      ),
    );
  }
}
