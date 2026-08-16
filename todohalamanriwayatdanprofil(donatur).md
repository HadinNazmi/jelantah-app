# Todo: Halaman Riwayat & Profil (Donatur)

Lanjutan dari fitur yang sudah selesai (login, home, ajukan donasi). Dua halaman ini masih placeholder kosong, perlu diisi fungsinya.

## Catatan penting sebelum mulai
Backend BELUM punya endpoint untuk donatur mengedit profilnya sendiri — endpoint ini perlu dibuat dulu di Laravel sebelum bagian "edit profil" di Flutter bisa berfungsi. Detail di bagian "Kebutuhan Backend Baru" di bawah.

---

## 1. Halaman Riwayat (`lib/donatur/pages/riwayat_page.dart`)

### Fungsi
- Menampilkan daftar semua donasi milik donatur yang sedang login, diambil dari endpoint `GET /donasi` (sudah ada dan sudah teruji di backend — `DonasiController@myDonasi`)
- Setiap item riwayat menampilkan: nama lokasi, tanggal pengajuan (`created_at`), jumlah input, jumlah terverifikasi (kalau sudah ada), status (pending/verifikasi/selesai), dan poin yang didapat (kalau status sudah selesai)
- Status ditampilkan dengan pembeda visual (misal warna beda per status: kuning=pending, biru=verifikasi, hijau=selesai)
- Tap salah satu item riwayat bisa membuka detail donasi tersebut (opsional untuk versi awal — bisa ditampilkan langsung di list saja dulu tanpa halaman detail terpisah)
- Pull-to-refresh untuk memuat ulang data terbaru

### Yang perlu dibuat di Flutter
- Model `DonasiModel` — SUDAH ADA (dibuat saat fitur ajukan donasi), pastikan field-nya lengkap (id, jumlah_input, jumlah_terverifikasi, foto_bukti, status, poin_diperoleh, created_at) — perlu ditambah field `lokasi` (nested object berisi nama lokasi, karena endpoint riwayat menyertakan relasi lokasi)
- `DonasiApi.getMyDonasi()` — SUDAH ADA, tinggal dipakai
- Isi `RiwayatPage` sebagai StatefulWidget yang manggil `DonasiApi.getMyDonasi()` di `initState()`, tampilkan dalam `ListView`

---

## 2. Halaman Profil (`lib/donatur/pages/profil_page.dart`)

### Fungsi yang sudah bisa langsung dibuat (data yang bisa DILIHAT)
- Menampilkan data dari `GET /me` (sudah ada): nama, email, nomor HP
- Menampilkan ringkasan dari `GET /dompet` (sudah ada): total kontribusi, total poin
- Tombol Logout (sudah ada di versi placeholder sebelumnya, tinggal dipertahankan)

### Data yang BISA diubah donatur (dan strukturnya di database)
Berdasarkan skema database, data yang secara masuk akal boleh diedit donatur sendiri:

| Field | Tabel | Catatan |
|---|---|---|
| `name` | `users` | Nama tampilan |
| `phone` | `users` | Nomor HP |
| `alamat` | `data_masyarakat` | Alamat tempat tinggal |
| `nomor_ktp` | `data_masyarakat` | Nomor KTP (opsional, nullable) |
| `password` | `users` | Ganti password — sebaiknya form terpisah, minta password lama + baru |

Data yang SEBAIKNYA TIDAK bisa diubah bebas oleh donatur:
- `email` — karena dipakai untuk login dan sudah terverifikasi; kalau mau boleh diubah, perlu alur verifikasi ulang (skip dulu untuk versi awal, cukup ditampilkan read-only)
- `role` — jangan pernah bisa diubah dari sisi user

### Yang perlu dibuat di Flutter
- `UserModel` — SUDAH ADA, cukup dipakai untuk tampilkan data
- Buat halaman/form edit profil terpisah (misal `edit_profil_page.dart`), dengan field name, phone, alamat, nomor_ktp — pre-filled dari data yang sudah ada
- Buat method baru di `AuthApi` atau file API baru `profil_api.dart` untuk memanggil endpoint update (lihat bagian Backend di bawah)
- Form ganti password terpisah (opsional untuk versi awal, bisa dikerjakan belakangan)

---

## Kebutuhan Backend Baru (Laravel) — WAJIB dibuat dulu

Belum ada endpoint untuk donatur mengedit profilnya sendiri. Perlu ditambahkan:

### 1. Endpoint update profil
Tambahkan method baru di `AuthController` (atau buat `ProfilController` terpisah kalau mau lebih rapi):

```php
public function updateProfile(Request $request)
{
    $user = $request->user();

    $validator = Validator::make($request->all(), [
        'name' => 'sometimes|string|max:255',
        'phone' => 'nullable|string|max:20',
        'alamat' => 'nullable|string',
        'nomor_ktp' => 'nullable|string|max:20',
    ]);

    if ($validator->fails()) {
        return response()->json(['errors' => $validator->errors()], 422);
    }

    $user->update($request->only(['name', 'phone']));

    $user->dataMasyarakat()->updateOrCreate(
        ['user_id' => $user->id],
        $request->only(['alamat', 'nomor_ktp'])
    );

    return response()->json(['message' => 'Profil berhasil diperbarui', 'user' => $user]);
}
```

Tambahkan route di `routes/api.php` (di dalam grup `role:donatur`):
```php
Route::put('/profile', [AuthController::class, 'updateProfile']);
```

### 2. Endpoint ganti password (opsional, bisa menyusul)
```php
public function changePassword(Request $request)
{
    $validator = Validator::make($request->all(), [
        'current_password' => 'required',
        'new_password' => 'required|min:8|confirmed',
    ]);

    if ($validator->fails()) {
        return response()->json(['errors' => $validator->errors()], 422);
    }

    $user = $request->user();

    if (! Hash::check($request->current_password, $user->password)) {
        return response()->json(['message' => 'Password lama salah'], 422);
    }

    $user->update(['password' => Hash::make($request->new_password)]);

    return response()->json(['message' => 'Password berhasil diubah']);
}
```
Route: `Route::put('/profile/password', [AuthController::class, 'changePassword']);`

### 3. Endpoint GET /me perlu disertakan data_masyarakat
Endpoint `GET /me` yang sudah ada saat ini hanya mengembalikan data dari tabel `users`. Untuk menampilkan alamat dan nomor_ktp di halaman profil, endpoint ini perlu di-update agar menyertakan relasi:
```php
public function me(Request $request)
{
    return response()->json($request->user()->load('dataMasyarakat'));
}
```

---

## Urutan pengerjaan yang disarankan
1. Backend dulu: tambahkan `updateProfile`, update `me` agar load relasi `dataMasyarakat`, uji lewat Postman
2. Flutter: isi `RiwayatPage` (tidak butuh backend baru, endpoint sudah ada)
3. Flutter: isi `ProfilPage` bagian tampilan (pakai data dari `me` yang sudah diperbarui)
4. Flutter: buat halaman edit profil, hubungkan ke endpoint `PUT /profile`
5. (Opsional) fitur ganti password, backend + Flutter