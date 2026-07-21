// 数据模型：高校（University）
// 用于表示一所高校的基本信息，例如名称、城市、层次、录取位次等
import 'package:flutter/material.dart';

class University {
  const University({
    required this.name,
    required this.city,
    required this.level,
    required this.cutoffRank,
    required this.tags,
    required this.environment,
    required this.summary,
    required this.color,
  });

  final String name;
  final String city;
  final String level;
  final int cutoffRank;
  final List<String> tags;
  final String environment;
  final String summary;
  final Color color;
}
