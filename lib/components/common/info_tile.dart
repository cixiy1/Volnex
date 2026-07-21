// 信息条目组件：在详情页中复用的卡片样式（图标 + 标题 + 描述）
//
// 说明：
// - 简单封装的 ListTile 卡片，用于在详情页展示项目信息（例如“住宿与生活”“食堂与配套”等）；
// - 通过 icon/title/text 三个必需参数构造，样式固定以保证界面风格一致。
import 'package:flutter/material.dart';

/// InfoTile
///
/// 中文说明：渲染一个带图标的卡片列表项，标题加粗，正文有上间距，常用于详情页的信息块。
class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  /// 左侧图标
  final IconData icon;

  /// 条目标题
  final String title;

  /// 条目正文描述
  final String text;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          // 使用应用主色调的深绿色作为图标颜色以保持风格统一
          leading: Icon(icon, color: const Color(0xff156B5B)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          // 在 subtitle 上增加顶部内边距让视觉更通透
          subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(text)),
        ),
      );
}
