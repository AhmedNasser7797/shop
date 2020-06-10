import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/orders.dart' as ord;
import 'dart:math';

class OrderItemWidget extends StatefulWidget {
  final ord.OrderItem order;
  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded=false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.products.length*20.0+110,180) : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text('\$${widget.order.amount}'),
                trailing: IconButton(icon: Icon(_expanded? Icons.expand_less:Icons.expand_more), onPressed: (){
                  setState(() {
                    _expanded=!_expanded;
                  });
                }),
                subtitle: Text(DateFormat('dd/MM/yyy hh:mm').format(widget.order.dateTime)),
              ),
            ),

              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height:_expanded? min(widget.order.products.length*25.0+10,180): 0,
                child: ListView(
                  children: widget.order.products.map((
                    prod) =>Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(prod.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    Text('\$${prod.quantity}x \$${prod.price}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey
                    ),)
                  ],
                )
                ).toList(),),
              )
          ],
        ),
      ),
    );
  }
}
