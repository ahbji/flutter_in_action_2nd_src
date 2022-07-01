import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class AfterLayout extends SingleChildRenderObjectWidget {
  const AfterLayout({
    super.key,
    required this.callback,
    super.child,
  });

  /// [callback] will be triggered after the layout phase ends.
  final ValueSetter<RenderAfterLayout> callback;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAfterLayout(callback);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderAfterLayout renderObject) {
    renderObject.callback = callback;
  }
}

class RenderAfterLayout extends RenderProxyBox {
  RenderAfterLayout(this.callback);

  ValueSetter<RenderAfterLayout> callback;

  @override
  void performLayout() {
    super.performLayout();
    // 不能直接回调 callback，原因是当前组件布局完成后可能还有其它组件未完成布局
    // 如果 callback 中又触发了 UI 更新（比如调用了 setState）则会报错。因此，我们
    // 在 frame 结束的时候再去触发回调 callback(this);
    SchedulerBinding.instance
        .addPostFrameCallback((timeStamp) => callback(this));
  }

  /// 组件在在屏幕坐标中的起始偏移坐标
  Offset get offset => localToGlobal(Offset.zero);

  /// 组件在屏幕上占有的矩形空间区域
  Rect get rect => offset & size;
}
