import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();

  String? selectedCategory; // ✅ null di awal
  final List<String> categories = [
    'Makanan',
    'Minuman',
    'Fashion',
    'Elektronik',
    'Lainnya',
  ];

  void _addProduct() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final imageUrl = _imageController.text.trim();

    if (name.isEmpty || price <= 0 || imageUrl.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': selectedCategory,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil ditambahkan')),
    );

    _nameController.clear();
    _priceController.clear();
    _imageController.clear();
    setState(() {
      selectedCategory = null; // reset dropdown
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tambah Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔵 NAMA PRODUK
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // 🔵 HARGA PRODUK
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Harga Produk',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // 🔵 URL GAMBAR PRODUK
              TextField(
                controller: _imageController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'URL Gambar Produk',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // 🔵 DROPDOWN KATEGORI
              DropdownButtonFormField<String>(
                value: selectedCategory,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Pilih Kategori',
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

              const SizedBox(height: 20),

              // 🔵 BUTTON TAMBAH PRODUK
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _addProduct,
                child: const Text('Tambah Produk', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
