// 应用路由路径的统一常量定义。
//
// 规范：
// - 所有动态路径参数使用 ":参数名" 语法，URL 可分享、刷新后恢复；
// - 跳转时通过路径参数（pathParameters）传参，extra 仅作补充数据槽；
// - 修改此处常量后，请确保路由配置（app_router.dart）与使用该常量的跳转逻辑同步更新。
class RoutePaths {
  // 私有构造函数，防止外部实例化，确保所有成员均为静态工具方法/常量
  RoutePaths._();

  /// 应用首页（根路径）
  /// 冷启动默认进入路径，命中 HomeShell 响应式布局。
  static const String home = '/';

  /// 高校详情页路径（语义化 id，如 xmu、suda 等）
  /// ':id' 为动态路径参数，对应 University.id。
  /// URL 示例：/university/xmu → 厦门大学详情页
  static const String universityDetail = '/university/:id';
}
