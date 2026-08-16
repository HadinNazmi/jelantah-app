# Design System & UI Specification — Sedekah Jelantah Mobile App

## 1. Overview & Visual Direction
Aplikasi mobile modern bertema lingkungan dan keberlanjutan (Eco-friendly / Waste-to-Energy). Mengadopsi tata letak finansial/dashboard yang bersih dan elegan (seperti aplikasi e-wallet modern) dengan visual yang ramah pengguna, modern card floating, gradient header, dan navigasi ergonomis.

---

## 2. Color Palette & Typography

### Color Tokens (Light Green & Clean Eco Palette)
- **Primary Color:** `#10B981` (Emerald Green)
- **Primary Light / Accent:** `#34D399` (Mint Green)
- **Primary Dark (Header Gradient Top):** `#047857` (Deep Pine Green)
- **Primary Bright (Header Gradient Bottom):** `#10B981` to `#059669` (Vibrant Emerald)
- **Secondary / Highlight (Reward & Oil Gold):** `#F59E0B` (Amber / Golden Yellow)
- **Background Color:** `#F8FAFC` (Ultra-light Slate Grey / Off-White)
- **Surface / Card Background:** `#FFFFFF` (Pure White with subtle drop shadow)
- **Text Primary:** `#0F172A` (Slate Dark Navy)
- **Text Secondary:** `#64748B` (Muted Slate)
- **Border & Outline:** `#E2E8F0` (Soft Grey Border)

### Status Badges Color
- **Pending (Menunggu Verifikasi):** Background `#FEF3C7`, Text `#D97706` (Amber/Yellow)
- **Diverifikasi (Proses Validasi):** Background `#E0F2FE`, Text `#0284C7` (Sky Blue)
- **Selesai (Berhasil & Poin Ditambahkan):** Background `#DCFCE7`, Text `#15803D` (Soft Emerald)
- **Buka (TPS Open):** `#10B981` (Green Pill)
- **Tutup (TPS Closed):** `#EF4444` (Red Pill)

### Typography & Spacing
- **Font Family:** Inter / Plus Jakarta Sans / Roboto
- **Header Large:** 24pt, Bold, White (pada curved header)
- **Section Title:** 18pt, Semi-Bold, Text Primary
- **Body & Captions:** 13pt - 15pt, Regular / Medium
- **Border Radius:**
  - Floating Hero Card: `24px`
  - Action Buttons & Small Cards: `16px`
  - Status Pills / Badges: `100px` (Full Rounded)

---

## 3. Core Screens & Layout Specifications

### Screen 1: Onboarding / Welcome Screen
- **Background:** Clean White `#FFFFFF` dengan aksen ilustrasi daur ulang/minyak jelantah modern minimalis di tengah.
- **Hero Element:** Preview mockup kartu kontribusi berwarna gradient hijau emerald floating di atas ilustrasi.
- **Typography:**
  - Title: *"Ubah Minyak Jelantah Menjadi Kebaikan"* (26pt, Bold, `#0F172A`)
  - Subtitle: *"Sedekahkan minyak jelantahmu di TPS terdekat, jaga lingkungan, dan kumpulkan poin kontribusi."* (15pt, Muted)
- **Page Indicator:** 4 dots slider, dot aktif berwarna Emerald Green (`#10B981`).
- **Primary Action Button:** Full-width rounded button dengan warna `#10B981`, teks *"Mulai Sekarang"*, text white, bold.

---

### Screen 2: Home Screen (Dashboard Donatur)
- **Top Bar & Header:**
  - Curved gradient background dari Deep Green (`#047857`) ke Emerald (`#10B981`).
  - Left: User Avatar + *"Selamat Datang!"*, Nama Pengguna (`Oliver Bennet` style).
  - Right: Bell Icon (Notifikasi) dengan badge indicator.
- **Hero Contribution Card (Floating on Header):**
  - Card warna Putih (`#FFFFFF`) atau semi-transparent frost di atas gradient hijau.
  - Title: `Total Kontribusi Jelantah` dengan eye toggle icon.
  - Big Metric: `12.5 Liter` (32pt, Bold, Emerald/Navy).
  - Sub-metric: `125 Poin Terkumpul` (Amber Gold badge).
  - Two Action Buttons di dalam kartu:
    - Button 1: **[+ Donasi Sekarang]** (Filled Emerald Button `#10B981`, icon timbangan/upload).
    - Button 2: **[Riwayat Poin]** (Outlined/Soft Button `#ECFDF5`, text emerald).
