import 'package:flutter/material.dart';
import 'package:new_apps/loan_application.dart';
import 'package:new_apps/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IntroModal extends StatefulWidget  {
  const IntroModal({Key? key}) : super(key: key);

  @override
  _IntroModalState createState() => _IntroModalState();
}

class _IntroModalState extends State<IntroModal> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        title: Text("Livin' Modal Merchant"),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/ilustration03.png',
                  height: 320,
                  width: 320,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Kembangkan Bisnis dengan Livin' Modal Merchant",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  "Kini mengembangkan bisnis jadi lebih mudah! Dapatkan pinjaman usaha dengan pencairan cepat dan pembayaran otomatis dari transaksi digital Anda.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF808080),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                // Feature list
                _buildFeatureItem("Pinjaman cepat cair"),
                const SizedBox(height: 12),
                _buildFeatureItem("Pembayaran otomatis dari transaksi"),
                const SizedBox(height: 12),
                _buildFeatureItem("Pengajuan mudah, tanpa ribet"),
                const SizedBox(height: 12),
                _buildFeatureItem("Limit hingga Rp100 juta"),
                const SizedBox(height: 40),
                SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Modal()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A56DB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Pelajari Lebih Lanjut",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ],
            )
          ],
        ),
        
      ),
    ));
  }

  Widget _buildFeatureItem(String text){
     return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF34D399),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
class Modal extends StatefulWidget{
  const Modal({Key? key}) : super(key: key);

  @override
  State<Modal> createState() => _ModalState();
}


class _ModalState extends State<Modal>{
  Map<String, dynamic> ? userData;
  double totalApprovedLoans = 0;
  List<dynamic> loans = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('userData');

