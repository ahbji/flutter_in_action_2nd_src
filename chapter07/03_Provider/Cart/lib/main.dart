import 'package:cart/cart.dart';
import 'package:cart/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CartWidget(),
          ],
        ),
      ),
    );
  }
}

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider<CartModel>(
        data: CartModel(), // 注册 CartModel
        child: Builder(
          builder: (context) {
            return Column(
              children: <Widget>[
                Consumer<CartModel>(
                  builder: (context, cart) => Text("总价：${cart?.totalPrice}"),
                ),
                Builder(
                  builder: (context) {
                    if (kDebugMode) {
                      print("ElevatedButton build");
                    } // 在后面优化部分会用到
                    return ElevatedButton(
                      child: const Text("添加商品"),
                      onPressed: () {
                        // 给购物车中添加商品，添加后总价会更新
                        // listen 参数为 false，表示不监听数据变化，只返回 CartModel
                        ChangeNotifierProvider.of<CartModel>(context,
                                listen: false)
                            ?.add(Item(20.0, 1));
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
