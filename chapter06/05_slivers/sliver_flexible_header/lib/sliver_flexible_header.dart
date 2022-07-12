import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'extra_info_constraints.dart';

typedef SliverFlexibleHeaderBuilder = Widget Function(
  BuildContext context,
  double maxExtent,
  ScrollDirection direction,
);

// 在下拉位置发生变化时重新构建 widget
class SliverFlexibleHeader extends StatelessWidget {
  const SliverFlexibleHeader({
    super.key,
    this.visibleExtent = 0,
    required this.builder,
  });

  final SliverFlexibleHeaderBuilder builder;
  final double visibleExtent;

  @override
  Widget build(BuildContext context) {
    return _SliverFlexibleHeader(
      visibleExtent: visibleExtent,
      // 创建一个 LayoutBuilder 在子组件重新布局时动态构建 child
      // 当 _SliverFlexibleHeader 中每次对子组件进行布局时，
      // 都会触发 LayoutBuilder 来重新构建子 widget
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return builder(
            context,
            constraints.maxHeight,
            // 获取滑动方向
            (constraints as ExtraInfoBoxConstraints<ScrollDirection>).extra,
          );
        },
      ),
    );
  }
}

class _SliverFlexibleHeader extends SingleChildRenderObjectWidget {
  const _SliverFlexibleHeader({
    super.child,
    this.visibleExtent = 0,
  });
  final double visibleExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FlexibleHeaderRenderSliver(visibleExtent);
  }

  @override
  void updateRenderObject(
      BuildContext context, _FlexibleHeaderRenderSliver renderObject) {
    renderObject.visibleExtent = visibleExtent;
  }
}

class _FlexibleHeaderRenderSliver extends RenderSliverSingleBoxAdapter {
  _FlexibleHeaderRenderSliver(double visibleExtent)
      : _visibleExtent = visibleExtent;

  double _lastOverScroll = 0;
  double _lastScrollOffset = 0;
  double _visibleExtent = 0;
  ScrollDirection _direction = ScrollDirection.idle;

  // 该变量用来确保 Sliver 完全离开屏幕时会通知 child 且只通知一次。
  bool _reported = false;

  // 是否需要修正 scrollOffset._visibleExtent 值更新后，
  // 为了防止突然的跳动，要先修正 scrollOffset。
  double? _scrollOffsetCorrection;

  set visibleExtent(double value) {
    // 可视长度发生变化，更新状态并重新布局
    if (_visibleExtent != value) {
      _lastOverScroll = 0;
      _reported = false;
      // 计算修正值
      _scrollOffsetCorrection = value - _visibleExtent;
      _visibleExtent = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    // _visibleExtent 值更新后，为了防止突然的跳动，先修正 scrollOffset
    if (_scrollOffsetCorrection != null) {
      geometry = SliverGeometry(
        // 修正
        scrollOffsetCorrection: _scrollOffsetCorrection,
      );
      _scrollOffsetCorrection = null;
      return;
    }

    if (child == null) {
      geometry = SliverGeometry(scrollExtent: _visibleExtent);
      return;
    }

    // 当已经完全滑出屏幕时通知 child 重新布局，同时将 maxEvent 设置为 0。
    // 注意，通知一次即可，如果不通知，滑出屏幕后，child 在最后一次构建时拿到的可用高度可能不为 0。
    // 因为使用者在构建子节点的时候，可能会依赖 "当前的可用高度是否为0" 来做一些特殊处理，比如记录是否子节点已经离开了屏幕。
    // 因此，我们需要在离开屏幕时确保 LayoutBuilder 的 builder 会被调用一次（构建子组件）。
    if (constraints.scrollOffset > _visibleExtent) {
      geometry = SliverGeometry(scrollExtent: _visibleExtent);
      if (!_reported) {
        _reported = true;
        child!.layout(
          // 对子组件进行布局
          ExtraInfoBoxConstraints(
            _direction, // 传递滑动方向
            constraints.asBoxConstraints(maxExtent: 0),
          ),
          // 我们不会使用自节点的 Size, 关于此参数更详细的内容见本书后面关于 layout 原理的介绍
          parentUsesSize: false,
        );
      }
      return;
    }

    //子组件回到了屏幕中，重置通知状态
    _reported = false;

    // 测试 overlap ,下拉过程中 overlap 会一直变化.
    double overScroll = constraints.overlap < 0 ? constraints.overlap.abs() : 0;
    // 滚动时 scrollOffset 会一直变化
    var scrollOffset = constraints.scrollOffset;
    _direction = ScrollDirection.idle;

    var distance = overScroll > 0 // 是否下拉
        // 确定下拉的距离
        ? overScroll - _lastOverScroll
        // 确定滚动的距离
        : _lastScrollOffset - scrollOffset;
    _lastOverScroll = overScroll;
    _lastScrollOffset = scrollOffset;

    // 根据 distance 是否大于 0 确定下拉回弹或滚动方向。
    // 注意，不能直接使用 constraints.userScrollDirection，这是因为该参数只表示用户滑动操作的方向。
    // 比如当我们下拉超出边界时，然后松手，此时列表会弹回，即列表滚动方向是向上，而此时用户操作已经结束，ScrollDirection 的方向是上一次的用户滑动方向(向下)，这时便有问题。
    if (constraints.userScrollDirection == ScrollDirection.idle) {
      _direction = ScrollDirection.idle;
      _lastOverScroll = 0;
    } else if (distance > 0) {
      _direction = ScrollDirection.forward;
    } else if (distance < 0) {
      _direction = ScrollDirection.reverse;
    }

    // 在 Viewport 中顶部的可视空间为该 Sliver 可绘制的最大区域。
    // 1. 如果 Sliver 已经滑出可视区域，则 constraints.scrollOffset 会大于 _visibleExtent，这种情况我们在一开始就判断过了。
    // 2. 如果我们下拉超出了边界，此时 overScroll>0，scrollOffset 值为 0，所以最终的绘制区域为 _visibleExtent + overScroll.
    double paintExtent = _visibleExtent + overScroll - constraints.scrollOffset;
    // 绘制高度不超过最大可绘制空间
    paintExtent = min(paintExtent, constraints.remainingPaintExtent);

    // 对子组件进行 layout ，关于 layout 详细过程我们将在本书后面布局原理相关章节详细介绍，
    // 现在只需知道子组件通过 LayoutBuilder 可以拿到这里我们传递的约束对象（ExtraInfoBoxConstraints）
    // 对子组件进行布局，子组件通过 LayoutBuilder 可以拿到这里我们传递的约束对象 (ExtraInfoBoxConstraints)
    child!.layout(
      // 对子组件进行布局
      ExtraInfoBoxConstraints(
        _direction, // 传递滑动方向到 extra
        constraints.asBoxConstraints(maxExtent: paintExtent),
      ),
      parentUsesSize: false,
    );

    // 最大为 _visibleExtent ，最小为 0
    double layoutExtent = min(_visibleExtent, paintExtent);

    // 设置 geometry ，Viewport 在布局时会用到
    geometry = SliverGeometry(
      scrollExtent: _visibleExtent,
      paintOrigin: -overScroll,
      paintExtent: paintExtent,
      maxPaintExtent: paintExtent,
      layoutExtent: layoutExtent,
    );
  }
}
