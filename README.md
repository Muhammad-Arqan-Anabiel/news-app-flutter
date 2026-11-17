# News App Flutter — Proyek Lengkap (Pertemuan 1 - 5)

Aplikasi Berita (News App) berbasis Flutter yang dikembangkan berdasarkan modul pembelajaran mandiri SMK IDN (Pertemuan 1 hingga 5). Proyek ini mengintegrasikan pengambilan berita dari REST API (NewsAPI), manajemen kategori, pencarian kata kunci, penyaringan lokal (in-memory), navigasi halaman detail, penanganan error komprehensif, serta pengelolaan kredensial aman berbasis `.env` dan `flutter_dotenv`.

---

## 📁 Struktur Direktori Proyek

```
news_app/
├── .env                  # Berisi API key NewsAPI lokal (diabaikan oleh Git)
├── .env.example          # Template konfigurasi aman untuk GitHub
├── .gitignore            # Pengaturan pengabaian file sensitif
├── pubspec.yaml          # Konfigurasi dependensi dan assets (.env)
├── test/
│   ├── news_page_test.dart # Pengujian unit untuk logika filter lokal
│   └── widget_test.dart    # Pengujian unit untuk model Article & ArticleDetailPage
└── lib/
    ├── main.dart                 # Titik awal aplikasi & inisialisasi dotenv
    ├── models/
    │   └── article.dart          # Model data Article & deserialisasi JSON
    ├── services/
    │   └── news_service.dart     # Service komunikasi HTTP dengan NewsAPI
    └── pages/
        ├── news_page.dart        # Halaman utama (berita, kategori, cari, filter)
        └── article_detail_page.dart # Halaman detail artikel & buka browser asli
```

---

## 🚀 Fitur Unggulan Sesuai Kriteria Pertemuan 1 - 5

### 1. Pertemuan 1: Fondasi REST API & Model Berita
* Model `Article` dengan serialisasi JSON type-safe dan penanganan nilai null (`??`).
* `NewsService` untuk mengambil berita terkini via endpoint `/v2/top-headlines`.
* Tampilan daftar berita menggunakan `FutureBuilder` dan `ListView.builder`.
* Izin akses internet terkonfigurasi di `android/app/src/main/AndroidManifest.xml`.

### 2. Pertemuan 2: Kategori, Pencarian, & Filter Lokal
* **Filter API**:
  * Pilihan kategori berita via horizontal `ChoiceChip`: Umum, Bisnis, Hiburan, Kesehatan, Sains, Olahraga, Teknologi.
  * Pencarian berita global via endpoint `/v2/everything` menggunakan `TextField`.
* **Filter Lokal**:
  * Penyaringan instan berdasarkan judul berita di memori perangkat tanpa membebani kuota API.
  * Pencarian case-insensitive dan penanganan spasi (`trim()`).

### 3. Pertemuan 3: Navigasi & Halaman Detail Berita
* Navigasi mulus antar layar menggunakan `Navigator.push()` dan `Navigator.pop()`.
* Objek `Article` dikirimkan secara dinamis sesuai kartu berita yang diketuk.
* Tata letak responsif dengan `SingleChildScrollView` untuk mencegah *overflow*.
* Fitur pembuka artikel asli di web browser eksternal via package `url_launcher`.
* Fallback visual `errorBuilder` saat URL gambar bermasalah atau kosong.

### 4. Pertemuan 4: Error Handling & Ketahanan Sistem
* Menangani 4 status utama: **Loading**, **Success**, **Empty**, dan **Error**.
* Pesan kesalahan ramah pengguna untuk kode HTTP 401, 429, serta kegagalan jaringan (*no internet*).
* Tombol **Coba Lagi** (*Retry*) yang secara cerdas mengulang mode aktif (kategori atau pencarian).
* Mencegah request berulang (*infinite loop*) dengan mengelola state `Future` di `initState()`.

### 5. Pertemuan 5: Pengelolaan Kunci API & Keamanan Git
* Memisahkan API key dari file Dart menggunakan `flutter_dotenv`.
* File `.env` terdaftar pada `pubspec.yaml` dan diabaikan oleh `.gitignore`.
* Tersedia `.env.example` sebagai referensi aman tanpa membocorkan kunci rahasia ke GitHub.

---

## ⚙️ Panduan Menjalankan Aplikasi

1. **Clone repositori**:
   ```bash
   git clone <url-repo>
   cd "News App"
   ```

2. **Siapkan file `.env`**:
   Salin file `.env.example` menjadi `.env`:
   ```bash
   cp .env.example .env
   ```
   Buka file `.env` dan masukkan API key NewsAPI milikmu:
   ```env
   NEWS_API_KEY=masukkan_api_key_newsapi_kamu_di_sini
   ```

3. **Unduh dependensi**:
   ```bash
   flutter pub get
   ```

4. **Jalankan pengujian**:
   ```bash
   flutter test
   ```

5. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```
