# Product Requirements Document (PRD) & Prompt Desain Google Stitch
## System Web Admin — Si Jelantah (Platform Bank Sampah & Donasi Minyak Jelantah)

---

## 1. Ringkasan Eksekutif (Executive Summary)

**Si Jelantah Web Admin** adalah platform manajemen web yang digunakan oleh dua peran (role) utama:
1. **Pengelola TPS / Tempat Penampungan**: Petugas di lapangan yang menerima minyak jelantah dari masyarakat/donatur, melakukan verifikasi penimbangan fisik, serta mengelola jam & hari operasional TPS.
2. **Tim Manajemen / Admin CSR**: Pengambil keputusan yang memantau rekap data agregat nasional/lokal, mengelola akun pengelola TPS, serta menyesuaikan konfigurasi rasio penukaran poin (*rate* liter ke poin).

Dokumen ini disusun lengkap dengan spesifikasi teknis, alur pengguna (*user flow*), skema data API, serta **Prompt Desain khusus untuk Google Stitch** untuk setiap halaman web.

---

## 2. Design System & Design Tokens (Visual Identity)

### 2.1 Skema Warna (Color Palette)
- **Primary Color (Emerald Green)**: `#006c49` (Warna utama branding Si Jelantah, navbar active, button utama)
- **Primary Fixed / Light Tint**: `#6ffbbe` / `#e6f9f0` (Background aksen kartu & highlight)
- **Secondary Color (Amber / Gold)**: `#855300` / `#fea619` (Aksen status pending & penukaran poin)
- **Status Colors**:
  - **Selesai / Buka**: `#10b981` (Emerald Green) / `#E0F2FE` (Sky Light)
  - **Verifikasi / Proses**: `#0284C7` (Sky Blue)
  - **Pending / Tutup**: `#D97706` (Amber/Orange) / `#EF4444` (Red Rose)
- **Background Surface**: `#f7f9fb` (Off-white / Slate tint)
- **Card Surface**: `#ffffff` (Clean white dengan subtle border `#E2E8F0` & shadow `0 2px 8px rgba(0,0,0,0.04)`)
- **Typography Text**: `#0F172A` (Slate Navy Dark) / `#64748B` (Muted Grey)

### 2.2 Tipografi & Layout Structure
- **Font Family**: Google Fonts — `Plus Jakarta Sans` / `Inter`
- **Grid Layout**: Responsive Sidebar (`NavigationRail` 240px) + Main Content Area (`px-8 py-6 max-w-7xl mx-auto`)

---

## 3. Matriks Peran & Hak Akses (Role & Access Matrix)

| Fitur / Halaman | Donatur (Mobile) | Pengelola TPS (Web) | Manajemen CSR (Web) |
| :--- | :---: | :---: | :---: |
| Login Web Admin | ❌ (Ditolak) | ✅ | ✅ |
| Dashboard Agregat (Liter & Poin) | ❌ | ❌ | ✅ |
| Kelola Akun Pengelola TPS | ❌ | ❌ | ✅ |
| Konfigurasi Rate Poin (Liter -> Poin) | ❌ | ❌ | ✅ |
| Daftar & Verifikasi Donasi Masuk | ❌ | ✅ (Lokasi Sendiri) | ❌ |
| Set Jadwal Buka/Tutup TPS | ❌ | ✅ (Lokasi Sendiri) | ❌ |

---

## 4. Spesifikasi Per Halaman & Prompt Google Stitch

---

### Halaman 1: Login Admin Web (`AdminLoginPage`)

#### 4.1 Deskripsi & Alur Kerja
Halaman gerbang utama untuk autentikasi Pengelola TPS dan Tim Manajemen. Memastikan pengguna bersumber dari platform web dan memiliki peran yang sesuai. Jika pengguna dengan role `donatur` mencoba login, sistem menampilkan pesan penolakan akses.

