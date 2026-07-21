// 应用的路由配置。提供单一导出的 `appRouter` 实例。
//
// 说明：
// - 本文件集中配置全应用的路由规则，使用 go_router 包实现声明式路由；
// - 每个 GoRoute 映射一个 URL path 到对应的页面 Widget；
// - 在 `lib/app/app.dart` 中被 `GetMaterialApp.router` 使用，作为应用的导航引擎。

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
// GoRouter：声明式路由管理包，支持路径参数、嵌套路由、URL 分享、深度链接等能力。

// 路由路径常量集中管理，避免硬编码字符串
import 'package:volnex/app/router/route_paths.dart';

// 页面外壳布局
import 'package:volnex/components/layout/home_shell.dart';
import 'package:volnex/components/layout/university_detail_shell.dart';

/// 全局唯一的 GoRouter 实例。initialLocation 指定应用冷启动时默认进入的路径；
/// routes 列表定义所有已注册路由（路径 → Widget 映射）。
final GoRouter appRouter = GoRouter(
  // 应用冷启动默认路径，即首页（根路径 '/'）
  initialLocation: RoutePaths.home,

  // 调试模式：打印路由日志
  // debugLogDiagnostics: true,

  // 错误处理：当路由未匹配时跳转到首页
  errorBuilder: (BuildContext context, GoRouterState state) {
    if (kDebugMode) {
      print('路由错误: ${state.matchedLocation}, 错误信息: ${state.error}');
    }
    return const HomeShell();
  },

  // 路由表：按声明顺序匹配，路径命中后执行对应 builder 返回 Widget
  routes: <GoRoute>[
    // 首页路由：路径为根路径 '/'
    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (BuildContext context, GoRouterState state) => const HomeShell(),
    ),
    // 院校详情
    GoRoute(
      path: RoutePaths.universityDetail,
      name: 'universityDetail',
      builder: (BuildContext context, GoRouterState state) {
        // 从 URL 路径参数中提取 ':id'，如 '/university/xmu' → universityId = 'xmu'
        final universityId = state.pathParameters['id'] ?? '';
        // 将 id 传递给 UniversityDetailShell，由该页面负责从 UniversityRegistry 查询完整数据
        return UniversityDetailShell(universityId: universityId);
      },
    ),
  ],
);
