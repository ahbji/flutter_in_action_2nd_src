import 'package:flutter/material.dart';

class NewRoute extends StatelessWidget {
  const NewRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New route"),
      ),
      body: const Center(
        child: Text("This is new route"),
      ),
    );
  }
}

class TipRoute extends StatelessWidget {
  const TipRoute({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("提示"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              ElevatedButton(
                  // 将栈顶路由出栈，同时为上一个页面返回路由参数
                  onPressed: () => Navigator.pop(context, "我是返回值"),
                  child: const Text("返回"))
            ],
          ),
        ),
      ),
    );
  }
}
