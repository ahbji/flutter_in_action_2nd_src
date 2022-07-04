import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class InfiniteListView extends StatefulWidget {
  const InfiniteListView({super.key});

  @override
  State<InfiniteListView> createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##"; // List Tail 标记
  final _words = <String>[loadingTag];

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text("商品列表"),
        ),
        // 使用 Column + Expanded 自动拉伸 ListView 以填充屏幕剩余空间
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              // 如果到了表尾
              if (_words[index] == loadingTag) {
                // 不足 100 条，继续获取数据
                if (_words.length - 1 < 100) {
                  // 获取数据
                  _retrieveData();
                  // 加载时显示 loading
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  );
                } else {
                  // 已经加载了 100 条数据，不再获取数据。
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      "没有更多了",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
              }
              // 显示单词列表项
              return ListTile(title: Text(_words[index]));
            },
            itemCount: _words.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: .0),
          ),
        ),
      ],
    );
  }

  void _retrieveData() {
    Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        setState(
          () {
            _words.insertAll(
              _words.length - 1,
              generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
            );
          },
        );
      },
    );
  }
}
