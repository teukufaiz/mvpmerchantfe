import 'package:flutter/material.dart';
import 'package:new_apps/createloan.dart';
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
    final url = 'http://127.0.0.1:8000/loan/get_loans/$userId';

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
    final url = 'http://127.0.0.1:8000/loan/total_approved_loans/$userId';

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

  Future<void> cancelLoan(int loanId) async {
    final url = 'http://127.0.0.1:8000/loan/delete_loan/$loanId';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        print("Loan canceled successfully");
      } else {
        print("Failed to cancel loan");
      }
    } catch (e) {
      print("Error canceling loan: $e");
    }
  }

  void showCancelDialog(int loanId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apakah kamu ingin membatalkan peminjaman?", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Jika Anda membatalkan pengajuan ini, proses pinjaman tidak akan dilanjutkan. Tindakan ini tidak dapat dibatalkan. Apakah Anda yakin ingin melanjutkan?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Tidak, Kembali", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () async {
                await cancelLoan(loanId);
                Navigator.pop(context);
                fetchLoans();
              },
              child: Text("Ya, Batalkan", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
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
                      builder: (context) => CreateLoanPage(),
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

  // Active Loans Section
  // Widget _buildActiveLoansSection() {
  //   return Container(
  //     margin: EdgeInsets.all(8),
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 6,
  //           offset: Offset(0, 3)
  //         )
  //       ]
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text(
  //               'Pinjaman Aktif',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {},
  //               child: const Text('Lihat Semua',
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 color: Colors.blue,
  //                 fontWeight: FontWeight.bold
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         ..._activeLoans.map((loan) {
  //           return _buildActiveLoanItem(loan);
  //         }).toList(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLoanApplicationItem(LoanApplication application) {
    return Container(
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
                  // 'Rp${application.amount}',
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
    );
  }

  // Widget _buildActiveLoanItem(ActiveLoan loan) {
  //   Color statusColor;
  //   if (loan.status == 'Lunas') {
  //     statusColor = Colors.green;
  //   } else if (loan.status == 'Proses') {
  //     statusColor = Colors.blue;
  //   } else {
  //     statusColor = Colors.grey;
  //   }
    
    // return Container(
    //   padding: const EdgeInsets.symmetric(vertical: 12),
    //   decoration: BoxDecoration(
    //     border: Border(
    //       bottom: BorderSide(color: Colors.grey.shade200),
    //     ),
    //   ),
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               'Rp${loan.amount}',
    //               style: const TextStyle(
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 16,
    //               ),
    //             ),
    //             const SizedBox(height: 4),
    //             Text(
    //               'Tenggat waktu: ${loan.dueDate}',
    //               style: TextStyle(
    //                 color: Colors.grey[600],
    //                 fontSize: 12,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Text(
    //         loan.status,
    //         style: TextStyle(
    //           color: statusColor,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  // }

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
}

class LoanApplication {
  final int loanId;
  final double amount;
  final String status;
  final String date;

  LoanApplication({
    required this.loanId,
    required this.amount,
    required this.status,
    required this.date,
  });

  // Factory untuk parsing dari JSON
  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      loanId: json['loan_id'],
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      date: json['created_at'],
    );
  }
}