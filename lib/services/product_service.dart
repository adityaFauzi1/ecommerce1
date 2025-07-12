import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart'; // Impor Firestore
import '../models/product.dart';

class ProductService {
  // URL dasar mock API asli (tetap di sini jika masih digunakan untuk fetchProducts)
  final String baseUrl = 'https://684d263165ed087139153a23.mockapi.io/api/v1';

  // Instansi Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    // Sekarang akan mengambil dari Firestore, bukan dari mock API
    try {
      final QuerySnapshot snapshot = await _firestore.collection('products').get(); // Mengambil data dari koleksi 'products'
      return snapshot.docs.map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>)).toList(); // Mengubah data dokumen menjadi objek Product
    } catch (e) {
      throw Exception("Gagal memuat produk dari Firebase: $e"); // Menangani kesalahan jika gagal memuat
    }
  }

  // Metode baru untuk menambahkan produk ke Firestore
  Future<void> addProduct(Product product) async {
    try {
      // Tambahkan dokumen baru dengan ID yang dihasilkan secara otomatis oleh Firestore
      await _firestore.collection('products').add(product.toJson());
    } catch (e) {
      throw Exception("Gagal menambahkan produk ke Firebase: $e"); // Menangani kesalahan jika gagal menambahkan
    }
  }
}