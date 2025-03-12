import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_apps/modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  int _selectedIndex = 0;
  
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShoppingPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CatalogPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IntroModal()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
    }
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0; // Always go back to Home
      });
      return false; // Prevent default back behavior
    }
    return true; // Exit app if already on Home
  }

  final List<Map<String, dynamic>> transactions = [
    {
      "type": "QRIS Statis",
      "amount": 2500000,
      "date": DateTime(2025, 3, 7, 7, 0),
      "icon": Icons.qr_code_2_rounded,
      "isIncome": true,
    },
    {
      "type": "Kartu Kredit",
      "amount": 10500000,
      "date": DateTime(2025, 3, 7, 6, 45),
      "icon": Icons.credit_card,
      "isIncome": true,
    },
    {
      "type": "Transfer Bank",
      "amount": 5000000,
      "date": DateTime(2025, 3, 6, 18, 30),
      "icon": Icons.account_balance_wallet_rounded,
      "isIncome": false,
    },
  ];

  String formatCurrency(int amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(amount);
  }

  String formatDate(DateTime date) {
    return DateFormat("dd MMM yyyy, HH:mm WIB", 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      body: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover),
            ),
          ),),
      SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded( // Allows scrolling for the whole content
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo(),
                    _buildMenuGrid(), // Ensure it has a constrained height
                    _buildPromotionBanner(),
                    _buildBalanceSection(),
                    _buildRecentTransaction(),
                  ],
                ),
              ),
            ),
            _buildBottomNavigation() // Stays fixed at the bottom
          ],
        ),
      ),
      ],)
      ),
    );
  }

  Widget _buildAppBar(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Image.asset('assets/images/logo02.png', width: 142, height: 27,),
          const Spacer(),
          const Icon(Icons.notifications_none, color: Colors.white,),
        ],),
    );
  }
  
  Widget _buildUserInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.2), // Deep blue color matching the image
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Upper section with user info
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User info (left side)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'RAIHAN ALIFIANTO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Pemilik',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Points info (right side)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.circle, color: Colors.orange, size: 8),
                      SizedBox(width: 4),
                      Text(
                        'Belum ada poin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Divider between sections
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: Colors.white.withOpacity(0.1),
              height: 1,
            ),
          ),
          
          // Store info section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Store image/logo placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                // Store details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Kedai Kopi Beli',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jln. Mulu Ga Jadian Jadian',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(width: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuItem(Icons.store, 'Pesanan'),
                _buildMenuItem(Icons.description, 'Kasir'),
                _buildMenuItem(Icons.insert_chart, 'Laporan'),
              ],
            )
          ],
        ),
      )
    );
  }

  Widget _buildMenuItem(IconData icon, String title){
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(icon, color: Colors.blue,),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),),
      ],
    );
  }
  Widget _buildPromotionBanner(){
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: const [
          Icon(Icons.lightbulb, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Text("Ekspansi bisnismu dengan dengan livin’ modal merchant.",
              style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.w400),
            ),
          )
        ],
      )
    );
  }

  Widget _buildBalanceSection(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Pendapatan Hari Ini, 07 Mar 2025', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Lihat Detail', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Rp217.000.000',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/qris-icon.png', width: 32, height: 32,),
                Row(
                  children: [
                    Text('Tampilkan QRIS', 
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.blue.shade700
                      )
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: Colors.blue.shade700, size: 20),
                  ],
                )
              ],
            )
          )
        ]
      ),
    );
  }

  Widget _buildRecentTransaction(){
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(
              "Transaksi Terakhir",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],),
          SizedBox(height: 10),
          SizedBox(
            height: 120, // Set a height based on your design needs
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(transaction["icon"], color: Colors.blue, size: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transaction["type"], style: TextStyle(fontWeight: FontWeight.w600)),
                            Text(formatDate(transaction["date"]), style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Text(
                        "${transaction["isIncome"] ? "+" : "-"}${formatCurrency(transaction["amount"])}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: transaction["isIncome"] ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
  Widget _buildBottomNavigation() {
     return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 28),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, size: 24),
                label: 'Belanja',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description_outlined, size: 24),
                label: 'Katalog',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.credit_card, size: 24),
                label: 'Modal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings, size: 24),
                label: 'Pengaturan',
              ),
            ],
          ),
        ),
      );
    }

  // Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(
  //         icon,
  //         color: isSelected ? Colors.blue : Colors.grey,
  //       ),
  //       const SizedBox(height: 4),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 12,
  //           color: isSelected ? Colors.blue : Colors.grey,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Center(child: Text("Belanja Page"));
  }
}

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Katalog Page'));
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Settings Page'));
  }
}