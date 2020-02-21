import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName='/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading=false;
  @override
//  void initState() {
//    Future.delayed(Duration.zero).then((_) async{
//      setState(() {
//        _isLoading=true;
//      });
//      await Provider.of<Orders>(context,listen: false).fetchaAndSetOrders();
//      setState(() {
//        _isLoading=false;
//      });
//    });
//     super.initState();
//  }
  @override
  Widget build(BuildContext context) {
//    final orderData=Provider.of<Orders>(context);

//    final orders=ModalRoute.of(context).settings.arguments as Map;
//    final orderData=orders.values.toList();
//    print('orders map $orders');
//    print('orders list $orderData');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchaAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child)=> ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItemWidget(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );

//      FutureBuilder(future:  Provider.of<Orders>(context,listen: false).fetchaAndSetOrders(),
//          builder: (ctx,dataSnapshot){
//        if(dataSnapshot.connectionState==ConnectionState.waiting){
//          return Center(child: CircularProgressIndicator(),);
//        }
//        else{
//          if(dataSnapshot.error!=null){
//            //error handling
//            // ignore: missing_return
//            return Center(child: Text('an Error Occured'),);
//          }
//          else{
//            Consumer(
//              builder: (ctx,orderData,child)=>
//              ListView.builder(itemCount: orderData.orders.length,
//          itemBuilder: (ctx,i)=> OrderItemWidget(orderData.orders[i]),
//      ),
//            );
//          }
//        }
//          })
//      _isLoading? Center(child: CircularProgressIndicator(),)
//      : ListView.builder(itemCount: orderData.orders.length,
//          itemBuilder: (ctx,i)=> OrderItemWidget(orderData.orders[i]),
//      ),
//    );
  }
}
