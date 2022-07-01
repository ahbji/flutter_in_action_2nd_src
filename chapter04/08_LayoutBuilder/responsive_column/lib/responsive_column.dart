import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ResponsiveColumn extends StatelessWidget {
  const ResponsiveColumn({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // 通过 LayoutBuilder 拿到父组件传递的约束，然后判断 maxWidth 是否小于200
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 200) {
          // 最大宽度小于 200，显示单列
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
        } else {
          // 大于200，显示双列
          var renderChildren = <Widget>[];
          for (var i = 0; i < children.length; i += 2) {
            if (i + 1 < children.length) {
              renderChildren.add(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [children[i], children[i + 1]],
                ),
              );
            } else {
              renderChildren.add(children[i]);
            }
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: renderChildren,
          );
        }
      },
    );
  }
}

class LayoutLogPrint<T> extends StatelessWidget {
  const LayoutLogPrint({
    super.key,
    this.tag,
    required this.child,
  });

  final Widget child;
  final T? tag;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        // assert在编译release版本时会被去除
        assert(() {
          if (kDebugMode) {
            print('${tag ?? key ?? child}: $constraints');
          }
          return true;
        }());
        return child;
      },
    );
  }
}
