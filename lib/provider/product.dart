import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.title,
      @required this.imageUrl,
      @required this.id,
      @required this.description,
      this.isFavorite = false,
      @required this.price});

  Future<void> toggleFavoriteStatus(String token,String userId) async {
    final oldFavoriteState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url = 'https://shopapp-2253d.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
      final response =
          await http.put(url, body: json.encode( isFavorite));
      if (response.statusCode >= 400) {
        isFavorite = oldFavoriteState;
        print('couldnt add to favorite');
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldFavoriteState;
      print('couldnt add to favorite');
      notifyListeners();
    }
  }
//  toggleFavoriteStatus(){
//    isFavorite=!isFavorite;
////    Provider.of<ProductsProvider(context).updateProduct(id, Product(title: null, imageUrl: null, id: null, description: null, price: null));
//
//    notifyListeners();
//    //notifyListeners is equivelant to setState which means..
//    // if something happens or if this functions is invocked
//    // so listen to this only code
//  }
}
