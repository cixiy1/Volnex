// 应用的路由配置。提供单一导出的 `appRouter` 实例。
//
// 说明：
// - 本文件集中配置全应用的路由规则，使用 go_router 包实现声明式路由；
// - 每个 GoRoute 映射一个 URL path 到对应的页面 Widget；
// - 在 `lib/app/app.dart` 中被 `GetMaterialApp.router` 使用，作为应用的导航引擎。
import 'package:flutter/material.dart';
// Flutter UI 核心库，提供 BuildContext、GoRouterState 等路由构建所需的上下文类型。

import 'package:go_router/go_router.dart';
// GoRouter：声明式路由管理包，支持路径参数、嵌套路由、URL 分享、深度链接等能力。

// 路由路径常量集中管理，避免硬编码字符串（如 '/university/:id'）
import 'package:volnex/app/router/route_paths.dart';

// 首页外壳布局：包含响应式 NavigationRail（宽屏）/ BottomNav（窄屏）以及 4 个 Tab 内容区
import 'package:volnex/components/layout/home_shell.dart';

/// 全局唯一的 GoRouter 实例。
/// initialLocation 指定应用冷启动时默认进入的路径；
/// routes 列表定义所有已注册路由（路径 → Widget 映射）。
final GoRouter appRouter = GoRouter(
  // 应用冷启动默认路径，即首页（根路径 '/'）
  initialLocation: RoutePaths.home,

  // 路由表：按声明顺序匹配，路径命中后执行对应 builder 返回 Widget
  routes: <GoRoute>[
    // 首页路由：路径为根路径 '/'，对应 HomeShell 响应式布局（4 Tab）
    GoRoute(
      // 使用 RoutePaths.home 常量（'/')，保持路径常量一处管理
      path: RoutePaths.home,
      // 命名路由标识，可通过 context.goNamed('home') 进行编程式跳转
      name: 'home',
      // builder：路径匹配后调用此工厂函数，生成实际页面 Widget
      builder: (BuildContext context, GoRouterState state) => const HomeShell(),
    ),
  ],
);
