// 应用的路由配置。提供单一导出的 `appRouter` 实例
//
// 说明：
// - 本文件集中配置全应用的路由规则，使用 go_router 包实现声明式路由；
// - 每个 GoRoute 映射一个 URL path 到对应的页面 Widget；
// - 在 `lib/app/app.dart` 中被 `GetMaterialApp.router` 使用，作为应用的导航引擎。
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:volnex/app/router/route_paths.dart';
import 'package:volnex/pages/app/university_detail_page.dart';

import 'package:volnex/components/layout/home_shell.dart';

// 全局路由实例
final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: <GoRoute>[
    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (BuildContext context, GoRouterState state) => const HomeShell(),
    ),
    GoRoute(
      path: RoutePaths.universityDetail,
      name: 'universityDetail',
      builder: (BuildContext context, GoRouterState state) {
        final universityId = state.pathParameters['id'];
        return UniversityDetailPage(universityId: universityId);
      },
    ),
  ],
);
