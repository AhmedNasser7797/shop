import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../provider/product.dart';
import '../screens/product_detail_screen.dart';
import '../provider/auth.dart';
class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageUrl;
//
//  ProductItem(this.id,this.title,this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart=Provider.of<Cart>(context,listen: false);
    final token=Provider.of<Auth>(context).token;
    final userId=Provider.of<Auth>(context).userId;
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl,),fit: BoxFit.cover,

            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
            leading: Consumer<Product>(
              builder: (ctx, Product, child) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoriteStatus(token,userId);
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                  content: Text('Added item to Cart'),
                  duration: Duration(seconds: 2),
                action: SnackBarAction(label: 'UNDO',
                  onPressed: (){
                  cart.removeSingleITem(product.id);
                  },
                ),
                ),
                );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
