
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ProductModel.fromMap(Map<String, dynamic> m, String id) {
    return ProductModel(
      id: id,
      name: (m['name'] ?? '') as String,
      price: (m['price'] ?? 0).toDouble(),
    );
  }

  factory ProductModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return ProductModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
      };
}
