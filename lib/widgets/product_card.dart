import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../screens/product_detail_screen.dart'; // ✅ pastikan ini diimport

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      onTap: () {
        // ✅ FIX: ganti DetailScreen -> ProductDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Rp ${product.price.toStringAsFixed(0)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
