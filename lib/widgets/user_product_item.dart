import 'package:flutter/material.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String id;
  UserProductItem(this.id,this.title,this.imgUrl);
  @override
  Widget build(BuildContext context) {
final scaffold=Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: FittedBox(
        child: CircleAvatar(backgroundImage: NetworkImage(imgUrl),
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: <Widget>[
          IconButton(icon: Icon(Icons.edit),onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
          },),
          IconButton(icon: Icon(Icons.delete,color: Theme.of(context).errorColor,),onPressed: () async{
            try{

             await Provider.of<ProductsProvider>(context,listen: false).deleteProduct(id);
            }catch(error){
              scaffold.showSnackBar(SnackBar(
                content: Text('Deleting failed',textAlign: TextAlign.center,),
              ));
            }
            },
          ),
        ],),
      ),

    );
  }
}
