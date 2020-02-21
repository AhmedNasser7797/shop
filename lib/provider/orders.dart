import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import 'package:http/http.dart' as http;
import '../provider/products_provider.dart';
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;
  Orders(this.authToken,this.userId,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async{
    final url = 'https://shopapp-2253d.firebaseio.com/order/$userId.json?auth=$authToken';
    final dateStamp=DateTime.now();
    final response=await http.post(url,
    body: json.encode({
      'amount':total,
      'dateTime':dateStamp.toIso8601String(),
      'products':cartProducts.map((cp) => {
        'price':cp.price,
        'quantity':cp.quantity,
        'id':cp.id,
        'title':cp.title
      }).toList(),
    }),
    );
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            products: cartProducts,
            amount: total,
            dateTime: dateStamp,
        )
    );
    notifyListeners();
  }

  Future<void> fetchaAndSetOrders()async{
    final url = 'https://shopapp-2253d.firebaseio.com/order/$userId.json?auth=$authToken';
    final response=await http.get(url);
    print(json.decode(response.body));
    final List <OrderItem>loadedData=[];
    final extractedData=json.decode(response.body) as Map<String,dynamic>;
    if(extractedData==null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedData.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime:DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((item) =>CartItem(
              id: item['id'],
              title: item['title'],
              price: item['price'],
              quantity:item['quantity'],),
          ).toList(),
      ),
      );
    });
    _orders=loadedData.reversed.toList();
    notifyListeners();
  }
}
