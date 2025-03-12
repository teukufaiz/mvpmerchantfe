import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:new_apps/modal.dart';
import '../splash.dart';
import '../welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is ready
  await initializeDateFormatting('id_ID', null); // Initialize locale
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: Splash(nextScreen: Welcome(), duration: Duration(seconds: 5)),
      debugShowCheckedModeBanner: false,
    );
  }
}
