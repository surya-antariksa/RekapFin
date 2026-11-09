# 04. Alur Pengguna

> Ringkasan: alur utama dalam diagram Mermaid: onboarding/login, catat transaksi, transfer, scan nota, hutang-piutang dan saling hapus, scan investasi, dan chatbot, plus peta navigasi keseluruhan. Karena desain tidak memuat interaksi, semua panah adalah [ASUMSI] yang diturunkan dari tombol, teks di layar, dan keputusan pemilik produk. Layar baru (Onboarding, Lupa Kata Sandi, Dompet, Transfer, Detail Transaksi, Atur Anggaran, Pengaturan) ditandai di diagram.

Status: Diperbarui setelah keputusan OI-01 sampai OI-25. Nama layar dan route sama dengan [03-inventaris-layar.md](03-inventaris-layar.md). Diagram belum divalidasi render.

## 1. Peta navigasi
```mermaid
flowchart TD
  login["Masuk (/login)"] --> home
  login --> forgot["Lupa Kata Sandi (/forgot-password) BARU"]
  login --> signup["Daftar (/signup)"]
  signup --> onb["Onboarding Saldo Awal (/onboarding) BARU"]
  onb --> home
  subgraph tabs["Tab bawah"]
    home["Beranda (/home)"]
    trx["Transaksi (/transactions)"]
    bgt["Anggaran (/budget)"]
    anl["Analitik (/analytics)"]
    prf["Profil (/profile)"]
  end
  home --> trx
  home --> addtrx[["Sheet Tambah Transaksi"]]
  home --> xfer["Transfer (/transfer) BARU"]
  home --> wal["Dompet (/wallets) BARU"]
  xfer -- "Ke: Investasi" --> addinv
  xfer -- "ke dompet lain" --> home
  trx --> tdet["Detail Transaksi (/transaction-detail) BARU"]
  home --> tdet
  bgt --> bedit["Atur Anggaran (/budget-edit) BARU"]
  home --> scan["Scan Nota (/scan)"]
  home --> debts["Hutang & Piutang (/debts)"]
  home --> inv["Investasi (/investments)"]
  prf --> edit["Edit Profil (/edit-profile)"]
  prf --> wal
  prf --> set["Pengaturan (/settings) BARU"]
  prf --> debts
  prf --> inv
  prf --> login
  home -.-> ai["Asisten RekapFin (/chat)"]
  trx -.-> ai
  bgt -.-> ai
  anl -.-> ai
  prf -.-> ai
  debts --> ddetail["Detail (/debt-detail)"]
  ddetail --> dpay[["Catat Pembayaran (/debt-payment)"]]
  ddetail --> dnet["Saldo Bersih (/debt-net)"]
  dnet --> doff[["Konfirmasi Saling Hapus (/debt-offset)"]]
  inv --> idetail["Detail Aset (/investment-detail)"]
  inv --> addinv[["Tambah Investasi (/add-investment)"]]
  inv --> sinv["Scan Investasi (/scan-investment)"]
```
Garis putus-putus: tombol melayang Tanya AI di semua layar bernav. Kotak ganda: sheet. Notifikasi dan Riwayat Saling Hapus ditunda dan tidak digambar.

## 2. Onboarding dan login
```mermaid
flowchart TD
  A([Buka aplikasi]) --> B{Ada sesi tersimpan?}
  B -- tidak --> C["Masuk (/login)"]
  B -- ya --> F{"Face ID diaktifkan di Pengaturan?"}
  F -- ya --> G[Verifikasi Face ID]
  F -- tidak --> H["Beranda (/home)"]
  G -- lolos --> H
  G -- gagal --> C
  C --> D{Aksi}
  D -- email + kata sandi --> E{Valid?}
  E -- ya --> H
  E -- tidak --> E2["Masuk - Error: Email atau kata sandi salah"] --> C
  D -- Google --> H
  D -- Daftar --> S["Daftar (/signup)"]
  S --> S2{Form valid dan syarat dicentang?}
  S2 -- ya --> O["Onboarding Saldo Awal (/onboarding)"]
  S2 -- tidak --> S
  O -- "isi nominal + Lanjut" --> H
  O -- Lewati --> H
  D -- Lupa kata sandi --> R["Lupa Kata Sandi (/forgot-password)"]
  R -- "Kirim Tautan Reset" --> R2[State terkirim] --> C
```
Catatan: saat permintaan berjalan tampil varian Masuk - Loading ("Memproses..."). Onboarding mengisi saldo awal Saldo Utama; dilewati berarti Rp 0 dan dapat diubah di Dompet (OI-08). Tombol "Masuk dengan Face ID" hanya relevan bila Face ID diaktifkan (OI-25).

