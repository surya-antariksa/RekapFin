# SETUP-MANUAL.md: Panduan Penyiapan Rahasia & Lingkungan RekapFin

Dokumen ini disusun untuk **Pemilik Produk (Product Owner)**. Semua langkah di dokumen ini harus dijalankan secara manual oleh pemilik produk pada workstation pribadi yang aman.

> [!CAUTION]
> **ATURAN KEAMANAN MUTLAK:**
> 1. **JANGAN PERNAH** memasukkan file keystore (`*.jks`, `*.keystore`), `key.properties`, file `.env*`, atau kunci rahasia apa pun ke dalam repositori Git atau Google Drive yang dibagikan.
> 2. Klien Flutter hanya boleh memegang `SUPABASE_URL` dan `anon key` (via `--dart-define`). Kunci API pihak ketiga (LLM/Gemini/Claude) **HANYA** disimpan sebagai secret pada Supabase Edge Function.

---

## 1. Pembuatan Keystore Penandatanganan Android & Pencadangan

Keystore penandatanganan diperlukan untuk menghasilkan APK rilis bertanda tangan yang konsisten (agar pembaruan aplikasi dapat menimpa instalasi lama tanpa error tanda tangan).

### 1.1 Perintah Pembuatan Keystore (Jalankan Mandiri)
Jalankan perintah ini di luar direktori repositori:

```bash
keytool -genkey -v -keystore rekapfin-release.jks \
  -alias rekapfin-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```
- Anda akan diminta memasukkan kata sandi (password) keystore, nama, organisasi, dan detail lokasi.
- Catat kata sandi dan simpan di pengelola kata sandi (Password Manager) yang aman.

### 1.2 Prosedur Pencadangan (Backup) Wajib 2 Salinan Terpisah
1. **Salinan Terenkripsi 1 (Offline Fisik):**
   - Enkripsi file `rekapfin-release.jks` menggunakan alat terenkripsi (mis. `gpg -c rekapfin-release.jks` atau 7-Zip AES-256).
   - Simpan pada flashdisk/SSD eksternal khusus yang disimpan di brankas/lokasi fisik offline aman.
2. **Salinan Terenkripsi 2 (Cloud Pribadi Non-Publik):**
   - Simpan salinan terenkripsi lainnya pada penyimpanan cloud pribadi terisolasi (mis. akun cloud backup pribadi dengan 2FA fisik, **bukan** Drive bersama).

---

## 2. Penyiapan Tiga Proyek Supabase (Dev, Staging, Prod)

Sesuai arsitektur RekapFin (docs/07), aplikasi menggunakan tiga lingkungan yang sepenuhnya terisolasi:

1. **Dev (Lokal / Cloud Dev):** Digunakan untuk pengembangan harian dan uji coba fungsi baru.
2. **Staging:** Digunakan untuk verifikasi pra-rilis dan demo data sintetis.
3. **Prod:** Lingkungan pengguna nyata dengan penagihan aktif (kuota berbayar untuk LLM/Google AI, tanpa kuota gratis).

### 2.1 Langkah Pembuatan Proyek
1. Buka [Supabase Dashboard](https://supabase.com/dashboard).
2. Buat proyek baru untuk masing-masing lingkungan:
   - Proyek 1: `rekapfin-dev`
   - Proyek 2: `rekapfin-staging`
   - Proyek 3: `rekapfin-prod`
3. Ambil URL dan API Key masing-masing di menu **Project Settings -> API**:
   - `Project URL`
   - `anon / public key` (atau `publishable key`)
4. Jalankan aplikasi Flutter dengan flavor terkait menggunakan `--dart-define`:
   ```bash
   # Contoh menjalankan dev
   flutter run -t lib/main_dev.dart --flavor dev \
     --dart-define=SUPABASE_URL=https://<dev-ref>.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=<dev-anon-key>
   ```

---

## 3. Pendaftaran SHA-1 Keystore pada Google Cloud Console (OAuth)

Agar fitur **Google Sign-In** berfungsi pada build debug maupun release:

### 3.1 Dapatkan Sidik Jari SHA-1 Keystore
1. **Untuk Debug Keystore:**
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
2. **Untuk Release Keystore:**
   ```bash
   keytool -list -v -keystore /path/to/rekapfin-release.jks -alias rekapfin-key
   ```
3. Salin nilai hex `SHA-1` dari output (mis. `AA:BB:CC:...`).

### 3.2 Daftarkan di Google Cloud Console
1. Buka [Google Cloud Console - Credentials](https://console.cloud.google.com/apis/credentials).
2. Pilih proyek Google Cloud yang tertaut dengan Supabase Auth Anda.
3. Buat atau edit **OAuth 2.0 Client ID**:
   - Application type: **Android**
   - Package name: Sesuai applicationId (`com.rekapfin` atau `com.rekapfin.dev`)
   - SHA-1 certificate fingerprint: Tempelkan SHA-1 dari langkah 3.1.
4. Buat 2 entri klien Android terpisah bila menggunakan suffix flavor (`.dev` dan produksi).
5. Masukkan Web Client ID Google ke konfigurasi Supabase Authentication Provider (Google).

---

## 4. Penyimpanan Kunci API LLM / Claude / Gemini sebagai Edge Function Secret

Kunci API pihak ketiga untuk pemrosesan OCR dan Chatbot (Google AI Gemini / Anthropic Claude) **TIDAK BOLEH** disimpan di aplikasi Flutter.

### 4.1 Langkah Menyimpan Secret via Supabase CLI
Gunakan Supabase CLI yang terhubung ke proyek:
```bash
# Untuk proyek lokal
supabase secrets set GEMINI_API_KEY="kunci_rahasia_anda_disini"
supabase secrets set CLAUDE_API_KEY="kunci_rahasia_anda_disini"

# Untuk proyek hosted (staging / prod)
supabase secrets set --project-ref <project-id> GEMINI_API_KEY="kunci_rahasia_anda_disini"
```

### 4.2 Langkah Menyimpan Secret via Dashboard
1. Buka dashboard proyek Supabase.
2. Masuk ke **Edge Functions -> Secrets**.
3. Tambahkan secret baru:
   - Nama: `GEMINI_API_KEY` (dan/atau `CLAUDE_API_KEY`)
   - Nilai: `<API_KEY_RAHASIA>`
4. Simpan. Kunci ini hanya akan dapat diakses oleh runtime Deno pada Edge Function di server.
