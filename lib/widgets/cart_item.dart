import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';


class CartItemWidget extends StatelessWidget {
  final String id;
//  final String title;
//  final int quantity;
//  final double price;
//  CartItemWidget({this.quantity,this.title,this.price,this.id});
CartItemWidget(this.id);
  @override
  Widget build(BuildContext context) {
 final cart=Provider.of<CartItem>(context);
 final cartID=Provider.of<Cart>(context);

    return Dismissible(
      key: ValueKey(cart.id),
      background: Container(
        color: Theme.of(context).errorColor,
      child: Icon(Icons.delete),
      ),
      onDismissed: (direction){
      Provider.of<Cart>(context,listen: false).removeItem(id);
//      cartID.removeItem(cart.id);
      },
      confirmDismiss: (direction){
        return showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text('Are You Sure?!'),
          content: Text('are you sure for deleting this item ?!'),
          actions: <Widget>[
            FlatButton( child: Text('No'),
              onPressed: (){
              Navigator.of(context).pop(false);
              },),
            FlatButton( child: Text('Yes'),
              onPressed: (){
              Navigator.of(context).pop(true);
              },)
          ],
        ),
        );
      },
      direction: DismissDirection.endToStart,

      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$${cart.price}')),),
            title: Text(cart.title),

        subtitle: Text('total : ${cart.quantity*cart.price}'),
            trailing: Text('${cart.quantity} x'),
          ),
        ),
      ),
    );
  }
}
