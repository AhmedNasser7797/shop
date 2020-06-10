import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import '../widgets/product_item.dart';
import '../provider/products_provider.dart';


class ProductGrid extends StatelessWidget {
  bool _showFavorite;
  ProductGrid(this._showFavorite);

  @override
  Widget build(BuildContext context) {
   final productData= Provider.of<ProductsProvider>(context);
   final products= _showFavorite ? productData.favoriteItems
   : productData.items;
   print('product grid ${productData.items}');

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
        value: products[i],
          child: ProductItem
            (
//              products[i].id,
//              products[i].title,
//              products[i].imageUrl
              ),
        );
      },
    );
  }
}
