import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import 'edit_product_screen.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsRef = FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Produk')),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final products = snapshot.data!.docs
              .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          if (products.isEmpty) {
            return const Center(child: Text('Belum ada produk.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(product.name),
                subtitle: Text('Rp ${product.price.toStringAsFixed(0)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProductScreen(product: product),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(product.id)
                            .delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Produk dihapus')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
