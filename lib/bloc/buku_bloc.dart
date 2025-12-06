import 'dart:convert';
import 'package:responsi2mobile_paket3_h1d023044/helpers/api.dart';
import 'package:responsi2mobile_paket3_h1d023044/helpers/api_url.dart';
import 'package:responsi2mobile_paket3_h1d023044/model/buku.dart';

class BukuBloc {
  static Future<List<Buku>> getBuku() async {
    String apiUrl = ApiUrl.listBuku;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listBuku = (jsonObj as Map<String, dynamic>)['data'];
    List<Buku> bukus = [];
    for (int i = 0; i < listBuku.length; i++) {
      bukus.add(Buku.fromJson(listBuku[i]));
    }
    return bukus;
  }

  static Future addBuku({Buku? buku}) async {
    String apiUrl = ApiUrl.createBuku;

    var body = {
      "judul": buku!.judul,
      "harga": buku.harga.toString(),
      "jumlah": buku.jumlah.toString(),
      "tanggal_masuk": buku.tanggalMasuk,
      "volume": buku.volume.toString(),
      "penulis": buku.penulis,
      "penerbit": buku.penerbit,
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateBuku({required Buku buku}) async {
    String apiUrl = ApiUrl.updateBuku(buku.id!);

    var body = {
      "judul": buku.judul,
      "harga": buku.harga.toString(),
      "jumlah": buku.jumlah.toString(),
      "tanggal_masuk": buku.tanggalMasuk,
      "volume": buku.volume.toString(),
      "penulis": buku.penulis,
      "penerbit": buku.penerbit,
    };

    var response = await Api().put(apiUrl, body); 
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteBuku({int? id}) async {
    String apiUrl = ApiUrl.deleteBuku(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data']; 
  }
}