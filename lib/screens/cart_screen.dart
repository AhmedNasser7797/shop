import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/order_screen.dart';
import '../provider/orders.dart';
import '../widgets/cart_item.dart';
import '../provider/cart.dart';

class CartScreen extends StatelessWidget {
  static final routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartData = cart.items;
//    cartData.values.forEach((element) { print(element.);});
//    print(cartData.keys);
//    final orders=Provider.of<Orders>(context);
//    final ordersData=orders.orders;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
//              height: MediaQuery.of(context).size.height*.6,
//              width: MediaQuery.of(context).size.width*.5,
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: cartData.values.toList()[i],
                  child: CartItemWidget(cartData.keys.toList()[i]
//                    title: cartData.values.toList()[i].title,
//                      id: cartData.values.toList()[i].id,
//                  price: cartData.values.toList()[i].price,
//                  quantity: cartData.values.toList()[i].quantity,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({Key key, @required this.cart}) : super(key: key);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return _isLoading ? CircularProgressIndicator()
        : FlatButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
          setState(() {
            _isLoading=true;
          });
               await Provider.of<Orders>(context, listen: false)
                    .addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
          setState(() {
            _isLoading=false;
          });
                widget.cart.clear();
              },
        child: Text(
          'ORDER NOW',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ));
  }
}
