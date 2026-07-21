// 应用的路由配置。提供单一导出的 `appRouter` 实例
// 在 `lib/app/app.dart` 中被 `GetMaterialApp.router` 使用。
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:volnex/app/router/route_paths.dart';

import 'package:volnex/components/layout/home_shell.dart';
import 'package:volnex/pages/app/home_tab/university_library_page.dart';
import 'package:volnex/pages/app/home_tab/settings_page.dart';
// Note: university_detail_page is not directly routed here; remove unused import to avoid warnings

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
      path: RoutePaths.library,
      name: 'library',
      // 指向实际的高校库页面实现
      builder: (BuildContext context, GoRouterState state) => const UniversityLibraryPage(),
    ),
    GoRoute(
      path: RoutePaths.settings,
      name: 'settings',
      builder: (BuildContext context, GoRouterState state) => const SettingsPage(),
    ),
  ],
);
