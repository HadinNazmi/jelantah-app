# PRD (Product Requirement Document) — Mobile App Donatur (Sistem Donasi Minyak Jelantah)

**Versi**: 1.0  
**Target Platform**: Android Mobile (Built using Flutter)  
**Target User**: Masyarakat / Donatur Minyak Jelantah  
**Backend & Database**: Laravel API (Sanctum) + MySQL  

---

## 1. Pendahuluan & Tujuan Produk

Aplikasi Mobile Donatur dikembangkan sebagai sarana publik bagi masyarakat untuk melakukan sedekah/donasi minyak jelantah secara mandiri. Aplikasi ini memungkinkan donatur untuk menemukan titik lokasi TPS terdekat, menimbang minyak jelantah sendiri di lokasi, mengunggah foto bukti, serta memantau riwayat pengajuan donasi dan poin yang terkumpul.

---

## 2. Halaman & Fitur yang SUDAH Selesai (V1.0 - Current State)

Saat ini aplikasi mobile telah memiliki **3 Halaman Utama (Bottom Navigation)** dan **3 Halaman Sub/Form**:

### A. Alur Autentikasi
1. **Halaman Login (`lib/donatur/auth/login_page.dart`)**
   - Input Email & Password.
   - Pilihan/Proteksi Platform `mobile` (hanya akun role `donatur` yang diizinkan login).
   - Menyimpan token Sanctum secara lokal (`AuthService`).
2. **Halaman Register (`lib/donatur/auth/register_page.dart`)**
   - Self-service registration untuk masyarakat (Nama, Email, Password, Konfirmasi Password, Nomor HP).
   - Otomatis membuat baris `data_masyarakat` dan `dompet_user` di database backend.

---

### B. Halaman Utama (Bottom Navigation Bar — `MainNavigation`)

#### 1. Halaman Home (`lib/donatur/pages/home_page.dart`)
- **Header & Kartu Ringkasan Dompet**:
  - Menampilkan total kontribusi minyak jelantah (dalam Liter).
  - Menampilkan akumulasi total poin.
- **Daftar Lokasi TPS Jelantah Aktif**:
  - Mengambil data lokasi dari API `GET /lokasi`.
  - **Badge Status Real-Time**: Menampilkan indikator **Buka** (Hijau) atau **Tutup** (Merah) yang dihitung otomatis oleh backend berdasarkan `jam_buka`, `jam_tutup`, dan `hari_operasional`.
- **Aksi Donasi**:
  - Jika lokasi berstatus **Buka**, donatur dapat men-tap lokasi tersebut untuk langsung membuka form pengajuan donasi.

#### 2. Halaman Riwayat (`lib/donatur/pages/riwayat_page.dart`)
- **Daftar Riwayat Donasi**:
  - Memuat seluruh pengajuan donasi milik donatur dari API `GET /donasi`.
- **Pembeda Visual Status (*Status Chip*)**:
  - 🟡 **Pending**: Pengajuan baru masuk, menunggu verifikasi pengelola.
  - 🔵 **Diverifikasi**: Pengelola telah mencocokkan fisik & angka timbangan.
  - 🟢 **Selesai**: Donasi berhasil diproses final & poin telah ditambahkan.
- **Detail Item**:
  - Nama TPS Lokasi Donasi.
  - Tanggal & Waktu Pengajuan (`DD/MM/YYYY HH:mm`).
  - Jumlah Input (Liter).
  - Hasil Timbangan Terverifikasi (Liter, jika sudah diverifikasi).
  - Poin Diperoleh (jika status selesai).
- **Fitur UX**: Pull-to-refresh (`RefreshIndicator`) & Empty state display.

#### 3. Halaman Profil (`lib/donatur/pages/profil_page.dart`)
- **Header Profil**: Avatar inisial nama, Nama Lengkap, dan Email.
- **Ringkasan Dompet**: Visual total liter minyak dan total poin.
- **Informasi Pribadi**:
  - Email (read-only).
  - Nomor HP.
  - **NIK** (Nomor Induk Kependudukan).
  - Alamat Tempat Tinggal.
- **Aksi**:
  - Tombol **Edit Profil** (membuka `EditProfilPage`).
  - Tombol **Logout** (dengan dialog konfirmasi).

---

### C. Halaman Sub / Form

1. **Halaman Form Ajukan Donasi (`lib/donatur/pages/donasi_form_page.dart`)**
   - Pre-filled Nama Lokasi TPS tujuan.
   - Input Angka Timbangan (jumlah liter, mendukung decimal).
   - Pengambilan Foto Bukti langsung dari Kamera HP (`image_picker`).
   - Submit `MultipartRequest` ke API `POST /donasi`.
2. **Halaman Edit Profil (`lib/donatur/pages/edit_profil_page.dart`)**
   - Edit Nama Lengkap, Nomor HP, **NIK**, dan Alamat.
   - Submit update data ke API `PUT /profile`.