## 3. Catat transaksi manual
```mermaid
flowchart TD
  A["Beranda: Tambah Pengeluaran/Pemasukan"] --> B[["Sheet Tambah Transaksi"]]
  B --> C{Tab}
  C -- Pengeluaran --> D[Isi nominal lewat keypad]
  C -- Pemasukan --> D
  D --> E["Pilih kategori (8 kategori, tanpa Investasi di Pengeluaran)"]
  E --> W["Pilih Dompet (bawaan Saldo Utama)"]
  W --> F[Tanggal dan catatan]
  F --> G{Nominal > 0 dan kategori terpilih?}
  G -- tidak --> D
  G -- ya --> H["Simpan Transaksi"]
  H --> J["Transaksi tersimpan, saldo dompet dan daftar diperbarui"]
  B -- "Scan nota untuk isi otomatis" --> K["Scan Nota (/scan)"]
```
Kategori "Investasi" sudah dihapus dari tab Pengeluaran (OI-06). Investasi dicatat lewat Transfer atau layar Investasi.

### 3.1 Transfer
```mermaid
flowchart TD
  A["Beranda: Transfer"] --> B["Transfer (/transfer)"]
  B --> C{Tujuan}
  C -- "Dompet lain" --> D[Pilih dompet asal dan tujuan, nominal, tanggal]
  D --> V{Asal berbeda dari tujuan dan nominal > 0?}
  V -- tidak --> D
  V -- ya --> S["Simpan Transfer: satu transaksi transfer, Total Saldo tetap"]
  C -- Investasi --> I["Tambah Investasi (/add-investment), nominal dan sumber dana terbawa"]
  I --> T["Simpan: transfer source=investment dari dompet terpilih, Total Saldo turun"]
```

## 4. Scan nota
```mermaid
flowchart TD
  A["Scan Nota (/scan), segmen Nota"] --> B[Ambil foto atau pilih galeri]
  A -- "Ketik Manual" --> M[["Sheet Tambah Transaksi"]]
  A -- "Segmen Investasi" --> SI["Scan Investasi (/scan-investment)"]
  B --> C["Memproses: Mendeteksi teks → Mengenali item → Menentukan kategori"]
  C --> D[OCR on-device ML Kit]
  D --> E[Edge Function: LLM merapikan teks menjadi JSON + skor keyakinan]
  E --> V{Validasi: item = subtotal dan subtotal + pajak = total?}
  V -- ya --> R["Hasil Scan (/scan-result), field di bawah 85% amber"]
  V -- tidak --> F[Fallback vision Google AI, satu kali]
  F --> V2{Validasi ulang}
  V2 -- ya --> R
  V2 -- tidak --> R2["Hasil Scan dengan total amber Periksa kembali, atau Ketik Manual"]
  R --> X{Aksi}
  R2 --> X
  X -- "Simpan Transaksi" --> S["Buat transaksi expense + item; gambar dihapus kecuali Simpan foto nota aktif di Pengaturan"]
  X -- "Foto Ulang / Scan Nota Lain" --> A
```

