import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final cartService = CartService();

  // ✅ Variabel untuk simpan menu tambahan
  String? selectedLevel;
  List<String> selectedToppings = [];
  String? selectedDrink;

  // ✅ Daftar menu tambahan khusus makanan
  final List<String> levels = ['Tidak Pedas', 'Sedang', 'Sangat Pedas'];
  final List<String> toppings = ['Keju', 'Telur', 'Bakso', 'Sosis'];
  final List<String> drinks = ['Es Teh', 'Es Jeruk', 'Air Putih', 'Soda'];

  void _addToCart() {
    if (widget.product.category.toLowerCase() == 'makanan') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView( // ✅ supaya bisa scroll kalau konten panjang
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Pilih Level Pedas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ...levels.map((level) => RadioListTile(
                        title: Text(level),
                        value: level,
                        groupValue: selectedLevel,
                        onChanged: (value) {
                          setModalState(() => selectedLevel = value);
                        },
                      )),
                      const Divider(),
                      const Text('Pilih Topping', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ...toppings.map((top) => CheckboxListTile(
                        title: Text(top),
                        value: selectedToppings.contains(top),
                        onChanged: (bool? checked) {
                          setModalState(() {
                            if (checked == true) {
                              selectedToppings.add(top);
                            } else {
                              selectedToppings.remove(top);
                            }
                          });
                        },
                      )),
                      const Divider(),
                      const Text('Pilih Minuman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ...drinks.map((drink) => RadioListTile(
                        title: Text(drink),
                        value: drink,
                        groupValue: selectedDrink,
                        onChanged: (value) {
                          setModalState(() => selectedDrink = value);
                        },
                      )),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Navigator.pop(context);

                          // ✅ Tambahkan produk ke keranjang dengan informasi tambahan
                          cartService.addToCart(widget.product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Produk ditambahkan ke keranjang\n'
                                      'Level: ${selectedLevel ?? "-"}\n'
                                      'Topping: ${selectedToppings.isNotEmpty ? selectedToppings.join(", ") : "-"}\n'
                                      'Minuman: ${selectedDrink ?? "-"}'
                              ),
                            ),
                          );
                        },
                        child: const Text('Tambahkan ke Keranjang'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      // ✅ Kalau bukan makanan, langsung tambahkan
      cartService.addToCart(widget.product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk ditambahkan ke keranjang')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.product.imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Rp ${widget.product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _addToCart,
                  label: const Text('Tambah ke Keranjang'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
