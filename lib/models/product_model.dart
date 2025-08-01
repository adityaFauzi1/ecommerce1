class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  // 🔄 Konversi dari Firestore ke Product
  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
      id: id,
      name: json['name'] ?? '',
      price: _convertToDouble(json['price']), // ✅ Perbaikan di sini
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'Lainnya',
    );
  }

  // 🔄 Konversi ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  // ✅ Helper untuk menghindari error "String is not a subtype of double"
  static double _convertToDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
