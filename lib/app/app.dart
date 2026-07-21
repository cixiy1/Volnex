import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 全局路由
import 'router/app_router.dart';
// 全局初始化服务
import '../services/app_init_service.dart';
// 全局异常捕获工具
import '../core/utils/error_util.dart';
// 主题控制器（GetX）
import '../theme/theme_controller.dart';
// 首页状态控制器（GetX）
import '../controllers/home_controller.dart';
// Tab 索引控制器（GetX）
import '../controllers/tab_index_controller.dart';

// 全局初始化启动函数
Future<void> app() async {
  // 1. Flutter引擎绑定，必须放最前
  WidgetsFlutterBinding.ensureInitialized();
  // 2. 全局异常捕获
  ErrorUtil.initCatchError();
  // 3. 异步初始化存储、第三方SDK、全局服务
  await AppInitService.instance.initGlobalConfig();

  runApp(const MyRootApp());
}

class MyRootApp extends StatelessWidget {
  const MyRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    // 应用级 GetX 单例注册
    Get.put(HomeController());
    Get.put(TabIndexController());

    // GetX + GoRouter 路由模式
    return Obx(() => GetMaterialApp.router(
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,

      title: themeController.globalAppTitle.value,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeController.defaultSeed.value,
        ),
        scaffoldBackgroundColor: themeController.defaultBg.value,
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
    ));
  }
}
