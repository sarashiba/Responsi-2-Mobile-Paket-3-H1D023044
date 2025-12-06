import 'package:flutter/material.dart';
import 'package:responsi2mobile_paket3_h1d023044/bloc/registrasi_bloc.dart';
import 'package:responsi2mobile_paket3_h1d023044/widget/success_dialog.dart';
import 'package:responsi2mobile_paket3_h1d023044/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEBE9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER REGISTER
            Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown, Color(0xFF8D6E63)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add_alt_1, size: 70, color: Colors.white),
                    SizedBox(height: 15),
                    Text(
                      "Buat Akun Baru",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // FORM REGISTER
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _namaTextField(),
                    const SizedBox(height: 15),
                    _emailTextField(),
                    const SizedBox(height: 15),
                    _passwordTextField(),
                    const SizedBox(height: 15),
                    _passwordKonfirmasiTextField(),
                    const SizedBox(height: 30),
                    _buttonRegistrasi(),
                    const SizedBox(height: 20),
                    // Tombol Kembali
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Kembali ke Login",
                          style: TextStyle(color: Colors.brown)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Input Style Helper
  InputDecoration _inputDecor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.brown),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.brown.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.brown, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      decoration: _inputDecor("Nama Lengkap", Icons.person),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) return "Nama minimal 3 karakter";
        return null;
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: _inputDecor("Email", Icons.email),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) return 'Email harus diisi';
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: _inputDecor("Password", Icons.vpn_key),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 6) return "Password minimal 6 karakter";
        return null;
      },
    );
  }

  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: _inputDecor("Konfirmasi Password", Icons.vpn_key_outlined),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  Widget _buttonRegistrasi() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: const Text("DAFTAR",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        },
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
            nama: _namaTextboxController.text,
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
                description: "Registrasi berhasil, silahkan login",
                okClick: () {
                  Navigator.pop(context);
                },
              ));
    }, onError: (error) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Registrasi gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}