- **Banner Info / Alert:**
  - Rounded Card tipis warna `#FEF3C7` (Soft Yellow) dengan icon info.
  - Text: *"Bawa minyak jelantah dalam wadah tertutup ke TPS terdekat!"*
- **Quick Action Grid (4 Icons in a Row):**
  1. **Donasi** (Icon Timbangan)
  2. **Cari TPS** (Icon Map Pin)
  3. **Poin & Hadiah** (Icon Gift / Trophy)
  4. **Panduan** (Icon Book / Info)
- **Section: TPS Terdekat (Live Operational Status):**
  - Section header: *"Lokasi TPS Terdekat"* + button *"Lihat Semua"*.
  - List of TPS Cards (Horizontal scroll / Vertical cards):
    - Nama TPS (e.g. `TPS Kelurahan Sukajadi`).
    - Alamat ringkas & jarak (e.g. `1.2 km`).
    - Jam operasional: `08:00 - 17:00 WIB`.
    - Live Badge: `Buka` (Hijau) atau `Tutup` (Merah).
- **Section: Riwayat Donasi Terakhir:**
  - Menampilkan 3 aktivitas donasi terakhir dengan status badge (`Pending`, `Diverifikasi`, `Selesai`).

---

### Screen 3: Form Ajukan Donasi (`DonasiFormPage`)
- **Header:** Simple clean top app bar dengan tombol back dan judul *"Ajukan Donasi"*.
- **Lokasi Card:** Dropdown / Selected card TPS tujuan lengkap dengan badge status buka.
- **Input Angka Timbangan:**
  - Card besar dengan input field angka numerik di tengah (e.g. `2.5`).
  - Unit selector / label di samping kanan: `Liter`.
- **Upload Bukti Timbangan:**
  - Dashed outline container (`#E2E8F0` dengan background `#F8FAFC`).
  - Icon Kamera + teks *"Ambil Foto Hasil Timbangan di Lokasi"*.
  - Preview thumbnail foto setelah difoto dari kamera langsung.
- **CTA Button:** Bottom pinned button *"Kirim Pengajuan Donasi"* (`#10B981`, full width, rounded `16px`).

---

### Screen 4: Riwayat Donasi (`RiwayatPage`)
- **Top Tabs Filter:** All, Pending, Selesai.
- **List Items:**
  - Card putih dengan rounded corners `16px` dan subtle shadow.
  - Icon donasi di sebelah kiri dalam rounded square hijau muda (`#ECFDF5`).
  - Baris 1: Nama TPS + Status Chip (`Pending` / `Diverifikasi` / `Selesai`).
  - Baris 2: Tanggal & Waktu (`16 Aug 2026, 14:30 WIB`).
  - Baris 3: `+2.5 Liter` (Bold) • `+25 Poin`.

---

### Screen 5: Profil Donatur (`ProfilPage`)
- **Header Section:** Avatar besar, Nama Donatur, Email, dan NIK badge.
- **Summary Metrics (2 Columns Card):**
  - Box 1: Total Volume (`45.0 L`).
  - Box 2: Total Poin (`450 Pts`).
- **Menu List Options:**
  - Edit Informasi Pribadi (Nama, NIK, Alamat, No. HP).
  - Ganti Kata Sandi.
  - Informasi & Ketentuan Sedekah Jelantah.
  - Hubungi Pengelola / CS.
  - Logout (Warna Merah Soft).

---

## 4. Bottom Navigation Bar
Floating pill atau dock navigation di bagian bawah dengan 3 menu:
1. **Home** (Icon Home)
2. **Riwayat** (Icon Receipt / History)
3. **Profil** (Icon User / Person)
- *Active State:* Icon & Text berwarna Emerald Green (`#10B981`) dengan pill indicator halus di atas/bawah icon.
- *Inactive State:* Icon & Text berwarna Slate Muted (`#94A3B8`).