    if (userJson != null) {
      setState(() {
        userData = jsonDecode(userJson);
      });

      fetchLoans();
      fetchTotalApprovedLoans();
    }
  }

  String formatCurrency(double amount) {
    return "Rp. ${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  Future<void> fetchLoans() async {
    int userId = userData!['user_id'];
    final url = 'https://merchantbackend-long-shape-7140.fly.dev/loan/get_loans/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          loans = (data['loans'] as List)
              .map((loan) => LoanApplication.fromJson(loan))
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching loans: $e");
    }
  }

  Future<void> fetchTotalApprovedLoans() async {
    int userId = userData!['user_id'];
    final url = 'https://merchantbackend-long-shape-7140.fly.dev/loan/total_approved_loans/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          totalApprovedLoans = data['total_approved_loans'];
        });
      }
    } catch (e) {
      print("Error fetching total approved loans: $e");
    }
  }

  Future<void> cancelLoan(int loanId, BuildContext context) async {
    final url = 'https://merchantbackend-long-shape-7140.fly.dev/loan/delete_loan/$loanId';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Loan canceled successfully")),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Modal()));
      } else {
        print("Failed to cancel loan");
      }
    } catch (e) {
      print("Error canceling loan: $e");
    }
  }

  // void showCancelDialog(int loanId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Apakah kamu ingin membatalkan peminjaman?", style: TextStyle(fontWeight: FontWeight.bold)),
  //         content: Text("Jika Anda membatalkan pengajuan ini, proses pinjaman tidak akan dilanjutkan. Tindakan ini tidak dapat dibatalkan. Apakah Anda yakin ingin melanjutkan?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("Tidak, Kembali", style: TextStyle(color: Colors.blue)),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               await cancelLoan(loanId);
  //               Navigator.pop(context);
  //               fetchLoans();
  //             },
  //             child: Text("Ya, Batalkan", style: TextStyle(color: Colors.red)),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  
  @override
  Widget build(BuildContext context) {
    final bool showIllustration = loans.isEmpty;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livin\' Modal Merchant'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Credit limit card
              _buildCreditLimitCard(),
              
              const SizedBox(height: 24),
              
              // Show either illustration or both sections based on data
              if (showIllustration) ...{
                _buildEmptyStateIllustration(context)
              } else ...{
                // If we have data, show the normal sections
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Loan Application Section if we have applications
                    if (loans.isNotEmpty)
                      _buildLoanApplicationsSection(),
                  ],
                ),
              },
              
              const SizedBox(height: 24),
              
              // Apply for loan button at bottom
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                  bool? isLoanCreated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoanApplications(),
                    ),
                  );

                  if (isLoanCreated == true) {
                    // Fetch ulang daftar pinjaman jika ada pinjaman baru
                    fetchLoans();
                  }
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0C50EF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Ajukan Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Credit Limit Card Widget
  Widget _buildCreditLimitCard() {
    final String limitAmount = formatCurrency(totalApprovedLoans);
    final String availableLimit = 'Rp70.000.000';
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Limit Tersedia: $availableLimit',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            limitAmount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Bayar sebelum 07 Maret 2025',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Empty state illustration - only shown when both lists are empty
  Widget _buildEmptyStateIllustration(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Image.asset(
          'assets/images/ilustration04.png',
          height: 200,
        ),
        const SizedBox(height: 16),
        Text(
          'Mulai Sekarang! Ajukan Pinjaman dan Kembangkan Bisnismu',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Ayo lakukan pengajuan pinjaman dan kembangkan bisnismu!',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Loan Applications Section
  Widget _buildLoanApplicationsSection() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pengajuan Pinjaman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...loans.map((loan) {
            return _buildLoanApplicationItem(loan);
          }),
        ],
      ),
    );
  }

  Widget _buildLoanApplicationItem(LoanApplication application) {
    return GestureDetector(
      onTap: () {
        _showLoanDetailsModal(application);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatCurrency(application.amount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    application.date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            _buildStatusIndicator(application.status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color indicatorColor;
    IconData iconData;
    
    switch (status) {
      case 'Diproses':
        indicatorColor = Colors.grey;
        iconData = Icons.hourglass_empty;
        break;
      case 'Diterima':
        indicatorColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case 'Ditolak':
        indicatorColor = Colors.red;
        iconData = Icons.cancel;
        break;
      default:
        indicatorColor = Colors.grey;
        iconData = Icons.help;
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, color: indicatorColor, size: 16),
        const SizedBox(width: 4),
        Text(
          status, 
          style: TextStyle(
            color: indicatorColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showLoanDetailsModal(LoanApplication application) {
    // Calculate loan details using BigInt for precision
    BigInt loanAmount = _parseBigInt(application.amount.toString().replaceAll('.', ''));
    int termMonths = application.loanTerm;
    double interestRatePercent = 3.0;
    
    // Calculate interest amount (loanAmount * interestRatePercent / 100)
    BigInt interestAmount = (loanAmount * BigInt.from(interestRatePercent)) ~/ BigInt.from(100);
    
    // Calculate total amount (loanAmount + interestAmount)
    BigInt totalAmount = loanAmount + interestAmount;
    
    // Calculate monthly installment (totalAmount / termMonths)
    BigInt monthlyInstallment = totalAmount ~/ BigInt.from(termMonths);
    
    // Calculate daily deduction (monthlyInstallment / 30)
    BigInt dailyDeduction = monthlyInstallment ~/ BigInt.from(30);
    
    // Calculate first due date (current date + 1 month)
    DateTime currentDate = DateTime.parse('2025-03-07');
    DateTime firstDueDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
    String formattedDueDate = '${firstDueDate.day.toString().padLeft(2, '0')} ${_getMonthName(firstDueDate.month)} ${firstDueDate.year}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detail Ajuan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              
              // Loan amount and date
              const SizedBox(height: 8),
              Text(
                formatCurrency(double.parse(application.amount.toString())),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C50EF),
                ),
              ),
              Row(
                children: [
                  Text(
                    application.date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        application.status,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Loan details section
              const Text(
                'Rincian Peminjaman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Loan details card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Jumlah Pinjaman', formatCurrency(double.parse(application.amount.toString()))),
                    _buildDetailRow('Tengat Waktu', '$termMonths bulan'),
                    _buildDetailRow('Total Bunga ($interestRatePercent%)', 'Rp${_formatBigInt(interestAmount)}'),
                    const Divider(),
                    _buildDetailRow('Total Cicilan', 'Rp${_formatBigInt(totalAmount)}', isBold: true),
                    _buildDetailRow('Cicilan per Bulan', 'Rp${_formatBigInt(monthlyInstallment)}'),
                    _buildDetailRow('Potongan Harian', 'Rp${_formatBigInt(dailyDeduction)}'),
                    _buildDetailRow('Jatuh Tempo Pertama', formattedDueDate),
                    _buildDetailRow('Denda Keterlambatan', '0.1% dari jumlah pinjaman\nyang tertunggak/hari', multiline: true),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Cancel button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: application.status == 'Diterima' || application.status == 'Ditolak' 
                    ? null  // Disabled when approved or rejected
                    : () => _showConfirmationDialog(context, application.loanId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDC3545),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Batalkan Ajuan'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper function to parse a string to BigInt
  BigInt _parseBigInt(String value) {
    try {
      return BigInt.parse(value);
    } catch (e) {
      return BigInt.zero;
    }
  }

  void _showConfirmationDialog(BuildContext context, int loanId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Pengajuan Akan Dibatalkan, Yakin?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Jika Anda membatalkan pengajuan ini, proses pinjaman tidak akan dilanjutkan. Tindakan ini tidak dapat dibatalkan. Apakah Anda yakin ingin melanjutkan?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFE3E9FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Kembali', style: TextStyle(color: Color(0xFF0C50EF))),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cancelLoan(loanId, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDC3545),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Batalkan', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Helper function to format BigInt with thousand separators
  String _formatBigInt(BigInt value) {
    String valueStr = value.toString();
    String result = '';
    
    for (int i = 0; i < valueStr.length; i++) {
      if (i > 0 && (valueStr.length - i) % 3 == 0) {
        result += '.';
      }
      result += valueStr[i];
    }
    
    return result;
  }

  // Helper function to get month name
  String _getMonthName(int month) {
    List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Add this method to your _ModalState class
  // void _showActiveLoanDetailsModal(ActiveLoan loan) {
  //   // Parse the loan amount for calculations
  //   BigInt loanAmount = _parseBigInt(loan.amount.replaceAll('.', ''));
  //   int termMonths = 3;
  //   double interestRatePercent = 3.0;
    
  //   // Calculate interest amount
  //   BigInt interestAmount = (loanAmount * BigInt.from(interestRatePercent)) ~/ BigInt.from(100);
    
  //   // Calculate total amount
  //   BigInt totalAmount = loanAmount + interestAmount;
    
  //   // Calculate monthly installment
  //   BigInt monthlyInstallment = totalAmount ~/ BigInt.from(termMonths);
    
  //   // Calculate daily deduction
  //   BigInt dailyDeduction = monthlyInstallment ~/ BigInt.from(30);
    
  //   // Calculate progress based on status (simplified example)
  //   double progress = 0.0;
  //   if (loan.status == 'Lunas') {
  //     progress = 1.0; // 100% complete
  //   } else if (loan.status == 'Proses') {
  //     // Example: assume 50% complete for processing loans
  //     // In a real app, you'd calculate this based on payments made
  //     progress = 0.5;
  //   }
    
  //   // Calculate paid and remaining amounts
  //   BigInt paidAmount = (totalAmount * BigInt.from((progress * 100).toInt())) ~/ BigInt.from(100);
  //   BigInt remainingAmount = totalAmount - paidAmount;
    
  //   // Format due date
  //   DateTime dueDate = _parseDateFromString(loan.dueDate);
  //   String formattedDueDate = '${dueDate.day} ${_getMonthName(dueDate.month)} ${dueDate.year}';
    
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.8,
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Modal header with close button
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   'Detail Peminjaman',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 IconButton(
  //                   icon: const Icon(Icons.close),
  //                   onPressed: () => Navigator.pop(context),
  //                 ),
  //               ],
  //             ),
              
  //             // Loan amount and date
  //             const SizedBox(height: 8),
  //             Text(
  //               'Rp${loan.amount}',
  //               style: const TextStyle(
  //                 fontSize: 22,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xFF0C50EF),
  //               ),
  //             ),
  //             Text(
  //               'Tenggat waktu: ${loan.dueDate}',
  //               style: TextStyle(
  //                 color: Colors.grey[600],
  //                 fontSize: 14,
  //               ),
  //             ),
              
  //             const SizedBox(height: 20),
              
  //             // Progress bar section
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   'Rp${_formatBigInt(paidAmount)} terbayar',
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey[700],
  //                   ),
  //                 ),
  //                 Text(
  //                   'Sisa Rp${_formatBigInt(remainingAmount)}',
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey[700],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 8),
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(8),
  //               child: LinearProgressIndicator(
  //                 value: progress,
  //                 minHeight: 10,
  //                 backgroundColor: Colors.grey[300],
  //                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0C50EF)),
  //               ),
  //             ),
              
  //             const SizedBox(height: 20),
              
  //             // Loan details section
  //             const Text(
  //               'Rincian Peminjaman',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 12),
              
  //             // Loan details card
  //             Container(
  //               padding: const EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.grey[300]!),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Column(
  //                 children: [
  //                   _buildDetailRow('Jumlah Pinjaman', 'Rp${_formatBigInt(loanAmount)}'),
  //                   _buildDetailRow('Tengat Waktu', '$termMonths bulan'),
  //                   _buildDetailRow('Total Bunga (${interestRatePercent}%)', 'Rp${_formatBigInt(interestAmount)}'),
  //                   const Divider(),
  //                   _buildDetailRow('Total Cicilan', 'Rp${_formatBigInt(totalAmount)}', isBold: true),
  //                   _buildDetailRow('Cicilan per Bulan', 'Rp${_formatBigInt(monthlyInstallment)}'),
  //                   _buildDetailRow('Potongan Harian', 'Rp${_formatBigInt(dailyDeduction)}'),
  //                   _buildDetailRow('Jatuh Tempo Pertama', formattedDueDate),
  //                   _buildDetailRow('Denda Keterlambatan', '0.1% dari jumlah pinjaman\nyang tertunggak/hari', multiline: true),
  //                 ],
  //               ),
  //             ),
              
  //             const Spacer(),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Helper method to parse date from string
  // DateTime _parseDateFromString(String dateStr) {
  //   // Extract day, month name, and year from "25 Mar 2025" format
  //   List<String> parts = dateStr.split(' ');
  //   int day = int.parse(parts[0]);
  //   int month = _getMonthNumber(parts[1]);
  //   int year = int.parse(parts[2]);
  //   return DateTime(year, month, day);
  // }

  // // Helper method to get month number from name
  // int _getMonthNumber(String monthName) {
  //   Map<String, int> months = {
  //     'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'Mei': 5, 'Jun': 6,
  //     'Jul': 7, 'Agu': 8, 'Sep': 9, 'Okt': 10, 'Nov': 11, 'Des': 12
  //   };
  //   return months[monthName] ?? 1; // Default to January if not found
  // }
}

class LoanApplication {
  final int loanId;
  final double amount;
  final String status;
  final int loanTerm;
  final String date;

  LoanApplication({
    required this.loanId,
    required this.amount,
    required this.status,
    required this.date,
    required this.loanTerm,
  });

  // Factory untuk parsing dari JSON
  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      loanId: json['loan_id'],
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      loanTerm: json['loan_term'],
      date: json['created_at'],
    );
  }
}