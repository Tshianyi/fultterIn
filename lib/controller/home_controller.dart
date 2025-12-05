
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_pro/model/produit_model.dart';

class HomeController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProductModel>> getProduits() {
    return _db.collection('Produits').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Utilise la factory qui prend DocumentSnapshot
        return ProductModel.fromFirestore(doc);
      }).toList();
    });
  }
}
