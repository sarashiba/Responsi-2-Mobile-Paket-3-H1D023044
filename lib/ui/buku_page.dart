import 'package:flutter/material.dart';
import 'package:responsi2mobile_paket3_h1d023044/bloc/buku_bloc.dart';
import 'package:responsi2mobile_paket3_h1d023044/bloc/logout_bloc.dart';
import 'package:responsi2mobile_paket3_h1d023044/model/buku.dart';
import 'package:responsi2mobile_paket3_h1d023044/ui/buku_detail.dart';
import 'package:responsi2mobile_paket3_h1d023044/ui/buku_form.dart';
import 'package:responsi2mobile_paket3_h1d023044/ui/login_page.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({Key? key}) : super(key: key);

  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  List<Buku> _listBuku = [];
  List<Buku> _listSearch = [];
  bool _loading = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    setState(() {
      _loading = true;
    });
    
    BukuBloc.getBuku().then((value) {
      setState(() {
        _listBuku = value;
        _listSearch = value; 
        _loading = false;    
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      print("Error: $error");
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Buku> results = [];
    if (enteredKeyword.isEmpty) {
      results = _listBuku;
    } else {
      results = _listBuku
          .where((item) =>
              item.judul!.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              item.penulis!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _listSearch = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Buku Sarah'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: const Icon(Icons.add, size: 26.0),
                onTap: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BukuForm()));
                  getData(); 
                },
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Admin"),
              accountEmail: Text("admin@tokobuku.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.brown),
              ),
              decoration: BoxDecoration(color: Colors.brown),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false)
                    });
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Cari Judul atau Penulis...",
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                : _listSearch.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.search_off, size: 70, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("Buku tidak ditemukan",
                                style: TextStyle(color: Colors.grey, fontSize: 16)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: _listSearch.length,
                        itemBuilder: (context, index) {
                          return ItemBuku(buku: _listSearch[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class ItemBuku extends StatelessWidget {
  final Buku buku;
  const ItemBuku({Key? key, required this.buku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BukuDetail(
                      buku: buku,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD7CCC8), Color(0xFF8D6E63)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.3),
              blurRadius: 7,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.book, color: Colors.brown, size: 28),
          ),
          title: Text(
            buku.judul!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.brown,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                "Penulis: ${buku.penulis}",
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                "Rp ${buku.harga}",
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.black26),
        ),
      ),
    );
  }
}