#### 4.2 Komponen UI & Layout
- **Layout**: Centered Floating Card (`max-w-md w-full`) di atas background netral `#f7f9fb`.
- **Header**: Icon Leaf/Eco Emerald Green `#006c49`, Judul "Admin — Si Jelantah", Subtitle "Portal Pengelola & Manajemen".
- **Form**:
  - Input Email (Type: Email, Icon: Mail)
  - Input Password (Type: Password, Icon: Lock)
  - Button Action: "Masuk Ke Portal Admin" (`bg-[#006c49] text-white hover:bg-[#005137]`)
- **Feedback Banner**: Error Alert (merah lembut `#FEE2E2`) jika password salah atau role tidak sesuai.

#### 4.3 Integration Endpoint API
- **Endpoint**: `POST /api/login`
- **Payload**: `{ "email": "...", "password": "...", "platform": "web" }`
- **Response Handling**: Menyimpan Token Sanctum dan Role ke `AuthService` (Local Storage / Shared Preferences).

#### 4.4 🎨 Prompt Desain Google Stitch (Page 1)
```text
A modern, clean web login page for an environmental oil-recycling platform named 'Si Jelantah Web Admin'. 
Design Aesthetics: Minimalist M3 / Tailwind design, background #f7f9fb. Centered sleek white card (400px width) with soft rounded corners (24px) and subtle shadow.
Top Icon: Eco leaf emblem in deep emerald green (#006c49).
Typography: Plus Jakarta Sans. Bold title 'Admin — Si Jelantah', muted subtitle 'Portal khusus Pengelola & Manajemen'.
Form Elements: Two vertical input fields with rounded borders (#E2E8F0), labels 'Email Administrator' and 'Password', and icons. Full-width primary action button in emerald green (#006c49) with text 'Masuk ke Portal Admin'.
Include an alert state banner showing an error message in light red pill (#FEE2E2) for invalid role access.
```

---

### Halaman 2: Dashboard Pengelola Container (`DashboardPengelolaPage`)

#### 4.1 Deskripsi & Alur Kerja
Bingkai antarmuka (*shell container*) untuk Pengelola TPS yang terdiri dari sidebar navigasi kiri (`NavigationRail`) dan area konten dinamis di sebelah kanan.

#### 4.2 Komponen UI & Layout
- **Sidebar Kiri (Width: 240px)**:
  - Top Logo Brand: Logo Si Jelantah + Icon Leaf
  - Nav Item 1: `Icon: inbox` — "Donasi Masuk" (Active state: background emerald tint `#E6F9F0`)
  - Nav Item 2: `Icon: location_on` — "Kelola Lokasi Saya"
  - Bottom Action: `Icon: logout` — "Keluar Akun" (Pindah ke Login Admin)
- **Content Area**: Flexible Dynamic Panel mengisi sisa lebar layar.

#### 4.3 🎨 Prompt Desain Google Stitch (Page 2)
```text
A modern web dashboard layout shell featuring a fixed left sidebar navigation rail (240px) and a main content area.
Sidebar Style: Clean white background (#ffffff) with a subtle vertical divider (#E2E8F0).
Top Logo: Emerald green leaf icon (#006c49) with brand name 'Si Jelantah Pengelola'.
Navigation Links: Two vertical tab items with icons: 'Donasi Masuk' (inbox icon, active state with soft green pill background #E6F9F0 and green text #006c49) and 'Kelola Lokasi' (location icon, muted slate text #64748B).
Bottom Sidebar: Red-tinted logout icon button fixed at the bottom.
Main Content Area: Off-white background (#f7f9fb) occupying the remaining screen space.
```

---

### Halaman 3: Pengelola — Halaman Donasi Masuk (`DonasiMasukPage`)

#### 4.1 Deskripsi & Alur Kerja
Halaman utama Pengelola TPS untuk meninjau setoran minyak jelantah dari donatur, mengecek foto bukti timbangan, melakukan verifikasi penimbangan fisik aktual, serta menyelesaikan transaksi.

