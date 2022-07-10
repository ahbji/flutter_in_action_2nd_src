import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget sliverListWithPersistentHeader() {
  var listview1 = buildSliverList();
  var listview2 = buildSliverList(20);
  return CustomScrollView(
    slivers: [
      listview1,
      SliverPersistentHeader(
        delegate: SliverHeaderDelegate(
          maxHeight: 80,
          minHeight: 50,
          child: buildHeader(1),
        ),
        pinned: true,
      ),
      listview1,
      SliverPersistentHeader(
        delegate: SliverHeaderDelegate(
          maxHeight: 80,
          minHeight: 50,
          child: buildHeader(2),
        ),
        pinned: true,
      ),
      listview2,
      SliverPersistentHeader(
        delegate: SliverHeaderDelegate(
          maxHeight: 80,
          minHeight: 50,
          child: buildHeader(3),
        ),
        pinned: true,
      ),
      listview2,
    ],
  );
}

Widget buildHeader(int i) {
  return GestureDetector(
    key: ValueKey(i),
    onTap: () {
      if (kDebugMode) {
        print('header $i');
      }
    },
    child: Container(
      color: Colors.lightBlue.shade200,
      alignment: Alignment.centerLeft,
      child: Text("PersistentHeader $i"),
    ),
  );
}

typedef SliverHeaderBuilder = Widget Function(
    BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  // child 为 header
  SliverHeaderDelegate({
    required this.maxHeight,
    this.minHeight = 0,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  // 最大和最小高度相同
  SliverHeaderDelegate.fixedHeight({
    required double height,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        maxHeight = height,
        minHeight = height;

  // 需要自定义 builder 时使用
  SliverHeaderDelegate.builder({
    required this.maxHeight,
    this.minHeight = 0,
    required this.builder,
  });

  final double maxHeight;
  final double minHeight;
  final SliverHeaderBuilder builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    // 测试代码：如果在调试模式，且子组件设置了 key，则打印日志
    assert(() {
      if (child.key != null) {
        if (kDebugMode) {
          print(
              '${child.key}: shrink: $shrinkOffset，overlaps:$overlapsContent');
        }
      }
      return true;
    }());
    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent;
  }
}

Widget buildSliverList([int count = 5]) {
  return SliverFixedExtentList(
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
    itemExtent: 50,
  );
}
