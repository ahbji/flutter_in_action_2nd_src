# infinite_listview

实例：无限加载列表

假设我们要从数据源异步分批拉取一些数据，然后用`ListView`展示，当我们滑动到列表末尾时，判断是否需要再去拉取数据，如果是，则去拉取，拉取过程中在表尾显示一个loading，拉取成功后将数据插入列表；如果不需要再去拉取，则在表尾提示"没有更多"。代码如下：

```dart
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
    return ListView.separated(
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
        // 显示列表项
        return ListTile(title: Text(_words[index]));
      },
      itemCount: _words.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: .0),
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
```

运行后效果如图6-5、6-6所示：

![https://book.flutterchina.club/assets/img/6-5.288d3ff1.png](https://book.flutterchina.club/assets/img/6-5.288d3ff1.png)

![https://book.flutterchina.club/assets/img/6-6.2947b7f7.png](https://book.flutterchina.club/assets/img/6-6.2947b7f7.png)

代码比较简单，读者可以参照代码中的注释理解，故不再赘述。需要说明的是，`_retrieveData()`的功能是模拟从数据源异步获取数据，我们使用 [english_words](https://pub.dev/packages/english_words) 包的`generateWordPairs()`方法每次生成20个单词。
