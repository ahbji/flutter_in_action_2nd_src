import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'sliver_flexible_header.dart';

class SliverFlexibleHeaderPage extends StatefulWidget {
  const SliverFlexibleHeaderPage({super.key});

  @override
  State<SliverFlexibleHeaderPage> createState() =>
      _SliverFlexibleHeaderPageState();
}

class _SliverFlexibleHeaderPageState extends State<SliverFlexibleHeaderPage> {
  double _initHeight = 250;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // 为了能使 CustomScrollView 拉到顶部时还能继续往下拉，必须让 physics 支持弹性效果
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // 我们需要实现的 SliverFlexibleHeader 组件
        SliverFlexibleHeader(
          visibleExtent: _initHeight, // 初始状态在列表中占用的布局高度
          // 为了能根据下拉状态变化来定制显示的布局，我们通过一个 builder 来动态构建布局。
          builder: (context, availableHeight, direction) => GestureDetector(
            onTap: () {
              if (kDebugMode) {
                print('tap');
              }
            },
            child: Image(
              image: const AssetImage("imgs/avatar.png"),
              width: 50.0,
              height: availableHeight,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ListTile(
            onTap: () {
              setState(() {
                _initHeight = _initHeight == 250 ? 150 : 250;
              });
            },
            title: const Text('重置高度'),
            trailing: Text('当前高度 $_initHeight'),
          ),
        ),
        // 构建一个 list
        buildSliverList(30),
      ],
    );
  }
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
