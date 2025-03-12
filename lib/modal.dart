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
                    // Handle button press
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