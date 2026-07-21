// 高校卡片组件：用于在列表中展示学校摘要信息，点击可进入详情页
//
// 说明：
// - 本组件在高校列表与推荐分组中复用，展示学校名称、城市、校区概览、标签以及基于考生位次的标签（冲/稳/保）；
// - 点击卡片会导航到高校详情页，路由路径为 `/university/:id`（请确保路由配置与该约定一致）。
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:volnex/models/university.dart';

/// UniversityCard
///
/// 中文说明：渲染单个高校的卡片项，包含主标题、城市/层次、简短环境描述与若干标签。
class UniversityCard extends StatelessWidget {
  const UniversityCard({
    super.key,
    required this.university,
    required this.candidateRank,
  });

  /// 要展示的高校数据模型
  final University university;

  /// 考生在省内的位次，用于计算推荐标签（冲/稳/保）
  final int candidateRank;

  @override
  Widget build(BuildContext context) {
    // 计算学校录取位次与考生位次的差值，用于判断推荐标签
    final int delta = university.cutoffRank - candidateRank;

    // 根据差值范围确定标签（冲/稳/保）
    // 如果 delta < -2500，说明学校位次低（更容易），标签为"冲刺"
    // 如果 delta > 5000，说明学校位次高（更容易上岸），标签为"保底"
    // 其他情况标签为"稳妥"（位次接近）
    final String label = delta < -2500
        ? '冲刺'
        : delta > 5000
            ? '保底'
            : '稳妥';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // 点击卡片跳转到详情页，传递学校 id（路由使用 path 参数）
        onTap: () => context.push('/university/${university.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 彩色方块作为学校标识（使用学校主题色）
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: university.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.account_balance, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            university.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        // 推荐标签（冲/稳/保）
                        Chip(
                          label: Text(label),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    // 城市与院校层次信息
                    Text(
                      '${university.city} · ${university.level}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    // 简短的校园环境描述（限制行数并省略超出部分）
                    Text(
                      university.environment,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    // 标签集合（如“海滨校园”等）
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: university.tags
                          .map(
                            (String tag) => Chip(
                              label: Text(tag),
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}
