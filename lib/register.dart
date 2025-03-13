import 'package:flutter/material.dart';
import 'package:new_apps/home.dart';
import 'package:new_apps/login.dart';

class Register extends StatefulWidget{
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register>{

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _rekeningController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isPasswordHidden = true;

  void _register(){
    if(_formKey.currentState!.validate()){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ilustration02.png',
                          height: 300,
                          width: 300,
                        ),
                        const Text(
                          'Buka Kesempatan Baru untuk Bisnismu!🚀',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        const Text(
                          'Daftar sekarang dan nikmati kemudahan menerima pembayaran digital, mengelola transaksi, dan mengembangkan bisnismu dengan fitur canggih Livin’ Merchants!',
                          style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                    SizedBox(height: 36),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No. Rekening',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                          SizedBox(height: 8),
                          SizedBox(
                            width: 327,
                            height: 72,
                            child: TextFormField(
                            controller: _rekeningController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Ex: 5678684948290',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xFFD4D4D4))
                              ),
                            ),
                            validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Nomor Rekening tidak boleh kosong';
                                }
                                return null;
                              },
                            ),),
                          Text(
                            'Nama Lengkap',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                          SizedBox(height: 8),
                          SizedBox(
                            width: 327,
                            height: 72,
                            child: TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Ex: Justin Hubner',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xFFD4D4D4))
                              ),
                            ),
                            validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Nama Lengkap tidak boleh kosong';
                                }
                                return null;
                              },
                            ),),
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
                            'Nama Toko',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                          SizedBox(height: 8),
                          SizedBox(
                            width: 327,
                            height: 72,
                            child: TextFormField(
                            controller: _shopNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Ex: Toko Sinar Jaya Mentereng',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xFFD4D4D4))
                              ),
                            ),
                            validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Nama Toko tidak boleh kosong';
                                }
                                return null;
                              },
                            ),),
                          Text(
                            'Alamat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                          SizedBox(height: 8),
                          SizedBox(
                            width: 327,
                            height: 72,
                            child: TextFormField(
                            controller: _addressController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Ex: Jl. Mulu Jadian Ngga',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xFFD4D4D4))
                              ),
                            ),
                            validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Alamat tidak boleh kosong';
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
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFF0C50EF),
                                minimumSize: Size(327, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),  
                              ),
                              onPressed: _register,
                              child: Text("Daftar Livin' Merchant"),
                        ),
                        SizedBox(height: 16),
                         Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Login()),
                              );
                            },
                            child: Text(
                              "Sudah punya akun? Masuk di sini",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20)
                      ],
                    )
                  ],
                ),
              ))
          ]
        ),
      ),
    );
  }
}