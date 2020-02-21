import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem with ChangeNotifier{
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items={};
  // <key"id",product>
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount{
    return _items.length;
  }

  double get totalAmount{
    double total=0.0;
    _items.forEach((key, value) {
      total +=value.price*value.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price,) {
    if (_items.containsKey(productId)) {
      // just add quantity because the product already in the cart
      _items.update(
          productId,
          (existingCardItem) => CartItem(
              id: productId,
              title: existingCardItem.title,
              price: existingCardItem.price,
              quantity: existingCardItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(productID){
    _items.remove(productID);
    notifyListeners();
  }

  void removeSingleITem(productID){
    if(!_items.containsKey((productID))){
      return;
    }
    if(_items[productID].quantity >1){
      _items.update(productID, (existingCardItem) => CartItem(
          id: existingCardItem.id,
          title: existingCardItem.title,
          price: existingCardItem.price,
          quantity: existingCardItem.quantity -1));
    }
    else{
      _items.remove(productID);
    }
    notifyListeners();
  }

  void clear(){
    _items={};
    notifyListeners();
  }
}