#### 4.2 Komponen UI & Layout
- **Top Bar**: Judul "Donasi Masuk", Subtitle "Daftar pengajuan minyak jelantah di lokasi Anda", Tombol Refresh (`Icon: refresh`).
- **Grid / List Card Donasi**:
  - Card Header: Donasi ID (`#DON-1024`), Badge Status (`PENDING`: Amber, `VERIFIKASI`: Blue, `SELESAI`: Green).
  - Info Donatur: Nama Donatur, Tanggal Pengajuan (`DD MMM YYYY, HH:mm`).
  - Data Comparison Pill:
    - Estimasi Donatur: `X.XX Liter`
    - Verifikasi Petugas: `X.XX Liter` (jika sudah diverifikasi)
  - **Media Preview**: Foto Bukti Timbangan (`width: 100%`, `height: 180px`, `object-fit: cover`, rounded corners 12px) dengan gambar timbangan fisik/jerigen.
  - Action Buttons:
    - Jika Status `PENDING`: Button "Verifikasi Penimbangan" (`bg-[#0284C7] text-white`) -> Membuka Dialog Input Liter Aktual.
    - Jika Status `VERIFIKASI`: Button "Tandai Selesai & Beri Poin" (`bg-[#10b981] text-white`).

#### 4.3 Integration Endpoint API
- `GET /api/pengelola/donasi` (Mendapatkan daftar donasi di lokasi pengelola)
- `PUT /api/pengelola/donasi/{id}/verifikasi` (Payload: `{ "jumlah_terverifikasi": 2.50 }`)
- `PUT /api/pengelola/donasi/{id}/selesai` (Mengubah status menjadi selesai & mencetak poin otomatis)

#### 4.4 🎨 Prompt Desain Google Stitch (Page 3)
```text
A web page UI for recycling center managers to inspect incoming oil donations.
Header: Title 'Donasi Masuk' with a refresh icon button on top right.
Cards List Layout: Responsive grid of cards (white background, 16px rounded corners, subtle border).
Card Item Components:
- Top bar: 'Donasi #1024' on left, status chip 'PENDING' in amber pill (#FEF3C7 text #D97706) on right.
- Donatur info: 'Input Donatur: 2.5 Liter'.
- Image Banner: Full-width container (height 180px, rounded-lg) displaying a clear photo proof of a jerrycan on a digital scale showing numbers.
- Bottom Action Area: Primary blue button 'Verifikasi Penimbangan' and green button 'Tandai Selesai'.
Modern typography in Plus Jakarta Sans, soft shadows, clean grid gaps (20px).
```

---

### Halaman 4: Pengelola — Kelola Lokasi & Jadwal TPS (`LokasiKelolaPage`)

#### 4.1 Deskripsi & Alur Kerja
Halaman bagi Pengelola TPS untuk mengatur jam operasional harian (jam buka/tutup), memilih hari operasional aktif, serta mengaktifkan/nonaktifkan status operasional TPS.

#### 4.2 Komponen UI & Layout
- **Header**: Nama TPS (misal: "TPS Jelantah RW 05"), Alamat Lengkap.
- **Section 1 — Jam Operasional**:
  - Two Column Input: Input "Jam Buka" (`HH:mm`) & Input "Jam Tutup" (`HH:mm`).
- **Section 2 — Hari Operasional**:
  - Multi-select FilterChips: `[Senin, Selasa, Rabu, Kamis, Jumat, Sabtu, Minggu]` (Active: Emerald Fill `#006c49`, Inactive: Grey Outlined `#E2E8F0`).
- **Section 3 — Status Aktif**:
  - Switch List Tile: Label "Status Lokasi Aktif", Subtitle "Nonaktifkan jika TPS sedang tutup sementara/renovasi".
