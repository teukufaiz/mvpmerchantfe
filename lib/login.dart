import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';
import 'home.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{

  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(userData);
    await prefs.setString("userData", userJson);
  }
  
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final url = Uri.parse("http://127.0.0.1:8000/auth/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone_number": _phoneController.text,
        "password": _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final String accessToken = responseData['access_token'];

      if (accessToken.isNotEmpty) {
        Map<String, dynamic> decodedToken = Jwt.parseJwt(accessToken);

        final userData = {
          "user_id": decodedToken["user_id"],
          "name": decodedToken["name"],
          "phone_number": decodedToken["phone_number"],
          "account_number": decodedToken["account_number"],
          "business_name": decodedToken["business_name"],
          "address": decodedToken["address"],
        };

        await saveUserData(userData);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal! Periksa kembali nomor dan password."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                  'assets/images/ilustration02.png',
                  height: 300,
                  width: 300,
                ),
            const Text(
                  'Hai, Apa Kabar Hari Ini? 👋',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
            const Text(
                  'Yuk, masuk dan mulai kerja cuan lagi!',
                  style: TextStyle(
                    color: Color(0xFF808080),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
            SizedBox(height: 36),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Handphone',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 327,
                    height: 72,
                    child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Ex: 081234567890',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFD4D4D4))
                      ),
                    ),
                    validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Nomor handphone tidak boleh kosong';
                        }
                        return null;
                      },
                    ),),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 327,
                    height: 72,
                    child: TextFormField(
                    obscureText: _isPasswordHidden,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFD4D4D4))
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                          color: Color(0xFFD4D4D4),
                        ),
                        onPressed: (){
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                    ),
                    validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),),
                  SizedBox(
                    width: 327,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (){},
                          child: Text(
                            'Lupa Password?',
                            style: TextStyle(
                              color: Color(0xFF0C50EF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
              ],)
            ),
            Column(
              children: [
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
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading ? CircularProgressIndicator() : Text("Masuk"),
                    ),
                SizedBox(height: 16),
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
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                      },
                      child: Text("Daftar Livin' Merchant"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}