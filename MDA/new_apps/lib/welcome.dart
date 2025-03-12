import 'package:flutter/material.dart';
import '../login.dart';


class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/ilustration01.png',
                  height: 320,
                  width: 320,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Pendaftaran Mudah dengan Nomor Rekening Bank Mandiri',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 42),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF0C50EF),
                    minimumSize: Size(327, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),  
                  ),
                  onPressed: (){},
                  child: Text("Daftar Livin' Merchant"),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                    foregroundColor: Color(0xFF0C50EF),
                    backgroundColor: Color(0xFFE3E9FF),
                    minimumSize: Size(327, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),  
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Masuk"),
                ),
              ],
            )  
          ],
        ),
      ),
    );
  }
}