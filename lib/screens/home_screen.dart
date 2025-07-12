import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import '../widgets/product_card.dart';
import 'add_product_screen.dart'; // Pastikan impor ini benar
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];

  void loadProducts() async {
    final service = ProductService();
    // Ini sekarang akan mengambil data dari Firestore
    final data = await service.fetchProducts(); // Memuat produk menggunakan ProductService
    setState(() => products = data); // Memperbarui daftar produk di UI
  }

  void addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];
    cart.add(json.encode(product.toJson()));
    prefs.setStringList('cart', cart);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ditambahkan ke keranjang')),
    );
  }

  @override
  void initState() {
    super.initState();
    loadProducts(); // Memuat produk saat halaman pertama kali dibuka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Tambah Produk',
            onPressed: () async {
              // Navigasi ke halaman tambah produk, lalu refresh produk setelah kembali
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddProductScreen()), // Navigasi ke AddProductScreen
              );
              loadProducts(); // Memuat ulang produk setelah kembali dari AddProductScreen
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator()) // Menampilkan indikator loading jika produk kosong
          : ListView.builder(
        itemCount: products.length, // Jumlah produk yang akan ditampilkan
        itemBuilder: (_, i) => ProductCard(
          product: products[i], // Menampilkan kartu produk
          onAdd: () => addToCart(products[i]), // Fungsi saat tombol tambah ke keranjang ditekan
        ),
      ),
    );
  }
}