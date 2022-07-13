import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nested_tabbarview/sliver_header_delegate.dart';

class NestedTabBarPage extends StatelessWidget {
  const NestedTabBarPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final tabs = <String>['猜你喜欢', '今日特价', '发现更多'];
    return DefaultTabController(
      length: tabs.length,
      child: Theme(
        data: Theme.of(context).copyWith(
          brightness: Brightness.dark,
        ),
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(title),
                  pinned: true,
                  elevation: 0,
                ),
                buildSliverList(5),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverHeaderDelegate.builder(
                    maxHeight: 56,
                    minHeight: 56,
                    builder: (context, shrinkOffset, overlapsContent) {
                      return Material(
                        key: PageStorageKey<String>(title),
                        elevation: overlapsContent ? 4 : 0,
                        shadowColor: Theme.of(context).appBarTheme.shadowColor,
                        child: Container(
                          color: overlapsContent
                              ? Colors.white
                              : Theme.of(context).canvasColor,
                          child: buildTabBar(tabs),
                        ),
                      );
                    },
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: tabs.map((String name) {
                return Builder(
                  builder: (context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(name),
                      physics: const ClampingScrollPhysics(),
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: buildSliverList(50),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  TabBar buildTabBar(List<String> tabs) => TabBar(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black38,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2.0, color: Colors.blue),
          insets: EdgeInsets.only(bottom: 10),
        ),
        tabs: tabs.map((String name) => Tab(text: name)).toList(),
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
