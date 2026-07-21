import 'package:flutter/material.dart';

class UniversityDetailPage extends StatelessWidget {
  const UniversityDetailPage({super.key, required this.universityId});

  final String universityId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 高校 ID 标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'ID: $universityId',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 占位信息卡片
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '高校详情页',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '开发中 - 数据加载功能待实现',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // 上方间距
                const SizedBox(height: 16),
                // 分隔线
                const Divider(),
                // 下方间距
                const SizedBox(height: 16),

                ..._buildInfoList(theme),
              ],
            ),
          ),
        ),
        // 卡片与说明文字之间的间距
        const SizedBox(height: 24),

        // 说明文字
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '高校数据将从 UniversityRegistry 加载，请等待数据源实现',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildInfoList(ThemeData theme) {
    return [
      _buildInfoRow('城市', '待加载', Icons.location_city, theme),
      _buildInfoRow('层次', '待加载', Icons.workspace_premium, theme),
      _buildInfoRow('录取位次', '待加载', Icons.bar_chart, theme),
    ];
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              '$label：',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
