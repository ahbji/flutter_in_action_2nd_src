import 'package:after_layout/after_layout.dart';
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
  String _text = 'flutter 实战 ';
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  child: const Text(
                    'Text1: 点我获取我的大小',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    if (kDebugMode) {
                      print('Text1: ${context.size}');
                    }
                  },
                );
              },
            ),
          ),
          AfterLayout(
            callback: (ral) {
              if (kDebugMode) {
                print('Text2： ${ral.size}, ${ral.offset}');
              }
            },
            child: const Text('Text2：flutter@wendux'),
          ),
          Builder(
            builder: (context) {
              return Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                width: 100,
                height: 100,
                child: AfterLayout(
                  callback: (RenderAfterLayout value) {
                    Offset offset = value.localToGlobal(
                      Offset.zero,
                      ancestor: context.findRenderObject(),
                    );
                    if (kDebugMode) {
                      print('A 在 Container 中占用的空间范围为：${offset & value.size}');
                    }
                  },
                  child: const Text('A'),
                ),
              );
            },
          ),
          const Divider(),
          AfterLayout(
            child: Text(_text),
            callback: (RenderAfterLayout value) {
              setState(() {
                //更新 _size
                _size = value.size;
              });
            },
          ),
          //显示上面 Text 的 _size
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Text size: $_size ',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _text += 'flutter 实战 ';
              });
            },
            child: const Text('追加字符串'),
          ),
        ],
      ),
    );
  }
}
