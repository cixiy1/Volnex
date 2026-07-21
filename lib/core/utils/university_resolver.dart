// 高校详情解析器
//
// 只接受 universityId，返回完整的 University 对象。
// 数据来源：UniversityRegistry（全项目共享，已在 AppInitService 初始化时预加载）。
//
// 使用方式：
//   final university = resolveUniversity(id);
//   if (university == null) { /* 回退首页 */ }
import 'package:volnex/models/university.dart';
import 'package:volnex/core/network/university_service.dart';

/// 根据 universityId 解析高校详情
///
/// [id] — URL 路径参数 id，如 xmu、suda、szu 等
///
/// 从 UniversityRegistry 同步查找，找到返回 University 对象，否则返回 null。
University? resolveUniversity(String? id) {
  // 防御性检查：空 id 直接返回 null，避免注册表查询出错
  if (id == null || id.isEmpty) return null;
  return UniversityRegistry.shared.findById(id);
}
