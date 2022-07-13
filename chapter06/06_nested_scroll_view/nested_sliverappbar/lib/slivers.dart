import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NestedSliverAppBarPage extends StatefulWidget {
  const NestedSliverAppBarPage({super.key, required this.title});
  final String title;

  @override
  State<NestedSliverAppBarPage> createState() => _NestedSliverAppBarPageState();
}

class _NestedSliverAppBarPageState extends State<NestedSliverAppBarPage> {
  late SliverOverlapAbsorberHandle handle;

  void onOverlapChanged() {
    if (kDebugMode) {
      print(handle.layoutExtent);
    }
  }

  @override
  void dispose() {
    handle.removeListener(onOverlapChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          handle = NestedScrollView.sliverOverlapAbsorberHandleFor(context);
          handle.removeListener(onOverlapChanged);
          handle.addListener(onOverlapChanged);
          // 返回一个 Sliver 数组给外部可滚动组件。
          return <Widget>[
            SliverOverlapAbsorber(
              handle: handle,
              sliver: SliverAppBar(
                floating: true,
                snap: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget.title),
                  background: Image.asset(
                    "./imgs/sea.png",
                    fit: BoxFit.cover,
                  ),
                ),
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        },
        body: LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: <Widget>[
                SliverOverlapInjector(handle: handle),
                buildSliverList(100),
              ],
            );
          },
        ),
      ),
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
