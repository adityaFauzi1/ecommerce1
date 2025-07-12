// lib/screens/add_product_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart'; // Impor service produk Anda

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form
  final _nameController = TextEditingController(); // Controller untuk input nama produk
  final _priceController = TextEditingController(); // Controller untuk input harga
  final _imageUrlController = TextEditingController(); // Controller untuk input URL gambar

  final ProductService _productService = ProductService(); // Instansi dari service produk kita

  @override
  void dispose() {
    // Penting untuk membuang controller saat widget tidak lagi digunakan untuk menghindari kebocoran memori
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) { // Memeriksa apakah semua input form valid
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch, // Menggunakan timestamp sebagai ID sementara. Firestore akan memberikan ID unik sendiri.
        name: _nameController.text, // Mengambil nama dari input teks
        price: int.parse(_priceController.text), // Mengambil harga dari input teks dan mengubahnya menjadi integer
        imageUrl: _imageUrlController.text, // Mengambil URL gambar dari input teks
      );

      try {
        await _productService.addProduct(newProduct); // Memanggil fungsi untuk menambahkan produk ke Firebase
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk berhasil ditambahkan!')), // Menampilkan pesan sukses
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya (HomeScreen)
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan produk: $e')), // Menampilkan pesan error jika gagal
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk Baru'), // Judul AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Memberi sedikit jarak di sekitar form
        child: Form(
          key: _formKey, // Menghubungkan form dengan kunci validasi
          child: ListView( // Menggunakan ListView agar form bisa di-scroll jika isinya banyak
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Produk'), // Label untuk input nama
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong'; // Validasi: nama tidak boleh kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Jarak antar input
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Harga'), // Label untuk input harga
                keyboardType: TextInputType.number, // Mengatur keyboard agar hanya menampilkan angka
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong'; // Validasi: harga tidak boleh kosong
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus angka'; // Validasi: harga harus berupa angka
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL Gambar'), // Label untuk input URL gambar
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL Gambar tidak boleh kosong'; // Validasi: URL gambar tidak boleh kosong
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _saveProduct, // Memanggil fungsi _saveProduct saat tombol ditekan
                child: Text('Simpan Produk'), // Teks pada tombol
              ),
            ],
          ),
        ),
      ),
    );
  }
}