## 5. Hutang-piutang dan saling hapus
```mermaid
flowchart TD
  A["Hutang & Piutang (/debts)"] --> B{Pilih}
  B -- "Tambah Hutang/Piutang" --> C[["Sheet Tambah"]]
  C --> K{"Nama dipilih dari contacts atau diketik?"}
  K -- diketik, nama sudah ada --> K2[["Dialog: Pakai kontak ini / Buat kontak baru"]]
  K2 --> C2
  K -- dipilih atau nama baru --> C2
  C2{"Kontak punya catatan lawan?"}
  C2 -- ya --> C3["Tampil pesan timbal balik: Kamu punya piutang Rp X ke nama"]
  C2 -- tidak --> C4["Simpan (bila Catat ke saldo aktif: transaksi source=debt pada dompet terpilih)"]
  C3 --> C4
  B -- "Tap orang" --> D["Detail (/debt-detail)"]
  D --> E{Aksi}
  E -- "Catat Pembayaran / Bayar Cicilan" --> P[["Catat Pembayaran (/debt-payment)"]]
  P --> P2{"Catat ke transaksi aktif?"}
  P2 -- ya --> P3["Buat transaksi source=debt_payment: piutang dibayar = pemasukan, bayar hutang = pengeluaran, di luar Analitik"]
  P2 -- tidak --> P4[Hanya perbarui sisa]
  P3 --> D
  P4 --> D
  E -- "Lihat & Saling Hapus" --> N["Saldo Bersih (/debt-net)"]
  A -- "Banner Saldo bersih" --> N
  N --> N1{Hasil}
  N1 -- "Dia berhutang" --> O
  N1 -- "Kamu berhutang" --> O
  N1 -- Impas --> O
  O[["Konfirmasi Saling Hapus (/debt-offset)"]] -- Konfirmasi --> OK["Berhasil: sisa kedua sisi dikurangi min(piutang, hutang) dengan FIFO jatuh tempo terdekat, tanpa transaksi, riwayat dicatat"]
  O -- Batal --> N
  OK -- Selesai --> A
```
Ditunda: "Lihat Riwayat" (layar Riwayat Saling Hapus) dan "Kirim Pengingat" via WhatsApp. Pengingat jatuh tempo berupa notifikasi lokal H-3 dan hari-H (OI-22).

## 6. Scan investasi
```mermaid
flowchart TD
  A["Investasi (/investments)"] -- "Scan Screenshot" --> B["Scan Investasi (/scan-investment)"]
  A -- "Tambah Manual" --> M[["Tambah Investasi (/add-investment)"]]
  M -- "Isi dari screenshot" --> B
  X["Transfer (/transfer), tujuan Investasi"] --> M
  S["Scan Nota segmen Investasi"] --> B
  B --> C[Pilih screenshot dan platform opsional]
  C --> D["Scan Investasi - Terpilih"]
  D -- "Baca Screenshot" --> E["Memproses: Mendeteksi platform → Membaca nominal dan unit → Mencocokkan aset"]
  E --> F[OCR on-device + Edge Function + validasi]
  F --> G["Hasil Scan Investasi (/scan-investment-result)"]
  G --> H{"Jenis"}
  H -- Reksa dana --> G1[Nominal, unit, harga per unit]
  H -- Emas --> G2[Berat, harga per gram, total]
  G1 --> I
  G2 --> I
  I["Simpan ke Portofolio: transfer source=investment dari dompet Sumber dana, bukan pengeluaran"] --> A
```

## 7. Chatbot
```mermaid
sequenceDiagram
  actor U as Pengguna
  participant App as Aplikasi
  participant EF as Edge Function chat
  participant DB as Supabase (RLS)
  U->>App: "Catat makan siang 45rb di Warteg"
  App->>EF: pesan + JWT pengguna
  EF->>EF: cek batas pemakaian
  EF->>DB: baca konteks lewat RPC (JWT pengguna)
  EF-->>App: jawaban teks dan usulan aksi (pending_action)
  App->>U: Kartu Konfirmasi transaksi (Simpan / Ubah)
  alt Simpan
    U->>App: Simpan
    App->>DB: confirm_pending_action_v1 dengan client_request_id
    DB-->>App: transaksi dibuat
  else Ubah
    U->>App: Ubah
    App->>U: Buka form Tambah Transaksi terisi
  end
```
Aturan: chatbot tidak pernah menulis langsung; hanya `confirm_pending_action_v1` dari klien yang menulis (BR-17).
