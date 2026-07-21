// 推荐分组组件：展示每个分组的标题与高校卡片列表
//
// 说明：
// - 在智能推荐页中，按“冲/稳/保”分组展示院校列表，每组由本组件负责渲染标题与若干 `UniversityCard`。
// - 组件接收当前考生位次 `candidateRank`，并将其传递给每个卡片以计算标签（冲/稳/保）。
import 'package:flutter/material.dart';
import 'package:volnex/models/university.dart';
import 'package:volnex/components/common/university_card.dart';

/// RecommendationGroup
///
/// 中文说明：
/// - 渲染一个推荐分组块，包含分组标题、若干高校卡片与底部间距；
/// - 该组件是纯展示型的 StatelessWidget，所有必要数据在构造时传入，便于测试与复用。
class RecommendationGroup extends StatelessWidget {
  const RecommendationGroup({
    super.key,
    required this.title,
    required this.color,
    required this.universities,
    required this.candidateRank,
  });

  /// 分组标题文案，例如“冲一冲”、“稳一稳”、“保一保”
  final String title;

  /// 分组主色（用于标题染色以强调区分）
  final Color color;

  /// 当前分组包含的高校列表
  final List<University> universities;

  /// 考生全省位次，传递给卡片用于计算标签与展示
  final int candidateRank;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 标题（加粗并使用传入颜色以突出分组）
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 10),
          // 展示每个高校的卡片，使用展开运算符将列表扁平插入
          ...universities.map((University university) => UniversityCard(university: university, candidateRank: candidateRank)),
          const SizedBox(height: 12),
        ],
      );
}
