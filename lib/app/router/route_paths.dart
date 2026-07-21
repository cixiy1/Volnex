// 应用路由路径的统一常量定义。
//
// 规范：
// - 所有动态路径参数使用 ":参数名" 语法，URL 可分享、刷新后恢复；
// - 跳转时通过路径参数（pathParameters）传参，extra 仅作补充数据槽；
// - 修改此处常量后，请确保路由配置（app_router.dart）与使用该常量的跳转逻辑同步更新。
class RoutePaths {
  RoutePaths._();

  /// 应用首页（根路径）
  static const String home = '/';

  /// 高校详情页路径（语义化 id，如 xmu、suda 等）
  static const String universityDetail = '/university/:id';
}
