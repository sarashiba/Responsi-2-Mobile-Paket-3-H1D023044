import 'package:flutter/material.dart';
import 'package:responsi2mobile_paket3_h1d023044/bloc/buku_bloc.dart';
import 'package:responsi2mobile_paket3_h1d023044/model/buku.dart';
import 'package:responsi2mobile_paket3_h1d023044/ui/buku_page.dart';
import 'package:responsi2mobile_paket3_h1d023044/widget/warning_dialog.dart';

class BukuForm extends StatefulWidget {
  Buku? buku;
  BukuForm({Key? key, this.buku}) : super(key: key);

  @override
  _BukuFormState createState() => _BukuFormState();
}

class _BukuFormState extends State<BukuForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "Tambah Buku Sarah";
  String tombolSubmit = "SIMPAN";

  final _judulTextboxController = TextEditingController();
  final _hargaTextboxController = TextEditingController();
  final _jumlahTextboxController = TextEditingController();
  final _tanggalTextboxController = TextEditingController();
  final _volumeTextboxController = TextEditingController();
  final _penulisTextboxController = TextEditingController();
  final _penerbitTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.buku != null) {
      setState(() {
        judul = "Ubah Buku Sarah";
        tombolSubmit = "UPDATE";
        _judulTextboxController.text = widget.buku!.judul!;
        _hargaTextboxController.text = widget.buku!.harga.toString();
        _jumlahTextboxController.text = widget.buku!.jumlah.toString();
        _tanggalTextboxController.text = widget.buku!.tanggalMasuk!;
        _volumeTextboxController.text = widget.buku!.volume.toString();
        _penulisTextboxController.text = widget.buku!.penulis!;
        _penerbitTextboxController.text = widget.buku!.penerbit!;
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.brown,
              onPrimary: Colors.white,
              onSurface: Colors.brown,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.brown,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tanggalTextboxController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEBE9),
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildCustomTextField(
                            controller: _judulTextboxController,
                            label: "Judul Buku",
                            icon: Icons.book),
                        _buildCustomTextField(
                            controller: _penulisTextboxController,
                            label: "Penulis",
                            icon: Icons.person),
                        _buildCustomTextField(
                            controller: _penerbitTextboxController,
                            label: "Penerbit",
                            icon: Icons.business),
                        const Divider(height: 30, color: Colors.brown),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCustomTextField(
                                  controller: _hargaTextboxController,
                                  label: "Harga",
                                  icon: Icons.attach_money,
                                  isNumber: true),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildCustomTextField(
                                  controller: _jumlahTextboxController,
                                  label: "Stok",
                                  icon: Icons.inventory_2,
                                  isNumber: true),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCustomTextField(
                                  controller: _volumeTextboxController,
                                  label: "Volume",
                                  icon: Icons.layers,
                                  isNumber: true),
                            ),
                            const SizedBox(width: 15),
                            // GANTI TEXT FIELD BIASA DENGAN DATE FIELD
                            Expanded(
                              child: _buildDateField(), 
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buttonSubmit(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.brown, Color(0xFF8D6E63)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Icon(
          widget.buku != null ? Icons.edit_note : Icons.library_add,
          size: 50,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: _tanggalTextboxController,
        readOnly: true,
        onTap: () => _pickDate(context),
        decoration: InputDecoration(
          labelText: "Tanggal Masuk",
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.brown),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.brown.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.brown, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Wajib diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.brown),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.brown.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.brown, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "$label harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonSubmit() {
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
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(tombolSubmit,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.buku != null) {
                ubah();
              } else {
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    Buku createBuku = Buku(id: null);
    createBuku.judul = _judulTextboxController.text;
    createBuku.harga = int.parse(_hargaTextboxController.text);
    createBuku.jumlah = int.parse(_jumlahTextboxController.text);
    createBuku.tanggalMasuk = _tanggalTextboxController.text;
    createBuku.volume = int.parse(_volumeTextboxController.text);
    createBuku.penulis = _penulisTextboxController.text;
    createBuku.penerbit = _penerbitTextboxController.text;

    BukuBloc.addBuku(buku: createBuku).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const BukuPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    Buku updateBuku = Buku(id: widget.buku!.id!);
    updateBuku.judul = _judulTextboxController.text;
    updateBuku.harga = int.parse(_hargaTextboxController.text);
    updateBuku.jumlah = int.parse(_jumlahTextboxController.text);
    updateBuku.tanggalMasuk = _tanggalTextboxController.text;
    updateBuku.volume = int.parse(_volumeTextboxController.text);
    updateBuku.penulis = _penulisTextboxController.text;
    updateBuku.penerbit = _penerbitTextboxController.text;

    BukuBloc.updateBuku(buku: updateBuku).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const BukuPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}