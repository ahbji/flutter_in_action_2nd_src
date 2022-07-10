import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget buildTwoSliverList() {
  var listview = buildSliverList(10);
  return CustomScrollView(
    slivers: [
      listview,
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
