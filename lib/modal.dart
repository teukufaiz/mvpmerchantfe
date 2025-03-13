import 'package:flutter/material.dart';
import 'package:new_apps/home.dart';

class IntroModal extends StatelessWidget {
  const IntroModal({Key? key}) : super(key: key);

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
 // These lists would typically come from your data source
  late List<LoanApplication> _loanApplications;
  late List<ActiveLoan> _activeLoans;
  
  @override
  void initState() {
    super.initState();
    // Initialize the data
    _fetchData();
  }
  
  // Fetch data from your data source
  void _fetchData() {
    // In a real app, this would be an API call or database query
    _loanApplications = _fetchLoanApplications();
    _activeLoans = _fetchActiveLoans();
  }
  
  // These methods would be replaced with your actual data fetching logic
  List<LoanApplication> _fetchLoanApplications() {
    // Return empty list to test empty state
    return [
      LoanApplication(amount: '50.000.000', date: '07 Mar 2025, 07:00 WIB', status: 'Diproses'),
      LoanApplication(amount: '50.000.000', date: '07 Mar 2025, 07:00 WIB', status: 'Diterima'),
      LoanApplication(amount: '50.000.000', date: '07 Mar 2025, 07:00 WIB', status: 'Ditolak'),
    ];
    
  }
  
  List<ActiveLoan> _fetchActiveLoans() {
    // Return empty list to test empty state
    return [
      ActiveLoan(amount: '50.000.000', dueDate: '28 Feb 2025', status: 'Lunas'),
      ActiveLoan(amount: '50.000.000', dueDate: '05 Mar 2025', status: 'Lunas'),
      ActiveLoan(amount: '50.000.000', dueDate: '25 Mar 2025', status: 'Proses'),
    ];
    
  }

  @override
  Widget build(BuildContext context) {
    // Check if both lists are empty to determine whether to show the illustration
    final bool showIllustration = _loanApplications.isEmpty && _activeLoans.isEmpty;
    
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
                    if (_loanApplications.isNotEmpty)
                      _buildLoanApplicationsSection(),
                    
                    if (_loanApplications.isNotEmpty)
                      const SizedBox(height: 24),
                    
                    // Active Loans Section if we have active loans
                    if (_activeLoans.isNotEmpty)
                      _buildActiveLoansSection(),
                  ],
                ),
              },
              
              const SizedBox(height: 24),
              
              // Apply for loan button at bottom
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to loan application form
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
    // You can check if the user has a credit limit or not
    final bool hasCreditLimit = true; // Replace with your actual condition
    final String limitAmount = hasCreditLimit ? 'Rp50.000.000' : 'Rp0';
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
                  fontWeight: FontWeight.bold                ),),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._loanApplications.map((application) {
            return _buildLoanApplicationItem(application);
          }).toList(),
        ],
      ),
    );
  }

  // Active Loans Section
  Widget _buildActiveLoansSection() {
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
                'Pinjaman Aktif',
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
                  fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._activeLoans.map((loan) {
            return _buildActiveLoanItem(loan);
          }).toList(),
        ],
      ),
    );
  }

  // Widgets to build individual list items
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
                  'Rp${application.amount}',
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

  Widget _buildActiveLoanItem(ActiveLoan loan) {
    Color statusColor;
    if (loan.status == 'Lunas') {
      statusColor = Colors.green;
    } else if (loan.status == 'Proses') {
      statusColor = Colors.blue;
    } else {
      statusColor = Colors.grey;
    }
    
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
                  'Rp${loan.amount}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tenggat waktu: ${loan.dueDate}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            loan.status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
}

class LoanApplication {
  final String amount;
  final String date;
  final String status;
  
  LoanApplication({required this.amount, required this.date, required this.status});
}

class ActiveLoan {
  final String amount;
  final String dueDate;
  final String status;
  
  ActiveLoan({required this.amount, required this.dueDate, required this.status});
}