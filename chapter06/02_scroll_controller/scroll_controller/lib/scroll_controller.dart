import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _controller = ScrollController();
  bool showToTopBtn = false; // 是否显示“返回到顶部”按钮

  @override
  void initState() {
    super.initState();
    // 监听滚动事件，打印滚动位置
    _controller.addListener(
      () {
        if (kDebugMode) {
          print(_controller.offset);
        }
        if (_controller.offset < 1000 && showToTopBtn) {
          setState(
            () {
              showToTopBtn = false;
            },
          );
        } else if (_controller.offset >= 1000 && showToTopBtn == false) {
          setState(
            () {
              showToTopBtn = true;
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    // 为了避免内存泄露，需要调用 _controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) {
          ThemeData theme = Theme.of(context);
          ListView listView = ListView.builder(
            controller: _controller,
            itemCount: 100,
            itemExtent: 50.0, // 列表项高度固定时，显式指定高度是一个好习惯(性能消耗小)
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("$index"),
              );
            },
          );
          switch (theme.platform) {
            case TargetPlatform.linux:
            case TargetPlatform.macOS:
            case TargetPlatform.windows:
              return listView;
            case TargetPlatform.android:
            case TargetPlatform.fuchsia:
            case TargetPlatform.iOS:
              return Scrollbar(
                controller: _controller,
                child: listView,
              );
          }
        },
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              tooltip: 'scroll to top',
              onPressed: () {
                _controller.animateTo(
                  .0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                );
              },
              child: const Icon(Icons.arrow_upward),
            ),
    );
  }
}
