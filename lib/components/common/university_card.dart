// 高校卡片组件：用于在列表中展示学校摘要信息，点击可进入详情页
//
// 说明：
// - 本组件在高校列表与推荐分组中复用，展示学校名称、城市、校区概览、标签以及基于考生位次的推荐标签（冲/稳/保）；
// - 点击卡片会导航到高校详情页，路由路径为 `/university/:id`（由 GoRouter 提供路由管理）。
// - 推荐标签（冲/稳/保）的计算逻辑在组件内部实现，基于学校录取位次与考生位次的差值。

// Flutter 核心 UI 库，提供 Card、InkWell、Row、Column、Text、Chip 等组件
import 'package:flutter/material.dart';

// GoRouter 路由库，用于在点击卡片时执行客户端路由导航（push 操作）
import 'package:go_router/go_router.dart';

// 高校数据模型，包含 id、name、city、level、environment、tags、cutoffRank、color 等字段
import 'package:volnex/models/university.dart';

/// UniversityCard
///
/// 中文说明：渲染单个高校的卡片项，包含主标题、城市/层次、简短环境描述与若干标签。
///
/// 卡片布局（Row 结构）：
/// - 左侧：48x48 的彩色方块（使用 university.color 作为背景色）内置学校图标
/// - 中间（Expanded）：学校名称 + 推荐标签、城市/层次、环境描述、标签流
/// - 右侧： chevron_right 箭头图标，提示用户可点击进入详情
///
/// 交互：
/// - InkWell 包裹整张卡片，实现触控反馈（水波纹效果）；
/// - borderRadius: 12 与 Card 的圆角保持一致；
/// - onTap 触发 GoRouter 导航至 `/university/${university.id}`。
class UniversityCard extends StatelessWidget {
  const UniversityCard({
    super.key,
    required this.university, // 要展示的高校数据模型，必填
    required this.candidateRank, // 考生在省内的位次，用于计算推荐标签（冲/稳/保）
  });

  /// 要展示的高校数据模型，类型为 University（定义在 models/university.dart）
  final University university;

  /// 考生在省内的位次（来自 HomeController），用于计算 delta 并确定推荐标签
  final int candidateRank;

  @override
  Widget build(BuildContext context) {
    // 计算学校录取位次与考生位次的差值，用于判断推荐标签。
    // delta > 0：学校录取位次高于考生位次（即考生更容易被录取）
    // delta < 0：学校录取位次低于考生位次（即考生排名更靠前，需要"冲刺"）
    final int delta = university.cutoffRank - candidateRank;

    // 根据差值范围确定标签（冲/稳/保），
    // 具体阈值（-2500 / 5000）是基于高考志愿填报经验值设定：
    // - delta < -2500：学校录取位次比考生位次低超过 2500 名 → 考生排名更靠前，属于"冲刺"选项
    // - delta > 5000：学校录取位次比考生位次高超过 5000 名 → 考生排名更靠前，属于"保底"选项
    // - 其他情况（-2500 ~ 5000）：位次接近，视为"稳妥"选择
    final String label = delta < -2500
        ? '冲刺'
        : delta > 5000
        ? '保底'
        : '稳妥';

    // Card 提供卡片容器，包含默认圆角、阴影和边距，适合在列表中作为条目展示
    return Card(
      // 底部外边距（12px），与列表中其他卡片保持一致的垂直间距
      margin: const EdgeInsets.only(bottom: 12),
      // InkWell 提供触控反馈：点击时显示 Material Design 水波纹动画
      child: InkWell(
        // 圆角与 Card 默认圆角保持一致，确保水波纹在圆角范围内
        borderRadius: BorderRadius.circular(12),
        // 点击卡片跳转到详情页，传递学校 id 作为路由路径参数
        onTap: () => context.push('/university/${university.id}'),
        // 卡片内部内容：16px 内边距
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            // 子项在交叉轴（竖直方向）顶部对齐，保证标题与内容对齐
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 左侧：彩色方块作为学校标识
              // 使用 university.color（学校主题色）作为背景，增强视觉区分度
              Container(
                width: 48, // 固定宽度 48px
                height: 48, // 固定高度 48px，与宽度相同形成正方形
                decoration: BoxDecoration(
                  // 学校主题色（如蓝色/绿色/橙色等），使不同学校在列表中更易区分
                  color: university.color,
                  // 圆角 14px，略大于正方形，营造柔和卡片感
                  borderRadius: BorderRadius.circular(14),
                ),
                // 方块内放置银行/学校图标，白色与背景色形成对比
                child: const Icon(Icons.account_balance, color: Colors.white),
              ),
              const SizedBox(width: 14), // 左侧标识与中间内容之间的水平间距
              // 中间 Expanded 区域：占据剩余宽度，包含所有文本和标签信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
                  children: <Widget>[
                    // 第一行：学校名称 + 推荐标签（冲/稳/保）
                    Row(
                      children: <Widget>[
                        // 学校名称，占据左侧剩余空间（Expanded）
                        Expanded(
                          child: Text(
                            university.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, // 加粗突出学校名
                              fontSize: 17, // 略大于正文字号
                            ),
                          ),
                        ),
                        // 推荐标签 Chip：冲/稳/保，颜色由系统 Chip 默认着色
                        Chip(
                          label: Text(label),
                          // compact 紧凑密度，减小 Chip 的垂直高度
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    // 第二行：城市 + 院校层次（如"本科一批"等）
                    Text(
                      '${university.city} · ${university.level} · 最低位次 ${university.cutoffRank} 位',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8), // 城市信息与校园描述之间的间距
                    // 第三行：简短的校园环境描述，限制最多 2 行，超出部分用省略号截断
                    Text(
                      university.environment,
                      maxLines: 2, // 最多显示 2 行
                      overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                    ),
                    const SizedBox(height: 10), // 环境描述与标签之间的间距
                    // 第四行：标签集合（如"海滨校园""985""211"等）
                    Wrap(
                      spacing: 6, // 标签之间的水平间距
                      runSpacing: 6, // 换行后标签之间的垂直间距
                      // 将大学 tags 列表映射为 Chip Widget 列表
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

              // 右侧：chevron_right 箭头图标，提示用户可点击进入详情页
              Icon(Icons.chevron_right, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}