- **Bottom Action**: Button "Simpan Perubahan Jadwal" (`w-full bg-[#006c49] py-3 text-white rounded-xl`).

#### 4.3 Integration Endpoint API
- `GET /api/pengelola/lokasi`
- `PUT /api/pengelola/lokasi/{id}` (Payload: `{ "jam_buka": "08:00", "jam_tutup": "17:00", "hari_operasional": "Senin,Selasa,Rabu,Kamis,Jumat", "status_aktif": true }`)

#### 4.4 🎨 Prompt Desain Google Stitch (Page 4)
```text
A web settings dashboard page for managing a recycling collection point schedule.
Header Section: Location name 'TPS Jelantah RW 05' in bold text with full address below in muted slate (#64748B).
Form Card Container (Max width 600px, white card, rounded-2xl, 24px padding):
- Section 'Jam Operasional': Two inline input fields for 'Jam Buka (08:00)' and 'Jam Tutup (17:00)' with clock icons.
- Section 'Hari Operasional': Horizontal wrap of toggleable filter chips for days of the week [Senin, Selasa, Rabu, Kamis, Jumat, Sabtu, Minggu]. Selected chips styled with solid emerald green fill (#006c49 text white), unselected in outline grey.
- Section 'Status Operasional': Toggle switch for 'Status Lokasi Aktif' with explanatory subtitle.
- Save Button: Full-width green button 'Simpan Perubahan Jadwal'.
```

---

### Halaman 5: Dashboard Manajemen Container (`DashboardManajemenPage`)

#### 5.1 Deskripsi & Alur Kerja
Bingkai antarmuka (*shell container*) untuk Tim Manajemen / CSR dengan sidebar 3 tab utama (Dashboard Agregat, Kelola Pengelola, Konfigurasi Poin).

#### 5.2 Komponen UI & Layout
- **Sidebar NavigationRail (240px)**:
  - Brand Logo: "Si Jelantah CSR Admin"
  - Tab 1: `Icon: dashboard` — "Dashboard Utama"
  - Tab 2: `Icon: people` — "Kelola Pengelola"
  - Tab 3: `Icon: stars` — "Konfigurasi Poin"
  - Bottom Action: `Icon: logout` — "Keluar Akun"

#### 5.3 🎨 Prompt Desain Google Stitch (Page 5)
```text
An executive admin shell layout for CSR management team.
Left Sidebar (240px width, clean white bg): Emerald green brand logo 'Si Jelantah CSR'. Three vertical navigation items with icons: 'Dashboard' (active tab), 'Kelola Pengelola', and 'Konfigurasi Poin'.
Main Area: Off-white background (#f7f9fb) displaying child dashboard widgets.
```

---

### Halaman 6: Manajemen — Dashboard Agregat (`DashboardContentPage`)

#### 6.1 Deskripsi & Alur Kerja
Halaman ringkasan eksekutif untuk melihat statistik total pengumpulan jelantah secara keseluruhan, total transaksi donasi selesai vs pending, serta rekapitulasi volume jelantah per lokasi TPS.

#### 6.2 Komponen UI & Layout
- **Header**: Judul "Dashboard Agregat", Refresh Button.
- **Top Metrics Row (3 Summary Cards)**:
  1. **Total Liter Terkumpul**: Icon Oil Barrel, Nilai `1,250 Liter`, Aksen Green `#10b981`.
  2. **Donasi Selesai**: Icon Check Circle, Nilai `142 Transaksi`, Aksen Blue `#0284C7`.
  3. **Donasi Pending**: Icon Hourglass, Nilai `8 Transaksi`, Aksen Amber `#D97706`.
- **Section Rekapitulasi per Lokasi TPS**:
  - Table / Card List: Icon Location Green, Nama TPS, Alamat, Total Volume (Liter), Status Keaktifan.

#### 6.3 Integration Endpoint API
- `GET /api/manajemen/dashboard`

