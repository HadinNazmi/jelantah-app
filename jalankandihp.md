# Instruksi: Menjalankan Project di HP Fisik

Dokumen ini adalah instruksi operasional untuk Antigravity IDE. Ketika Hadin bilang sesuatu seperti **"jalankan di HP"**, **"run ke HP"**, atau sejenisnya, langsung eksekusi seluruh langkah di bawah **tanpa bertanya konfirmasi terlebih dahulu**. Asumsikan HP sudah tersambung via USB dengan USB Debugging aktif — jangan tanyakan ini, langsung cek lewat `flutter devices`.

## Yang harus dipastikan/dijalankan, berurutan

### 1. Pastikan MySQL (XAMPP) menyala
Cek dulu apakah MySQL sudah berjalan (misal lewat `netstat -ano | findstr :3306`, atau cek status di XAMPP Control Panel kalau memungkinkan diakses). Kalau belum menyala, nyalakan MySQL dari XAMPP.

Jika MySQL gagal menyala dengan error seputar "shutdown unexpectedly" atau "Incorrect file format" pada tabel sistem (`mysql` database, bukan `db_jelantah`), ini pernah terjadi sebelumnya dan diperbaiki dengan mengganti folder `C:\xampp\mysql\data\mysql` yang korup dengan salinan bersih dari `C:\xampp\mysql\backup\mysql`. Database `db_jelantah` (folder terpisah) tidak boleh disentuh/dihapus.

### 2. Pastikan Laravel backend berjalan dengan host yang bisa diakses HP
Backend HARUS dijalankan dengan `--host=0.0.0.0`, bukan default `php artisan serve` biasa, supaya bisa diakses dari HP di jaringan WiFi yang sama:

```
cd jelantah-backend
php artisan serve --host=0.0.0.0 --port=8000
```

Jalankan di terminal terpisah dan biarkan tetap terbuka. Kalau sudah ada proses serve yang berjalan di port 8000, tidak perlu dijalankan ulang.

### 3. Pastikan baseUrl Flutter mengarah ke IP lokal laptop, bukan 127.0.0.1
Cek isi `jelantah_app/lib/core/api/api_client.dart` — variabel `baseUrl` harus berupa IP address lokal laptop (format `192.168.x.x`), didapat dari `ipconfig` (cari "IPv4 Address" di adapter WiFi aktif), bukan `127.0.0.1` (itu hanya untuk testing di Chrome/desktop) dan bukan `10.0.2.2` (itu khusus emulator, bukan HP fisik).

Jika IP laptop berubah (misal ganti jaringan WiFi), update baris ini sesuai IP terbaru sebelum run.

### 4. Cek HP terdeteksi
```
cd jelantah_app
flutter devices
```
Pastikan muncul device Android (SM A155F atau nama device lain yang tersambung). Jangan tanya user apakah USB debugging aktif — anggap selalu aktif.

### 5. Jalankan ke HP
```
flutter run
```

## Known issues dan fix yang sudah diterapkan (permanen, jangan diulang tanya)
- **kotlin.incremental cross-drive bug**: project ada di drive D:, sebelumnya pub-cache ada di drive C: yang menyebabkan Kotlin build gagal dengan error "different roots" khususnya pada plugin `image_picker_android`. Sudah diperbaiki permanen dengan environment variable `PUB_CACHE=D:\pub-cache` (User-level Windows environment variable) — TIDAK PERLU diulangi kecuali error yang sama muncul lagi. Kalau muncul lagi, solusinya adalah restart total aplikasi Antigravity (bukan cuma terminal) supaya environment variable terbaru terbaca oleh proses baru.
- File `android/gradle.properties` juga berisi `kotlin.incremental=false` sebagai lapisan tambahan.

## Yang TIDAK perlu ditanyakan ke user
- Apakah USB debugging aktif (anggap selalu aktif)
- Apakah boleh menjalankan XAMPP/MySQL
- Apakah boleh menjalankan `php artisan serve`
- Konfirmasi sebelum menjalankan `flutter run`

Langsung jalankan semua langkah di atas secara berurutan begitu diminta run ke HP, dan laporkan hasil akhirnya (berhasil terbuka di HP, atau error apa yang muncul jika gagal).