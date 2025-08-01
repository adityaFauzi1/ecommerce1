class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  // Ambil data dari Firestore, ID diambil dari doc.id
  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      name: json['name'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0.0),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  // Kirim data ke Firestore (tanpa menyimpan id, karena dibuat otomatis)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
