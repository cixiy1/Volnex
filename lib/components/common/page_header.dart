import 'package:flutter/material.dart';

/// 通用页面顶部标题栏
///
/// 中文说明：
/// - 本组件用于各业务页面顶部的标题区，统一展示大标题、可选副标题、左侧前置图标与右侧动作区；
/// - 通过参数（如 `title`、`subtitle`、`leading`、`actions` 等）定制外观与行为，便于在应用中复用一致的页面头部样式；
/// - 推荐使用 PageHeader 代替各页面手写标题布局，以保持视觉与交互一致性。
///
/// 使用示例：
/// ```dart
/// PageHeader(title: '数据中心')
///
/// PageHeader(
///   title: '全国高校库',
///   subtitle: '收录院校、专业、分数线与校园生活信息',
///   spacing: 6,
/// )
///
/// PageHeader(
///   title: '志愿方案',
///   subtitle: '广东 · 全省位次 12345',
///   leading: Icon(Icons.auto_awesome),
///   actions: [IconButton(onPressed: _onShare, icon: const Icon(Icons.share))],
/// )
/// ```
class PageHeader extends StatelessWidget {
  /// 主标题（必填）
  final String title;

  /// 副标题（可选）
  final String? subtitle;

  /// 标题左侧前置组件（如图标），可选
  final Widget? leading;

  /// 标题右侧操作区组件列表（如按钮、菜单），可选
  final List<Widget>? actions;

  /// 标题与副标题之间的垂直间距
  final double spacing;

  /// 整体底部外间距（未传入 [padding] 时生效）
  final double bottomSpacing;

  /// 整体外边距；若提供则覆盖 [bottomSpacing]
  final EdgeInsetsGeometry? padding;

  /// 标题文本样式（默认 headlineMedium + 加粗）
  final TextStyle? titleStyle;

  /// 副标题文本样式（默认灰色）
  final TextStyle? subtitleStyle;

  /// 整体交叉轴对齐方式
  final CrossAxisAlignment alignment;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.spacing = 8,
    this.bottomSpacing = 18,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget titleWidget = Text(
      title,
      style: titleStyle ?? theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
    );

    return Padding(
      padding: padding ?? EdgeInsets.only(bottom: bottomSpacing),
      child: Column(
        crossAxisAlignment: alignment,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ...? (leading == null
                  ? null
                  : <Widget>[leading!, const SizedBox(width: 10)]),
              Expanded(child: titleWidget),
              ...? actions,
            ],
          ),
          ...? (subtitle == null
              ? null
              : <Widget>[
                  SizedBox(height: spacing),
                  Text(
                    subtitle!,
                    style: subtitleStyle ?? TextStyle(color: Colors.grey.shade700),
                  ),
                ]),
        ],
      ),
    );
  }
}
