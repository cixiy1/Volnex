// 信息条目组件：在详情页中复用的卡片样式（图标 + 标题 + 描述）
//
// 说明：
// - 简单封装的 ListTile 卡片，用于在详情页展示项目信息（例如"住宿与生活""食堂与配套"等）；
// - 通过 icon/title/text 三个必需参数构造，样式固定以保证界面风格一致。
// - 使用 Card 包裹 ListTile，提供统一的圆角与阴影，适合在滚动列表中展示。

// Flutter 核心 UI 库，提供 Card、ListTile、Icon、Text 等 Material Design 组件
import 'package:flutter/material.dart';

/// InfoTile
///
/// 中文说明：渲染一个带图标的卡片列表项，标题加粗，正文有上间距，常用于详情页的信息块。
///
/// 使用示例：
/// ```dart
/// InfoTile(
///   icon: Icons.hotel,
///   title: '住宿与生活',
///   text: '4人间，上床下桌，独立卫浴...',
/// )
/// ```
///
/// 设计意图：
/// - icon 提供视觉锚点，帮助用户快速识别信息类别；
/// - title 加粗突出信息主题；
/// - text 作为正文描述，配合 subtitle 的上间距增加可读性。
class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon, // 左侧图标（必填），用于表示信息类别
    required this.title, // 条目标题（必填），突出信息主题
    required this.text, // 条目正文描述（必填），提供详细信息
  });

  /// 左侧图标，通常为 Icons 中的 Material 图标
  final IconData icon;

  /// 条目标题，样式为加粗字体
  final String title;

  /// 条目正文描述，位于标题下方
  final String text;

  @override
  // 使用表达式函数体简化 build 方法，直接返回 Card Widget
  Widget build(BuildContext context) => Card(
    // Card 默认带有圆角和阴影，适合在列表中作为信息条目容器
    child: ListTile(
      // leading 区域放置图标，使用应用主色调（深绿色）保持视觉统一
      leading: Icon(icon, color: const Color(0xff156B5B)),
      // 标题文本，加粗样式突出信息主题
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      // 副标题区域显示正文描述，通过 Padding 增加顶部间距（top: 6）提升可读性
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(text),
      ),
    ),
  );
}
