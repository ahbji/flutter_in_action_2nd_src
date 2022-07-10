import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   List tabs = ["新闻", "历史", "图片"];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: tabs.length, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var children = <Widget>[];
//     for (int i = 0; i < tabs.length; ++i) {
//       children.add(
//         KeepAliveWrapper(
//           child: Page(
//             text: tabs[i],
//           ),
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         bottom: TabBar(
//           tabs: tabs.map((e) => Tab(text: e)).toList(),
//           controller: _tabController,
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: children,
//       ),
//     );
//   }
// }

class _HomePageState extends State<HomePage> {
  List tabs = ["新闻", "历史", "图片"];

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (int i = 0; i < tabs.length; ++i) {
      children.add(
        KeepAliveWrapper(
          child: Page(
            text: tabs[i],
          ),
        ),
      );
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
        ),
        body: TabBarView(
          children: children,
        ),
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({
    super.key,
    this.keepAlive = true,
    required this.child,
  });

  final bool keepAlive;
  final Widget child;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      // keepAlive 状态需要更新，实现在 AutomaticKeepAliveClientMixin 中
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => true;
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
