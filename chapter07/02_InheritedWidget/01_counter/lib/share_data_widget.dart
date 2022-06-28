import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShareDataWidget extends InheritedWidget {
  const ShareDataWidget({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final int data; // 共享数据

  // 定义一个便捷方法，方便子树中的 widget 获取共享数据
  static ShareDataWidget? of(BuildContext context) {
    // 返回 ShareDataWidget 的同时，为 ShareDataWidget 以及依赖它的 ChildWidget 建立依赖关系
    return context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();
  }

  // 该回调决定当 data 发生变化时，是否通知子树中依赖 data 的 Widget 重新 build
  @override
  bool updateShouldNotify(ShareDataWidget oldWidget) {
    return oldWidget.data != data;
  }
}

class ChildWidget extends StatefulWidget {
  const ChildWidget({Key? key}) : super(key: key);

  @override
  State<ChildWidget> createState() => ChildWidgetState();
}

class ChildWidgetState extends State<ChildWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      ShareDataWidget.of(context)!.data.toString(), // 依赖 ShareDataWidget 中的 data
      style: Theme.of(context).textTheme.headline4,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 父或祖先 widget 中的 InheritedWidget 改变 ( updateShouldNotify 返回 true ) 时会被调用。
    // 如果 build 中没有依赖 InheritedWidget ，则此回调不会被调用。
    if (kDebugMode) {
      print("Dependencies change");
    }
  }
}
