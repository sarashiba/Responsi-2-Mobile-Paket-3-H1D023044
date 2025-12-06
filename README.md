# Responsi 2 Mobile Paket 3 H1D023044

Aplikasi *mobile* untuk manajemen inventaris buku (CRUD) yang dibangun menggunakan **Flutter** sebagai Frontend dan **CodeIgniter 4** sebagai Backend API.

## 1. Identitas
Nama : Sarah Shiba Huwaidah<br>
NIM : H1D023044<br>
Shift Baru : C<br>
Shift KRS :  A

## 2. Video Demo Aplikasi
https://github.com/user-attachments/assets/86af0525-5aeb-4555-8af9-eb5dfe987c68

## 3. Spesifikasi API
Aplikasi ini terhubung dengan Backend CodeIgniter 4. Berikut adalah dokumentasi endpoint yang digunakan:

**Base URL:** `http://192.168.105.3:8080` (IP laptop)

### A. Autentikasi
| Fitur | Method | Endpoint | Format Body (JSON) |
| :--- | :--- | :--- | :--- |
| **Registrasi** | `POST` | `/registrasi` | `{"nama": "...", "email": "...", "password": "..."}` |
| **Login** | `POST` | `/login` | `{"email": "...", "password": "..."}` |

### B. Inventaris Buku
| Fitur | Method | Endpoint | Keterangan |
| :--- | :--- | :--- | :--- |
| **List Buku** | `GET` | `/buku` | Mengambil semua data buku |
| **Detail Buku** | `GET` | `/buku/{id}` | Mengambil 1 buku berdasarkan ID |
| **Tambah Buku** | `POST` | `/buku` | Menambah buku baru (Lihat Body di bawah) |
| **Ubah Buku** | `PUT` | `/buku/{id}` | Mengubah data buku (Lihat Body di bawah) |
| **Hapus Buku** | `DELETE` | `/buku/{id}` | Menghapus buku berdasarkan ID |

**Detail Body Request (Buku):**
: ```
{
    "judul": "String",
    "harga": "Integer",
    "jumlah": "Integer",
    "tanggal_masuk": "String",
    "volume": "Integer",
    "penulis": "String",
    "penerbit": "String"
}```

## 4. Penjelasan Kode & Fungsi

Berikut adalah rincian fungsi dari setiap komponen kode yang membangun aplikasi ini:

### A. Helpers (Penghubung Data)
**File:** `lib/helpers/api.dart`
* **`post(url, data)`**: Mengirim data (seperti login atau tambah buku) ke server menggunakan method HTTP POST. Fungsi ini menyertakan *header* `Content-Type: application/json` dan Token Bearer.
* **`get(url)`**: Mengambil data dari server (seperti list buku) menggunakan method HTTP GET.
* **`put(url, data)`**: Mengirim pembaruan data ke server menggunakan method HTTP PUT.
* **`delete(url)`**: Menghapus data di server berdasarkan ID menggunakan method HTTP DELETE.
* **`_returnResponse(response)`**: Menangani status kode dari server. Jika 200 (OK) data dikembalikan, jika 400/401/500 akan memunculkan *Exception* (Error) yang sesuai.

**File:** `lib/helpers/user_info.dart`
* **`setToken(value)`**: Menyimpan token sesi login ke dalam memori lokal HP (*Shared Preferences*).
* **`getToken()`**: Mengambil token yang tersimpan untuk digunakan pada *header* API request.
* **`setUserID(value)` & `getUserID()`**: Menyimpan dan mengambil ID pengguna yang sedang login.
* **`logout()`**: Menghapus semua data sesi (token & ID) dari memori HP saat user keluar.

---

### B. Model (Representasi Data)
**File:** `lib/model/buku.dart`
* **`class Buku`**: Mendefinisikan atribut buku sesuai database (Judul, Harga, Penulis, dll).
* **`fromJson(obj)`**: Fungsi *factory* untuk mengubah data JSON mentah dari API menjadi objek Dart agar bisa ditampilkan di aplikasi. Konversi tipe data (seperti String ke Integer) dilakukan di sini.

**File:** `lib/model/login.dart` & `registrasi.dart`
* Berfungsi memetakan respon JSON hasil Login/Registrasi (status, code, token) menjadi objek yang bisa dicek validitasnya.

---

### C. Bloc (Business Logic Component)
**File:** `lib/bloc/buku_bloc.dart`
* **`getBuku()`**: Memanggil API GET, lalu mengubah list JSON menjadi `List<Buku>`.
* **`addBuku(buku)`**: Mengemas data buku dari form ke dalam Map/JSON, lalu mengirimnya ke API via POST.
* **`updateBuku(buku)`**: Mengirim data buku yang sudah diedit ke API via PUT berdasarkan ID buku.
* **`deleteBuku(id)`**: Mengirim permintaan hapus ke API via DELETE berdasarkan ID buku.

**File:** `lib/bloc/login_bloc.dart`
* **`login(email, password)`**: Mengirim kredensial user ke API. Jika sukses, mengembalikan objek Login berisi Token.

---

### D. UI (Tampilan Antarmuka)
**File:** `lib/ui/buku_page.dart` (Halaman Utama)
* **`getData()`**: Fungsi yang dipanggil saat aplikasi dibuka. Ia memanggil `BukuBloc.getBuku()` untuk mengisi daftar buku dan menampilkannya.
* **`_runFilter(keyword)`**: Logika pencarian *client-side*. Memfilter daftar buku berdasarkan kesamaan teks pada Judul atau Penulis sesuai ketikan user.
* **`build()`**: Membangun tampilan utama, termasuk Search Bar, Drawer Menu, dan ListView buku.

**File:** `lib/ui/buku_detail.dart`
* Menampilkan rincian lengkap satu buku.
* **`confirmHapus()`**: Menampilkan dialog konfirmasi sebelum menghapus buku. Jika "Ya", memanggil `BukuBloc.deleteBuku`.

**File:** `lib/ui/buku_form.dart`
* Digunakan untuk dua fungsi: **Tambah** dan **Edit**.
* **`simpan()`**: Dipanggil jika form dalam mode tambah. Mengirim data baru.
* **`ubah()`**: Dipanggil jika form dalam mode edit (membawa data ID buku). Memperbarui data lama.

---

### E. Main
**File:** `lib/main.dart`
* **`isLogin()`**: Mengecek apakah ada token tersimpan di `UserInfo`.
    * Jika Ada: Arahkan langsung ke `BukuPage` (Dashboard).
    * Jika Tidak Ada: Arahkan ke `LoginPage`.
