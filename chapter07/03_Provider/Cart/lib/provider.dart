import 'package:flutter/material.dart';

// 一个通用的InheritedWidget，保存需要跨组件共享的状态
class _InheritedProvider<T> extends InheritedWidget {
  const _InheritedProvider({super.key, required this.data, required super.child});

  final T data;

  @override
  bool updateShouldNotify(_InheritedProvider<T> oldWidget) {
    //在此简单返回 true ，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}

/// 数据变化时通知 Listener
class ChangeNotifier implements Listenable {
  List listeners = [];

  @override
  void addListener(VoidCallback listener) {
    //添加监听器
    listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    //移除监听器
    listeners.remove(listener);
  }

  void notifyListeners() {
    for (var item in listeners) {
      item();
    }
  }
}

/// 订阅者类，负责重新构建 InheritedProvider
class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  const ChangeNotifierProvider({super.key,
    required this.data,
    required this.child,
  });

  final Widget child; // 缓存 child widget
  final T data;

  /// 定义一个便捷方法，方便子树中的 widget 获取共享数据，并添加一个 [listen] 参数，表示是否建立依赖关系
  static T? of<T>(BuildContext context, {bool listen = true}) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedProvider<T>>() // 与父 Widget 建立依赖关系
        : context
            .getElementForInheritedWidgetOfExactType<_InheritedProvider<T>>() // 不建立依赖关系，只返回父 Widget
            ?.widget as _InheritedProvider<T>;
    if (provider != null) return provider.data;
    return null;
  }

  @override
  ChangeNotifierProviderState<T> createState() =>
      ChangeNotifierProviderState<T>();
}

class ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  void _update() {
    // 如果数据发生变化（ model 类调用了 notifyListeners），重新构建 InheritedProvider
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    // 当 Provider 更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(_update);
      widget.data.addListener(_update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给 model 添加监听器
    widget.data.addListener(_update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除 model 的监听器
    widget.data.removeListener(_update);
    super.dispose();
  }
}

/// 这是一个便捷类，会获得当前 context 和指定数据类型的 Provider
class Consumer<T> extends StatelessWidget {
  const Consumer({Key? key, required this.builder}) : super(key: key);

  final Widget Function(BuildContext context, T? value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, ChangeNotifierProvider.of<T>(context));
  }
}
