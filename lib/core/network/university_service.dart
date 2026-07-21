// 网络层：高校数据服务（模拟请求）
//
// 说明：
// - 本文件提供高校数据的加载与查询能力，包��模拟网络请求和本地注册表；
// - 正式对接后只需替换 fetchUniversities() 的实现为真实的 HTTP 请求即可；
// - UniversityRegistry 作为全局数据缓存，供路由和详情页的同步查找使用。
import 'package:flutter/material.dart';
import 'package:volnex/models/university.dart';

/// 模拟网络延迟（毫秒）
///
/// 在真实应用中应替换为真实的网络请求，此处模拟 3 秒延迟以观察加载动画效果。
const int _kMockDelay = 3000;

/// 高校全局注册表
///
/// 提供同步的 id 查找能力，供路由 builder 与详情页使用。
/// 数据在 fetchUniversities() 调用后自动同步写入。
class UniversityRegistry {
  UniversityRegistry._();

  static final UniversityRegistry shared = UniversityRegistry._();

  final Map<String, University> _map = {};

  /// 初始化注册表（同步替换所有数据）
  void load(List<University> universities) {
    _map.clear();
    for (final u in universities) {
      _map[u.id] = u;
    }
  }

  /// 根据 id 查找高校，未找到返回 null
  University? findById(String id) => _map[id];

  /// 注册表是否已有数据（用于路由兜底判断）
  bool get hasData => _map.isNotEmpty;
}

/// 模拟从服务器获取高校列表
Future<List<University>> fetchUniversities() async {
  // 模拟网络请求耗时
  await Future<void>.delayed(const Duration(milliseconds: _kMockDelay));

  final universities = <University>[
    University(
      id: 'xmu',
      name: '厦门大学',
      city: '福建 · 厦门',
      level: '985 / 双一流',
      cutoffRank: 6800,
      tags: <String>['海滨校园', '人文社科', '综合'],
      environment: '依山傍海，主校区与白城沙滩相邻；绿化丰富，步行可达海边。',
      summary: '适合偏好海滨生活、综合性学科与开放校园氛围的考生。',
      color: const Color(0xff1E7A67),
    ),
    University(
      id: 'suda',
      name: '苏州大学',
      city: '江苏 · 苏州',
      level: '211 / 双一流',
      cutoffRank: 14600,
      tags: <String>['园林城市', '医学', '综合'],
      environment: '多个校区融入古城与园林环境，生活配套成熟，通勤便利。',
      summary: '适合重视城市生活品质、医学与材料等优势专业的考生。',
      color: const Color(0xff8E5A30),
    ),
    University(
      id: 'szu',
      name: '深圳大学',
      city: '广东 · 深圳',
      level: '省属重点',
      cutoffRank: 22600,
      tags: <String>['现代校园', '科技', '就业'],
      environment: '现代化山海校园，宿舍和运动设施较新，毗邻科技产业集群。',
      summary: '适合意向互联网、工程与希望在大湾区就业的考生。',
      color: const Color(0xff3B6FB6),
    ),
    University(
      id: 'ouc',
      name: '中国海洋大学',
      city: '山东 · 青岛',
      level: '985 / 双一流',
      cutoffRank: 10500,
      tags: <String>['海景', '海洋科学', '安静'],
      environment: '崂山校区山海相映，校园安静，适合专注学习与户外运动。',
      summary: '海洋、水产、食品等学科特色突出，校园节奏舒适。',
      color: const Color(0xff276E9E),
    ),
    University(
      id: 'swu',
      name: '西南大学',
      city: '重庆 · 北碚',
      level: '211 / 双一流',
      cutoffRank: 29800,
      tags: <String>['山地校园', '师范', '农业'],
      environment: '依山而建、植被茂盛，校园规模大，四季景观分明。',
      summary: '师范、心理、农学优势明显，生活成本相对友好。',
      color: const Color(0xff8D5D27),
    ),
    University(
      id: 'nuist',
      name: '南京信息工程大学',
      city: '江苏 · 南京',
      level: '双一流',
      cutoffRank: 44000,
      tags: <String>['花园校园', '气象', '工科'],
      environment: '校园开阔、绿地和湖景丰富；住宿集中，生活区配套完善。',
      summary: '大气科学全国领先，适合关注气象、计算机和电子信息的考生。',
      color: const Color(0xff7950A0),
    ),
  ];

  // 同步写入注册表，确保路由查找可用
  UniversityRegistry.shared.load(universities);

  return universities;
}
