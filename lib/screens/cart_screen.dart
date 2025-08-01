import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cart_service.dart';
import 'checkout_screen.dart'; // Ganti import ke checkout_screen.dart
import 'success_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartService = CartService();

  // Fungsi checkout sekarang hanya bernavigasi
  void _proceedToCheckout() {
    if (cartService.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang Anda kosong!')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = cartService.cart;

    // Hitung total belanja
    double total = cart.fold(0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: cart.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  leading: Image.network(item.product.imageUrl, width: 50, height: 50),
                  title: Text(item.product.name),
                  subtitle: Text(
                    'Rp ${item.product.price.toStringAsFixed(0)} x ${item.quantity}\n'
                        '${item.extras != null ? "Tambahan: ${item.extras!['level']}, ${item.extras!['toppings'].join(', ')}, ${item.extras!['drink']}" : ""}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() => cartService.decreaseQuantity(item.product));
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() => cartService.increaseQuantity(item.product));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Tampilan total dan tombol checkout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Rp ${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _proceedToCheckout, // Panggil fungsi ini
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Checkout', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}