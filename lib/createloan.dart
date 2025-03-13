import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CreateLoanPage extends StatefulWidget {
  const CreateLoanPage({Key? key}) : super(key: key);

  @override
  _CreateLoanPageState createState() => _CreateLoanPageState();
}

class _CreateLoanPageState extends State<CreateLoanPage> {
  TextEditingController _amountController = TextEditingController();
  int _selectedTenor = 3; // Default tenor 3 bulan
  Map <String, dynamic> userData = {};
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
    }
  }

  void _showConfirmationDialog() {
    double loanAmount = double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;
    double interest = loanAmount * 0.03;
    double totalCicilan = loanAmount + interest;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Rincian Peminjaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              _buildDetailRow("Jumlah Pinjaman", _formatCurrency(loanAmount)),
              _buildDetailRow("Tenggat Waktu", "$_selectedTenor bulan"),
              _buildDetailRow("Total Bunga (3%)", _formatCurrency(interest)),
              Divider(),
              _buildDetailRow("Total Cicilan", _formatCurrency(totalCicilan), isBold: true),
              SizedBox(height: 20),
              Text("Rincian Pencairan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              _buildDetailRow("Jumlah Pinjaman", _formatCurrency(loanAmount)),
              Divider(),
              _buildDetailRow("Total Pencairan", _formatCurrency(loanAmount), isBold: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitLoanRequest(loanAmount.toInt());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text("Ajukan"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitLoanRequest(int amount) async {
    const String apiUrl = "http://127.0.0.1:8000/loan/create_loan";
    if (userData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengambil data pengguna")),
      );
      return;
    }

    // Konversi user_id ke integer
    int? userId = userData['user_id'] is int ? userData['user_id'] : int.tryParse(userData['user_id'].toString());

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ID pengguna tidak valid")),
      );
      return;
    }

    Map<String, dynamic> requestBody = {
      "user_id": userId,
      "amount": amount
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengajukan pinjaman")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan")),
      );
    }
  }

  Widget _buildDetailRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return "Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Masukkan Detail Pengajuan"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Masukkan Nominal *", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "10.000.000",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 5),
            Text("Ambil pinjaman hingga Rp 10.000.000", style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 20),
            Text("Pilih Tenggat Waktu *", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTenorButton(3),
                _buildTenorButton(6),
                _buildTenorButton(12),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Untuk memilih tenggat waktu yang lain, terus transaksi agar poin sesuai dengan ketentuan.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text("Lanjutkan"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenorButton(int months) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTenor = months;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: _selectedTenor == months ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _selectedTenor == months ? Colors.blue : Colors.grey),
        ),
        child: Text(
          "$months bulan",
          style: TextStyle(
            color: _selectedTenor == months ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 