---

## 3. Fitur & Halaman Selanjutnya yang DIBUTUHKAN (Roadmap V1.1+)

Berdasarkan analisis *Project Brief* dan *Skema Database*, berikut adalah halaman dan fitur lanjutan yang disarankan untuk dikembangkan pada Aplikasi Mobile Donatur:

---

### 🗺️ Fitur Lanjutan 1: Detail & Peta Lokasi TPS (`LokasiDetailPage`)
- **Latar Belakang**: Donatur membutuhkan petunjuk arah dan informasi lengkap lokasi TPS sebelum membawa minyak jelantah.
- **Fitur di Halaman**:
  - Tampilan alamat lengkap dan foto/gambar TPS.
  - Jam & Hari operasional detail (misal: "Senin - Jumat, 08:00 - 17:00").
  - Nama Pengelola TPS & tombol kontak (WhatsApp/Telepon Pengelola).
  - **Integrasi Google Maps**: Tombol *"Petunjuk Arah"* yang membuka aplikasi Google Maps/Waze mengarahkan koordinat `latitude` & `longitude` TPS.

---

### 📄 Fitur Lanjutan 2: Halaman Detail Donasi (`DonasiDetailPage`)
- **Latar Belakang**: Donatur ingin melihat bukti foto yang diunggah serta linimasa/riwayat verifikasi donasinya secara detail.
- **Fitur di Halaman**:
  - Preview Foto Bukti Timbangan ukuran penuh (*Full Image Viewer*).
  - Status Timeline Progress:
    1. *Diajukan* (Tanggal & Jam)
    2. *Diverifikasi oleh Pengelola [Nama]* (Tanggal & Jam)
    3. *Selesai & Poin Diterima* (Tanggal & Jam)
  - Perbandingan Angka Input vs Angka Verifikasi Pengelola.

---

### 🔑 Fitur Lanjutan 3: Ganti Password (`GantiPasswordPage`)
- **Latar Belakang**: Keamanan akun donatur jika ingin memperbarui password.
- **Fitur di Halaman**:
  - Form password lama, password baru, dan konfirmasi password baru.
  - Menghubungkan ke API backend `PUT /profile/password`.

---

### 🎁 Fitur Lanjutan 4: Informasi Poin & Katalog Hadiah (`PoinKatalogPage`)
- **Latar Belakang**: Meningkatkan motivasi masyarakat dengan memberikan kejelasan mengenai nilai poin dan opsi penukarannya.
- **Fitur di Halaman**:
  - Penjelasan Skema Poin (misal: *1 Liter = 1 Poin* diambil dari `GET /konfigurasi-poin`).
  - Katalog Hadiah/Voucher (jika di fase mendatang ada program penukaran minyak dengan sembako/e-money).
  - Riwayat Mutasi Poin (Poin Masuk dari Donasi & Poin Keluar).

---

### 🔔 Fitur Lanjutan 5: Push / In-App Notification (Notifikasi Status Donasi)
- **Latar Belakang**: Donatur mendapat pemberitahuan saat pengelola selesai memverifikasi donasinya.
- **Fitur**:
  - Notifikasi saat status beralih dari `Pending` ➡️ `Diverifikasi` ➡️ `Selesai`.

---

## 4. Matriks Halaman, Endpoint API & Tabel Database

| Halaman Mobile | Endpoint API Backend | Tabel MySQL Terkait | Status |
|---|---|---|---|
| **Login** | `POST /login` | `users` | ✅ Selesai |
| **Register** | `POST /register` | `users`, `data_masyarakat`, `dompet_user` | ✅ Selesai |
| **Home** | `GET /dompet`, `GET /lokasi` | `dompet_user`, `lokasi` | ✅ Selesai |
| **Ajukan Donasi** | `POST /donasi` | `donasi` | ✅ Selesai |
| **Riwayat Donasi** | `GET /donasi` | `donasi`, `lokasi` | ✅ Selesai |
| **Profil Donatur** | `GET /me`, `GET /dompet` | `users`, `data_masyarakat`, `dompet_user` | ✅ Selesai |
| **Edit Profil** | `PUT /profile` | `users`, `data_masyarakat` | ✅ Selesai |
| **Detail Donasi** *(Lanjutan)* | `GET /donasi/{id}` | `donasi`, `lokasi`, `users` | ⏳ Terencana (V1.1) |
| **Detail Lokasi & Peta** *(Lanjutan)* | `GET /lokasi/{id}` | `lokasi` | ⏳ Terencana (V1.1) |
| **Ganti Password** *(Lanjutan)* | `PUT /profile/password` | `users` | ⏳ Terencana (V1.1) |
| **Info Poin** *(Lanjutan)* | `GET /konfigurasi-poin` | `konfigurasi_poin` | ⏳ Terencana (V1.1) |
