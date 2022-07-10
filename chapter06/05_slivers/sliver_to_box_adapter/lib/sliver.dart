import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget buildWithPageView() {
  var listview = buildSliverList(20);
  var pages = <Widget>[];
  for (int i = 0; i < 6; ++i) {
    pages.add(
      Page(
        text: '$i',
      ),
    );
  }
  return CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: SizedBox(
          height: 300,
          child: PageView(
            allowImplicitScrolling: true,
            children: pages,
          ),
        ),
      ),
      listview,
    ],
  );
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

class Page extends StatefulWidget {
  const Page({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("build ${widget.text}");
    }
    return Center(
      child: Text(
        widget.text,
        textScaleFactor: 5,
      ),
    );
  }
}
