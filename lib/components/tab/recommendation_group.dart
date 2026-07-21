// 推荐分组组件：展示每个分组的标题与高校卡片列表
//
// 说明：
// - 在智能推荐页中，按"冲/稳/保"分组展示院校列表，每组由本组件负责渲染标题与若干 `UniversityCard`；
// - 组件接收当前考生位次 `candidateRank`，并将其传递给每个卡片以计算标签（冲/稳/保）；
// - 该组件是纯展示型的 StatelessWidget，所有必要数据在构造时传入，便于测试与复用。
//
// 使用示例：
// ```dart
// RecommendationGroup(
//   title: '冲一冲',
//   color: Colors.red,
//   universities:冲刺列表,
//   candidateRank: 12000,
// )
// ```

// Flutter 核心 UI 库，提供 StatelessWidget、Column、Text、SizedBox 等基础组件
import 'package:flutter/material.dart';

// 高校数据模型，包含 id、name、city、level、environment、tags 等字段
import 'package:volnex/models/university.dart';

// 高校卡片组件，负责渲染单个学校的卡片布局（名称、城市、标签、推荐标签等）
import 'package:volnex/components/common/university_card.dart';

/// RecommendationGroup
///
/// 中文说明：
/// - 渲染一个推荐分组块，包含分组标题、若干高校卡片与底部间距；
/// - 该组件是纯展示型的 StatelessWidget，所有必要数据在构造时传入，便于测试与复用。
///
/// 布局结构（Column）：
/// - 第一行：分组标题 Text（使用传入的 color 和 fontWeight）
/// - 第二行：SizedBox(height: 10) 分隔间距
/// - 后续行：各高校的 UniversityCard（通过 map 展开）
/// - 最后一行：SizedBox(height: 12) 底部间距
class RecommendationGroup extends StatelessWidget {
  const RecommendationGroup({
    super.key,
    required this.title, // 分组标题文案，例如"冲一冲"、"稳一稳"、"保一保"
    required this.color, // 分组主色，用于标题染色以强调视觉区分
    required this.universities, // 当前分组包含的高校列表
    required this.candidateRank, // 考生全省位次，传递给卡片用于计算冲/稳/保标签
  });

  /// 分组标题文案，用于标识分组类型（冲/稳/保）或个人策略标签
  final String title;

  /// 分组主色（用于标题染色以强调视觉区分）
  /// - 冲刺组通常使用红色系
  /// - 稳妥组通常使用橙色/黄色系
  /// - 保底组通常使用绿色系
  final Color color;

  /// 当前分组包含的高校列表，类型为 `List<University>`
  final List<University> universities;

  /// 考生全省位次，传递给 UniversityCard 用于计算推荐标签（冲/稳/保）
  final int candidateRank;

  @override
  Widget build(BuildContext context) => Column(
    // 列内所有元素左对齐
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // 分组标题：使用传入的 color（主题色）加粗显示，字号 20 突出分组层级
      Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      // 标题与卡片列表之间的垂直间距（10px）
      const SizedBox(height: 10),
      // 通过 List.map 将高校列表展开为 UniversityCard 列表，
      // 使用展开运算符 ... 将列表中的每个元素依次插入父 Column 的 children
      ...universities.map(
        (University university) => UniversityCard(
          university: university,
          // 将考生位次传递给卡片，使卡片能正确计算冲/稳/保标签
          candidateRank: candidateRank,
        ),
      ),
      // 分组底部间距（12px），为下一个分组或页面底部留出空白
      const SizedBox(height: 12),
    ],
  );
}
