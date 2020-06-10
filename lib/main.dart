import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/helpers/custom_route.dart';
import './provider/auth.dart';
import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './provider/orders.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './provider/products_provider.dart';
import './provider/cart.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previousProducts) => ProductsProvider(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
//        ChangeNotifierProvider.value(value: ProductsProvider()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth,Orders>(update: (ctx,auth,previousOrder)=>
          Orders(auth.token,auth.userId,previousOrder==null?[] : previousOrder.orders),)
//        ChangeNotifierProvider.value(value: Orders()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
//              pageTransitionsTheme: PageTransitionsTheme(builders:{
//                TargetPlatform.android:CustomPAgeTransitionBuilder(),
//                TargetPlatform.iOS:CustomPAgeTransitionBuilder()
//          }),
          ),
          home: auth.isAuth ? ProductOverviewScreen()
              :FutureBuilder(
            future: auth.tryAutoLogin(),
              builder: (ctx,authResultSnapshot,)=>
          authResultSnapshot.connectionState==ConnectionState.waiting ?
          SplashScreen()
              : AuthScreen(),
          ),
          routes: {
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
