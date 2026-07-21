import 'package:flutter/material.dart';
// Flutter 核心 UI 库，提供 Material Design 组件（MaterialApp、Scaffold、AppBar 等）。
// 所有页面和 Widget 均构建在此包之上。

import 'package:get/get.dart';
// GetX 状态管理 & 依赖注入包。
// 本项目用它做：全局控制器注册、响应式状态（Obx/Rx）、路由（GetMaterialApp.router）。

// 全局路由配置，提供 appRouter 实例（GoRouter）
import 'router/app_router.dart';

// 全局初始化服务：负责 SharedPreferences、预加载高校数据、注册 ThemeController 等
import '../services/app_init_service.dart';

// 全局异常捕获工具：在 release 模式将未捕获异常转为可控日志，避免 App 崩溃白屏
import '../core/utils/error_util.dart';

// 主题控制器（GetX），持有可动态修改的种子色、背景色、全局标题
import '../theme/theme_controller.dart';

// 首页状态控制器（GetX），持有考生档案（省份、位次）和高校列表等全局状态
import '../controllers/home_controller.dart';

// Tab 索引控制器（GetX），记录当前底部/侧边导航选中的 Tab 序号
import '../controllers/tab_index_controller.dart';

/// 全局异步初始化启动函数。
/// 在 main() 中调用，是整个 App 启动链的起点。
Future<void> app() async {
  // 1. Flutter 引擎绑定：必须在调用任何 Flutter API（除静态成员）前执行。
  //    作用是确保 WidgetsFlutterBinding 已初始化，以便访问 Isolate、PlatformChannel 等底层能力。
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 注册全局异常处理器：将未捕获的 Flutter/Dart 异常通过 ErrorUtil 统一记录/上报。
  //    防止因偶发异常导致 App 直接崩溃显示白屏。
  ErrorUtil.initCatchError();

  // 3. 异步初始化全局配置：包括本地持久化存储（SharedPreferences）、
  //    预加载高校数据到 UniversityRegistry、注册 ThemeController 单例等。
  //    await 确保这些全局资源就绪后再进入 UI 渲染阶段。
  await AppInitService.instance.initGlobalConfig();

  // 4. 启动 Flutter 应用：传入根 Widget MyRootApp，开始渲染。
  runApp(const MyRootApp());
}

/// 根 Widget，即 runApp() 接收的入口 Widget。
/// 使用 StatelessWidget 因为所有动态 UI 变化均通过 GetX Obx 响应式驱动，无需自身状态。
class MyRootApp extends StatelessWidget {
  const MyRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 从 GetX 容器中取出 ThemeController 实例（AppInitService._registerGlobalService 已注册）。
    final ThemeController themeController = Get.find();

    // GetX 全局单例注册：将需要全局访问的 Controller 放入 GetX 容器。
    // HomeController：持有考生档案（province 省份、candidateRank 位次）和高校列表。
    // TabIndexController：记录当前选中的 Tab 索引，供 NavigationRail/BottomNav 共用。
    Get.put(HomeController());
    Get.put(TabIndexController());

    // GetX + GoRouter 混合路由模式：
    // GetMaterialApp.router 接收 GoRouter 的三个路由委托对象，
    // 使 GetX 的依赖注入能力与 GoRouter 的声明式路由能力共存。
    return Obx(
      () => GetMaterialApp.router(
        // GoRouter 的路由委托：负责根据 RouteInformation 构建页面 Widget 栈
        routerDelegate: appRouter.routerDelegate,
        // GoRouter 的路由信息解析器：负责将 URL 解析为内部路由状态
        routeInformationParser: appRouter.routeInformationParser,
        // GoRouter 的路由信息提供者：负责在路由变化时通知 routerDelegate
        routeInformationProvider: appRouter.routeInformationProvider,

        // 应用标题，即 Android Task 描述或 Web 标签页标题（动态响应主题变化）
        title: themeController.globalAppTitle.value,

        // Material Design 主题配置（响应式，Obx 包裹后随 Rx 变量自动重建）
        theme: ThemeData(
          // 从种子色（seedColor）自动生成完整的 ColorScheme（主色/次色/错误色等），
          // 保证所有 Material 组件配色协调一致。
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeController.defaultSeed.value,
          ),
          // 全局页面背景色（可由用户自定义主题色方案）
          scaffoldBackgroundColor: themeController.defaultBg.value,
          // 启用 Material 3（Material You）设计语言，控件样式更新、色彩系统更现代。
          useMaterial3: true,
        ),

        // 关闭 Debug 模式下右上角的 "DEBUG" 横幅（生产环境默认关闭，这里显式声明）
        debugShowCheckedModeBanner: false,
        // 全局页面切换动画使用 iOS 风格的 Cupertino 过渡（滑入/滑出）
        defaultTransition: Transition.cupertino,
      ),
    );
  }
}
