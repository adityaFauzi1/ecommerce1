import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import 'add_product_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final productsRef = FirebaseFirestore.instance.collection('products');
  String searchQuery = "";
  String? selectedCategory; // ✅ dropdown value
  final List<String> categories = [
    'Semua Kategori',
    'Makanan',
    'Minuman',
    'Fashion',
    'Elektronik',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen()));
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Filter Kategori',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: productsRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var products = snapshot.data!.docs
                    .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>, doc.id))
                    .where((product) {
                  final matchesSearch = product.name.toLowerCase().contains(searchQuery);
                  final matchesCategory = selectedCategory == null ||
                      selectedCategory == 'Semua Kategori' ||
                      product.category == selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (products.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada produk', style: TextStyle(color: Colors.white)),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(product.imageUrl, fit: BoxFit.cover),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.white)),
                                  Text('Rp ${product.price.toStringAsFixed(0)}',
                                      style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
