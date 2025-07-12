import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];
    setState(() {
      cartItems = cart.map((item) => Product.fromJson(json.decode(item))).toList();
    });
  }

  void checkout() async {
    int total = cartItems.fold(0, (sum, item) => sum + item.price);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Pembayaran"),
        content: Text("Total yang harus dibayar: Rp $total"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Simulasi pembayaran berhasil
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('cart');
              setState(() {
                cartItems.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Pembayaran berhasil")),
              );
            },
            child: Text("Bayar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Keranjang kosong'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, i) => ListTile(
                leading: Image.network(cartItems[i].imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(cartItems[i].name),
                subtitle: Text('Rp ${cartItems[i].price}'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: checkout,
              child: Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