#### 6.4 🎨 Prompt Desain Google Stitch (Page 6)
```text
An executive analytics dashboard page for a waste cooking oil collection organization.
Header: Title 'Dashboard Agregat' with date range indicator and refresh button.
Metrics Grid (3 Cards):
- Card 1 (Green accent bg #E6F9F0): Icon oil barrel, big text '1,250 Liter', label 'Total Jelantah Terkumpul'.
- Card 2 (Blue accent bg #E0F2FE): Icon check circle, big text '142', label 'Donasi Selesai'.
- Card 3 (Amber accent bg #FEF3C7): Icon hourglass, big text '8', label 'Menunggu Verifikasi'.
Below Metrics: Table list section 'Rekapitulasi Volume per TPS' showing TPS location names, active status badge, and total collected liters in bold text. Clean modern dashboard style.
```

---

### Halaman 7: Manajemen — Kelola Akun Pengelola (`KelolaPengelolaPage`)

#### 7.1 Deskripsi & Alur Kerja
Halaman manajemen akun Pengelola TPS. Tim Manajemen dapat menambahkan akun pengelola baru, mengedit data nama/no HP/jabatan, serta mematikan/mengaktifkan status akun (`is_active` toggle switch).

#### 7.2 Komponen UI & Layout
- **Header Bar**: Judul "Kelola Pengelola TPS", Refresh Button.
- **Floating Action Button**: "+ Tambah Pengelola" (`bg-[#006c49] text-white`).
- **Daftar Card / Table Pengelola**:
  - User Avatar (Green tint jika aktif, Grey jika nonaktif).
  - Nama Pengelola, Email, Nomor HP, Jabatan.
  - Nama TPS yang Dikelola (misal: `TPS Jelantah RW 05`).
  - Action Controls:
    - Button Edit (`Icon: edit`): Dialog Edit Data.
    - Toggle Switch (`is_active`): Sakelar Aktifkan/Nonaktifkan Akun dengan konfirmasi instan via API.
- **Dialog Form Tambah Akun Baru**:
  - Input: Nama Lengkap, Email, Password, Jabatan/Nomor HP.

#### 7.3 Integration Endpoint API
- `GET /api/manajemen/pengelola`
- `POST /api/manajemen/pengelola`
- `PUT /api/manajemen/pengelola/{id}`
- `PUT /api/manajemen/pengelola/{id}/toggle-status`

#### 7.4 🎨 Prompt Desain Google Stitch (Page 7)
```text
A web management portal page for managing recycling site operator user accounts.
Top Header: Title 'Kelola Pengelola TPS' with an emerald green Floating Action Button '+ Tambah Pengelola'.
User Cards List / Data Table:
- Row Item: User avatar icon (green circle if active, grey circle if deactivated).
- User details: Name 'Budi Santoso', email 'pengelola@test.com', phone '08123456789', and assigned TPS location name 'TPS Jelantah RW 05'.
- Right Controls: Edit icon button and an iOS-style Toggle Switch representing account active status (green ON, grey OFF).
Modal Dialog overlay prompt for adding new operator with text fields for Name, Email, Password, and Designation.
```

---

### Halaman 8: Manajemen — Konfigurasi Rate Poin (`KonfigurasiPoinPage`)

#### 8.1 Deskripsi & Alur Kerja
Halaman untuk menetapkan rasio tukar poin minyak jelantah (misalnya `1 Liter = 1 Poin` atau `1.5 Liter = 1 Poin`). Sistem menyimpan riwayat perubahan rate poin secara terurut kronologis dengan indikator badge "AKTIF" pada rate yang berlaku saat ini.

