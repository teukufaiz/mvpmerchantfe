import 'package:flutter/material.dart';
import 'package:new_apps/loan_business_detail.dart';

class LoanAssets extends StatefulWidget {
  @override
  _LoanAssetsState createState() => _LoanAssetsState();
}

class _LoanAssetsState extends State<LoanAssets> {
  final TextEditingController _purposeController = TextEditingController();
  bool _isButtonEnabled = false;

  void _validateInput() {
    setState(() {
      _isButtonEnabled = _purposeController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text('Pembayaran Pinjaman'),
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
            Text(
              'Rincian Pendapatan Pribadi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Total Aset', 'Rp100.000.000'),
                  SizedBox(height: 8),
                  _buildInfoRow('Rata-Rata Pemasukkan', 'Rp50.000.000'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Pinjaman digunakan untuk? *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _purposeController,
              onChanged: (text) => _validateInput(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan tujuan pinjaman',
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoanBusinessDetail()));
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled ? Color(0xFF0C50EF) : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Lanjutkan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 180, // Set a fixed width for the label
          child: Text(
            title,
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis, // Prevents overflow issues
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }
}