import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_apps/modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // Untuk format angka

class LoanBusinessDetail extends StatefulWidget {
  final BigInt loanAmount;
  final int tenor;

  const LoanBusinessDetail({
    Key? key,
    required this.loanAmount,
    required this.tenor,
  }) : super(key: key);

  @override
  _LoanBusinessDetailState createState() => _LoanBusinessDetailState();
}

class _LoanBusinessDetailState extends State<LoanBusinessDetail> {
  Map<String, dynamic> userData = {};
  bool _isLoading = false;

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

  Future<void> submitLoanRequest() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse("https://merchantbackend-long-shape-7140.fly.dev/loan/create_loan");
    

    try {
      final prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('userData');

      if (userJson == null) {
        throw Exception("User data tidak ditemukan!");
      }

      Map<String, dynamic> userData = jsonDecode(userJson);
      int userId = userData['user_id'];

      Map<String, dynamic> requestBody = {
        "user_id": userId,
        "amount": widget.loanAmount.toInt(), // Menggunakan nilai yang dipassing
        "loan_term": widget.tenor // Menggunakan tenor yang dipassing
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Modal()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pinjaman berhasil diajukan!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengajukan pinjaman!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedAmount = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(widget.loanAmount.toInt());

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Usaha'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail rekening', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildDetailCard([
              _buildDetailRow('Nama Bank', userData['name'] ?? 'Tidak diketahui'),
              _buildDetailRow('Nomor rekening', userData['account_number'] ?? 'Tidak diketahui'),
              _buildDetailRow('Nomor telepon', userData['phone_number'] ?? 'Tidak diketahui'),
            ]),
            SizedBox(height: 20),
            Text('Informasi Pinjaman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildDetailCard([
              _buildDetailRow('Jumlah Pinjaman', formattedAmount),
              _buildDetailRow('Tenor', '${widget.tenor} bulan'),
            ]),
            SizedBox(height: 20),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0C50EF),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Konfirmasi', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> rows) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Pengajuan Bersifat Final, Sudah Yakin?', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Text('Pastikan data sudah benar sebelum melanjutkan. Setelah pengajuan dikirim, Anda tidak dapat mengubahnya.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFE3E9FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Batal', style: TextStyle(color: Color(0xFF0C50EF))),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      submitLoanRequest();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0C50EF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Ajukan', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