#### 8.2 Komponen UI & Layout
- **Header Bar**: Judul "Konfigurasi Rate Poin", Subtitle "Pengaturan rasio konversi liter minyak ke poin reward donatur".
- **Floating Action Button**: "+ Set Rate Baru" (`bg-[#006c49] text-white`).
- **Daftar Riwayat Rate (Card List)**:
  - Top Card (Rate Aktif): Highlighted green background (`#E6F9F0`), Icon Star Gold, Text `"1.00 Liter = 1 Poin"`, Date `"Berlaku sejak: 15 Agt 2026"`, Badge Pill `"AKTIF"`.
  - Historic Cards (Rate Lama): Muted white card, Icon Star Grey, Text `"1.50 Liter = 1 Poin"`, Date `"Berlaku: 01 Jan 2026 - 14 Agt 2026"`.
- **Dialog Set Rate Baru**:
  - Input: `Liter per 1 Poin` (Decimal number input, misal `1.00`).

#### 8.3 Integration Endpoint API
- `GET /api/konfigurasi-poin`
- `POST /api/konfigurasi-poin` (Payload: `{ "liter_per_poin": 1.00 }`)

#### 8.4 🎨 Prompt Desain Google Stitch (Page 8)
```text
A web configuration page for setting reward point exchange rates for an oil recycling app.
Header: Title 'Konfigurasi Rate Poin' with subtitle 'Rasio konversi liter jelantah ke poin reward'.
Floating Action Button: Bottom right or top header button '+ Set Rate Baru' in emerald green.
Rate History List:
- Card 1 (Active Current Rate): Soft green background (#E6F9F0), gold star icon, large bold text '1.00 Liter = 1 Poin', subtitle 'Berlaku sejak: 15 Agt 2026', and a green badge chip 'AKTIF'.
- Cards 2 & 3 (Historical Rates): White background cards, grey star icon, text '1.50 Liter = 1 Poin', muted date text.
Modal Dialog for setting new rate with a clean number input field 'Liter per 1 Poin' and Save button.
```

---

## 5. Ringkasan File & Lokasi Kode Web Admin

- **Login Admin**: [lib/admin/auth/login_page.dart](file:///d:/Semester%207/VibeProject/jelantah_app/lib/admin/auth/login_page.dart)
- **Dashboard Pengelola Container**: [lib/admin/pengelola/pages/dashboard_pengelola_page.dart](file:///d:/Semester%207/VibeProject/jelantah_app/lib/admin/pengelola/pages/dashboard_pengelola_page.dart)
- **Donasi Masuk Pengelola**: [lib/admin/pengelola/pages/donasi_masuk_page.dart](file:///d:/Semester%207/VibeProject/jelantah_app/lib/admin/pengelola/pages/donasi_masuk_page.dart)
- **Kelola Lokasi Pengelola**: [lib/admin/pengelola/pages/lokasi_kelola_page.dart](file:///d:/Semester%207/VibeProject/jelantah_app/lib/admin/pengelola/pages/lokasi_kelola_page.dart)
- **Dashboard Manajemen Container**: [lib/admin/manajemen/pages/dashboard_manajemen_page.dart](file:///d:/Semester%207/VibeProject/jelantah_app/lib/admin/manajemen/pages/dashboard_manajemen_page.dart)
- **Dashboard Agregat Content**: [lib/admin/manajemen/pages/dashboard_content_page.dart](file:///d:/Semester%207/VibeProject/jelantah_app/lib/admin/manajemen/pages/dashboard_content_page.dart)
- **Kelola Pengelola**: [lib/admin/manajemen/pages/kelola_pengelola_page.dart](file:///d:/Semester%207/VibeProject/jelantah_app/lib/admin/manajemen/pages/kelola_pengelola_page.dart)
- **Konfigurasi Rate Poin**: [lib/admin/manajemen/pages/konfigurasi_poin_page.dart](file:///d:/Semester%207/VibeProject/jelantah_app/lib/admin/manajemen/pages/konfigurasi_poin_page.dart)

---

*Dokumen ini dibuat secara otomatis untuk referensi pengembangan dan pembuatan prompt UI/UX Google Stitch.*
