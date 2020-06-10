import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];


//  Future<List<Product>> get favoriteItems async{
//
//
//    const url = 'https://shopapp-2253d.firebaseio.com/products.json';
//    try{
//      final response=await http.get(url);
//      print(response.body);
//      final extractData= json.decode(response.body) as Map<String , dynamic>;
//      print(extractData);
//      print(_items);
//      final List<Product> loadedData=[];
//      extractData.forEach((prodId, prodValue) {
//        loadedData.where((productItem) =>productItem.isFavorite).toList();
//      });
//      _favoriteItems=loadedData;
//      notifyListeners();
//    }
//    catch(error){
//      throw error;
//    }
//  }
//  int get favoriteCount{
//    return _favoriteItems.length;
//  }
  String authToken;
  String userId;
  ProductsProvider(this.authToken,this.userId,this._items);
  List _favoriteItems=[];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems{
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
  Future<void> fetchAndSetProducts([bool filterByUser=false]) async{
    final filterString= filterByUser ?'orderBy="creatorId"&equalTo="$userId"':'';
    var url = 'https://shopapp-2253d.firebaseio.com/products.json?auth=$authToken&$filterString';
    try{
      // 1. get all data but without the favorites products
      final response=await http.get(url);

      print(response.body);
      final extractData= json.decode(response.body) as Map<String , dynamic>;
      if(extractData==null){
        return;
      }
      // 2. get the favorite product for a specific user
       url = 'https://shopapp-2253d.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse=await http.get(url);

      final favoriteData=json.decode(favoriteResponse.body);

      // 3. get all data include the favorite
      final List<Product> loadedData=[];
     extractData.forEach((prodId, prodValue) {
       loadedData.add(Product(
         id: prodId,
         title: prodValue['title'],
         description: prodValue['description'],
         price: prodValue['price'],
         imageUrl: prodValue['imageUrl'],
         isFavorite: favoriteData==null ?false : favoriteData[prodId]??false,
       ));
     });
     _items=loadedData;
     notifyListeners();
    }
    catch(error){
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://shopapp-2253d.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http
          .post(url,
              body: json.encode({
                'title': product.title,
                'description': product.description,
                'imageUrl': product.imageUrl,
                'price': product.price,
                'creatorId':userId,
//                'isFavorite': product.isFavorite
              }),);

      final newProduct = Product(
          title: product.title,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name'],
          description: product.description,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      final url = 'https://shopapp-2253d.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(url,body: json.encode({
        'title':newProduct.title,
        'description':newProduct.description,
        'price':newProduct.price,
        'imageUrl':newProduct.imageUrl
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else
      print('...');
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-update.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}


