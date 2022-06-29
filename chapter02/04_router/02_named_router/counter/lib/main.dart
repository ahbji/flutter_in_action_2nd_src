import 'package:counter/router.dart';
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
      routes: {
        "/new_page": (context) => const NewRoute(),
        "/echo_page": (context) => const EchoRoute(),
        "/tip_page": (context) => TipRoute(
              text: ModalRoute.of(context)!.settings.arguments
                  as String, // 将路由参数传参构造函数
            ),
        // 注册首页路由，代替 home 配置
        "/": (context) => const MyHomePage(
              title: 'Flutter Demo Home Page',
            ),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == "/other") {
          return MaterialPageRoute(
            builder: (context) {
              return const OtherRoute();
            },
          );
        }
      },
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: () {
                // 导航到命名路由
                Navigator.pushNamed(context, "/new_page");
              },
              child: const Text("open new route"),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await Navigator.of(context).pushNamed(
                  "/tip_page",
                  arguments: "我是提示 xxxx", // 设置路由参数
                );
                if (kDebugMode) {
                  print("路由返回值: $result");
                }
              },
              child: const Text("打开提示页"),
            ),
            TextButton(
              onPressed: () async {
                // 导航到`echo_page`路由，并等待返回结果
                var result = await Navigator.of(context).pushNamed(
                  "/echo_page",
                  arguments: "hi", // 设置路由参数
                );
                // 输出`TipRoute`路由返回结果
                if (kDebugMode) {
                  print("路由返回值: $result");
                }
              },
              child: const Text("打开 Echo 页"),
            ),
            ElevatedButton(
              onPressed: () {
                // 导航到命名路由
                Navigator.pushNamed(context, "/other");
              },
              child: const Text("open other route"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
