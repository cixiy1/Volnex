// 数据模型：高校（University）
// 用于表示一所高校的基本信息，例如名称、城市、层次、录取位次等
import 'package:flutter/material.dart';

/// University
///
/// 中文说明：高校数据模型，包含高校的基本信息与展示相关的字段。
/// 该模型通常从网络服务加载，存储在 HomeController 的 universities 列表中。
class University {
  const University({
    required this.id,
    required this.name,
    required this.city,
    required this.level,
    required this.cutoffRank,
    required this.tags,
    required this.environment,
    required this.summary,
    required this.color,
  });

  /// 高校唯一标识符，用于 URL 路径参数（如 /university/xmu）与数据库查询。
  final String id;

  /// 高校名称（例如"厦门大学"）
  final String name;

  /// 所在城市（例如"厦门"）
  final String city;

  /// 高校层次分类（例如"985""211""普通本科"等）
  final String level;

  /// 该高校前一年或多年的最低录取位次（用于与考生位次比较推荐）
  final int cutoffRank;

  /// 高校特色标签集合（例如["海滨校园""园林城市"]）
  final List<String> tags;

  /// 简短的校园环境描述
  final String environment;

  /// 对该高校的总体评价或推荐说明
  final String summary;

  /// 高校品牌色（用于卡片与 UI 中的视觉识别）
  final Color color;
}
