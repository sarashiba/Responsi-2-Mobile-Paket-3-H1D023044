class Buku {
  int? id;
  String? judul;
  int? harga;
  int? jumlah;
  String? tanggalMasuk;
  int? volume;
  String? penulis;
  String? penerbit;

  Buku({
    this.id,
    this.judul,
    this.harga,
    this.jumlah,
    this.tanggalMasuk,
    this.volume,
    this.penulis,
    this.penerbit,
  });

  factory Buku.fromJson(Map<String, dynamic> obj) {
    return Buku(
      id: int.tryParse(obj['id'].toString()),
      judul: obj['judul'],
      harga: int.tryParse(obj['harga'].toString()),
      jumlah: int.tryParse(obj['jumlah'].toString()),
      tanggalMasuk: obj['tanggal_masuk'],
      volume: int.tryParse(obj['volume'].toString()),
      penulis: obj['penulis'],
      penerbit: obj['penerbit'],
    );
  }
}