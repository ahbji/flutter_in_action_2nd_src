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
  // 定义一个 ValueNotifier ，当数字变化时会通知 ValueListenableBuilder
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  static const double textScaleFactor = 1.5; // 缩放倍率

  void _incrementCounter() {
    _counter.value += 1;
  }

  @override
  Widget build(BuildContext context) {
    // 添加 + 按钮不会触发整个组件的 build
    if (kDebugMode) {
      print('build');
    }
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
            // 使用 ValueListenableBuilder 监听 _counter
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              // 当子组件不依赖变化的数据，且子组件收件开销比较大时，指定 child 属性来缓存子组件非常有用
              child: const Text(
                '点击了 ',
                textScaleFactor: textScaleFactor,
              ),
              // builder 方法只会在 _counter 变化时被调用
              builder: (BuildContext context, int value, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    child!, // 不变的部分
                    // 变化的部分
                    Text(
                      '$value 次',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // 点击后值 +1，触发 ValueListenableBuilder 重新构建
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
