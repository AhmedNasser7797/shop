import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../provider/cart.dart';
import '../widgets/badge.dart.dart';
import '../widgets/products_grid.dart';
import '../provider/product.dart';

enum filterOption { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName='/rpoduct_overview_screen';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavorite = false;

  var _isInit = true;
  var _isLoading = false;
  @override
//  void didChangeDependencies() {
//    if(_isInit){
//      setState(() {
//        _isLoading=true;
//      });
//
//      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
//        setState(() {
//          _isLoading=false;
//        });
//      });
//    }
//    _isInit=false;
//    super.didChangeDependencies();
//  }

  @override
  void initState() {
    setState(() {
      _showFavorite=false;
    });
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(Duration.zero).then((_) {
        Provider.of<ProductsProvider>(context, listen: false)
            .fetchAndSetProducts()
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _isInit = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (filterOption selectedValue) {
                setState(() {
                  if (selectedValue == filterOption.favorites) {
                    _showFavorite = true;
                  }
                  if (selectedValue == filterOption.all) {
                    _showFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Favorites"),
                      value: filterOption.favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: filterOption.all,
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavorite),
    );
  }
}
