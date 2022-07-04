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
  String _progress = "0%"; // 保存进度百分比

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
            itemCount: 100,
            itemExtent: 50.0, // 列表项高度固定时，显式指定高度是一个好习惯(性能消耗小)
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("$index"),
              );
            },
          );
          // 监听滚动通知
          var listener = NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              double progress = notification.metrics.pixels /
                  notification.metrics.maxScrollExtent;
              // 重新构建
              setState(() {
                _progress = "${(progress * 100).toInt()}%";
              });
              if (kDebugMode) {
                print("BottomEdge: ${notification.metrics.extentAfter == 0}");
              }
              return false;
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                listView,
                CircleAvatar(
                  // 显示进度百分比
                  radius: 30.0,
                  backgroundColor: Colors.black54,
                  child: Text(_progress),
                ),
              ],
            ),
          );
          switch (theme.platform) {
            case TargetPlatform.linux:
            case TargetPlatform.macOS:
            case TargetPlatform.windows:
              return listener;
            case TargetPlatform.android:
            case TargetPlatform.fuchsia:
            case TargetPlatform.iOS:
              return Scrollbar(
                child: listener,
              );
          }
        },
      ),
    );
  }
}
