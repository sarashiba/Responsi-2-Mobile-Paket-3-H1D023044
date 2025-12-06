import 'package:flutter/material.dart';
import 'package:responsi2mobile_paket3_h1d023044/helpers/user_info.dart';
import 'package:responsi2mobile_paket3_h1d023044/ui/login_page.dart';
import 'package:responsi2mobile_paket3_h1d023044/ui/buku_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();
    if (token != null) {
      setState(() {
        page = const BukuPage();
      });
    } else {
      setState(() {
        page = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Buku Sarah',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        useMaterial3: true,
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown,
          secondary: Colors.brown,
        ),
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),

        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.brown,
          selectionColor: Colors.brown.withOpacity(0.3),
          selectionHandleColor: Colors.brown,
        ),

        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.brown, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
          floatingLabelStyle: const TextStyle(color: Colors.brown),
        ),
      ),

      home: page,
    );
  }
}