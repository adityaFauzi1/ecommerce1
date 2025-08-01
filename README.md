Nama : Aditya Fauzi
Npm : 2022804042
![image](<img width="1365" height="767" alt="login" src="https://github.com/user-attachments/assets/5d64e068-d8b7-4e1a-96b4-11f6f7d767d1" />
)
![image](<img width="1365" height="767" alt="tampilanproduk" src="https://github.com/user-attachments/assets/ede0874d-e17e-4bbd-9f93-5cb01030a954" />
)
![image](<img width="1362" height="764" alt="tampilantambahproduk" src="https://github.com/user-attachments/assets/ab7ac821-c54e-4829-a145-84eed12171d8" />
)
![image](<img width="1357" height="758" alt="firebase" src="https://github.com/user-attachments/assets/1f563db8-5d7b-4fdf-80ed-19a6ff47816d" />
)

  Aplikasi E-Commerce Flutter
  
  Deskripsi Singkat .
Aplikasi ini adalah sebuah platform e-commerce sederhana yang dibangun menggunakan Flutter. Pengguna dapat melakukan registrasi dan login untuk melihat berbagai produk, menambahkan produk ke keranjang, melakukan proses checkout, dan melihat riwayat pembelian. Aplikasi ini juga memiliki fitur untuk menambah, mengubah, dan menghapus produk.

  Teknologi yang Digunakan .
- *Shared Preferences*: Digunakan untuk menyimpan data sederhana seperti preferensi pengguna atau status login di perangkat secara lokal, meskipun dalam proyek ini fokus utamanya adalah Firebase.
- *Firebase Auth*: Mengelola seluruh proses otentikasi pengguna, termasuk pendaftaran (sign-up) dan masuk (sign-in) menggunakan email dan password.
- *Cloud Firestore*: Berperan sebagai database NoSQL utama untuk menyimpan data aplikasi secara real-time. Data yang disimpan meliputi:
    - products: Menyimpan semua detail produk yang dijual.
    - history: Mencatat riwayat setiap transaksi yang berhasil dilakukan oleh pengguna.
- *JSON Server*: Digunakan sebagai server lokal untuk simulasi API. Pada proyek ini, json-server menyediakan data dinamis untuk metode pembayaran dan pengiriman pada halaman checkout. URL yang digunakan adalah http://localhost:3000 (atau http://10.0.2.2:3000 untuk emulator Android).
- *Animasi: Menggunakan library **Lottie* untuk menampilkan animasi JSON pada halaman SuccessScreen setelah pengguna berhasil melakukan checkout, memberikan feedback visual yang menarik.

 Struktur Folder 
ecommerce1/
├── lib/
│   ├── models/
│   │   ├── cart_item.dart
│   │   ├── product_model.dart
│   │   └── user.dart
│   ├── screens/
│   │   ├── add_product_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── checkout_screen.dart
│   │   ├── edit_product_screen.dart
│   │   ├── history_screen.dart
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── product_detail_screen.dart
│   │   ├── register_screen.dart
│   │   └── success_screen.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── cart_service.dart
│   │   └── checkout_service.dart
│   ├── widgets/
│   │   └── product_card.dart
│   ├── firebase_options.dart
│   └── main.dart
├── assets/
│   ├── success.json
│   └── images/
├── pubspec.yaml
└── db.json
