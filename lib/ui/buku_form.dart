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
  String tombolSubmit = "Simpan";

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
        judul = "UBAH BUKU";
        tombolSubmit = "UBAH";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField("Judul Buku", _judulTextboxController),
                _buildTextField("Harga", _hargaTextboxController, isNumber: true),
                _buildTextField("Jumlah", _jumlahTextboxController, isNumber: true),
                _buildTextField("Tanggal Masuk", _tanggalTextboxController),
                _buildTextField("Volume", _volumeTextboxController, isNumber: true),
                _buildTextField("Penulis", _penulisTextboxController),
                _buildTextField("Penerbit", _penerbitTextboxController),
                const SizedBox(height: 20),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "$label harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      child: Text(tombolSubmit),
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