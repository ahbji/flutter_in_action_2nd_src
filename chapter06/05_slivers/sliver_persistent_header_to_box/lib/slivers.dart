import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'sliver_persistent_header_to_box.dart';

class SliverPersistentHeaderToBoxPage extends StatelessWidget {
  const SliverPersistentHeaderToBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        buildSliverList(5),
        SliverPersistentHeaderToBox.builder(
          builder: _headerBuilder,
        ),
        buildSliverList(5),
        SliverPersistentHeaderToBox(
          child: _wTitle('Title 2'),
        ),
        buildSliverList(50),
      ],
    );
  }

  // 当 header 固定后显示阴影
  Widget _headerBuilder(context, maxExtent, fixed) {
    // 获取当前应用主题，关于主题相关内容将在后面章节介绍，现在我们要从主题中获取一些颜色。
    var theme = Theme.of(context);
    return Material(
      elevation: fixed ? 4 : 0,
      shadowColor: theme.appBarTheme.shadowColor,
      child: Container(
        color: fixed ? Colors.white : theme.canvasColor,
        child: _wTitle('Title 1'),
      ),
    );
  }

  // 我们约定小写字母 w 开头的函数代表是需要构建一个 Widget，这比 buildXX 会更简洁
  Widget _wTitle(String text) => ListTile(
        title: Text(text),
        onTap: () {
          if (kDebugMode) {
            print(text);
          }
        },
      );
}

Widget buildSliverList([int count = 5]) {
  return SliverFixedExtentList(
    itemExtent: 50,
    delegate: SliverChildBuilderDelegate(
      (context, index) => ListTile(
        title: Text('$index'),
        onTap: () {
          if (kDebugMode) {
            print(index);
          }
        },
      ),
      childCount: count,
    ),
  );
}
