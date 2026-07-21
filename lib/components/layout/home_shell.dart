// 布局壳（HomeShell）
//
// 该文件定义应用的顶层布局容器，包含：
// - 顶部 AppBar（标题、应用图标、动作按钮）
// - 主内容区（根据 TabIndexController 显示不同页面）
// - 根据可用宽度选择侧边栏导航（NavigationRail）或底部导航（NavigationBar）
//
// 实现要点：
// - 使用 GetX 的依赖查找（Get.find）来获取 `TabIndexController` 与 `HomeController`。
// - 使用响应式组件 `Obx` 监听 `ctrl.currentIndex` 的变化并自动切换页面。
// - 使用 `LayoutBuilder` 判断屏幕宽度（阈值 880）来决定使用窄屏布局（底部导航）还是宽屏布局（侧栏 + 内容区）。
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:volnex/controllers/home_controller.dart';
import 'package:volnex/controllers/tab_index_controller.dart';

import 'package:volnex/components/common/profile_sheet.dart';
import 'package:volnex/components/tab/home_tab.dart';

import 'package:volnex/pages/app/home_tab/recommendation_page.dart';
import 'package:volnex/pages/app/home_tab/university_library_page.dart';
import 'package:volnex/pages/app/home_tab/data_hub_page.dart';
import 'package:volnex/pages/app/home_tab/settings_page.dart';

/// HomeShell
///
/// 顶层布局组件（StatelessWidget）。它根据屏幕宽度选择不同的导航展现方式：
/// - 宽屏（maxWidth >= 880）：左侧显示 `HomeTabView` (NavigationRail)，右侧显示页面内容
/// - 窄屏：使用底部 `HomeTabBar` (NavigationBar) 并直接显示当前页面内容
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取 TabIndexController：负责维护当前选中的 tab 索引（RxInt）
    final TabIndexController tabCtrl = Get.find<TabIndexController>();

    // pages 列表定义了每个 tab 对应的页面组件，顺序需与导航项保持一致
    // 注意：不要将非 const 的 Widget 放入 const 列表，会导致编译错误。
    // 这里将列表设为运行时构建以避免 const 限制，同时各页面的构造函数仍可为 const
    final List<Widget> pages = <Widget>[
      RecommendationPage(),
      UniversityLibraryPage(),
      DataHubPage(),
      SettingsPage(),
    ];

    // 使用 LayoutBuilder 根据父容器约束决定布局（宽屏/窄屏）
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 当宽度 >= 880 时视为宽屏，使用侧边栏导航；否则使用底部导航
        final bool wide = constraints.maxWidth >= 880;

        return Scaffold(
          // 顶部 AppBar：包含应用 Logo、应用名与“我的档案”按钮
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Row(children: <Widget>[
              // 圆形图标作为应用 Logo
              CircleAvatar(backgroundColor: Color(0xff156B5B), child: Icon(Icons.auto_awesome, color: Colors.white, size: 18)),
              SizedBox(width: 10),
              // 主标题（应用名）
              Text('Volnex', style: TextStyle(fontWeight: FontWeight.w800)),
              SizedBox(width: 8),
              // 副标题（应用描述）
              Text('高考志愿助手', style: TextStyle(fontSize: 14)),
            ]),
            actions: <Widget>[
              // 点击打开个人档案弹窗（ProfileSheet）
              TextButton.icon(
                onPressed: () => _showProfile(context),
                icon: const Icon(Icons.person_outline),
                label: const Text('我的档案'),
              ),
              const SizedBox(width: 12),
            ],
          ),

          // 主体内容：宽屏使用 Row 将侧边导航与内容区并排显示，窄屏直接显示内容
          body: wide
              ? Row(children: <Widget>[
                  // 侧边导航（NavigationRail 封装在 HomeTabView 中）
                  const HomeTabView(),
                  const VerticalDivider(width: 1),
                  // 内容区使用 IndexedStack 来保留每个页面的 State（不会在切换时销毁）
                  Expanded(
                      child: Obx(() => IndexedStack(
                            index: tabCtrl.currentIndex.value,
                            children: pages,
                          ))),
                ])
              : Obx(() => IndexedStack(
                  index: tabCtrl.currentIndex.value,
                  children: pages,
                )),

          // 底部导航栏：仅在窄屏时显示（wide == false）
          bottomNavigationBar: wide ? null : const HomeTabBar(),
        );
      },
    );
  }

  /// 打开“我的档案”弹窗并处理返回结果
  ///
  /// 逻辑：
  /// - 通过 Get.find 获取 `HomeController`（包含用户档案信息）
  /// - 调用 `ProfileSheet.show` 弹出底部面板，传入当前的省份与排位作为初始值
  /// - 若用户在面板中确认并返回结果，则调用控制器的 `updateProfile` 更新数据
  Future<void> _showProfile(BuildContext context) async {
    // 获取 HomeController，用于读取与更新用户档案信息
    final HomeController ctrl = Get.find<HomeController>();

    // 弹出 profile 面板并等待用户输入结果
    final result = await ProfileSheet.show(
      context,
      initialProvince: ctrl.province.value,
      initialRank: ctrl.candidateRank.value,
    );

    // 如果用户有返回（非取消），结果为 Tuple2(province, candidateRank)
    if (result != null) {
      // 使用返回的值更新控制器中的档案信息
      ctrl.updateProfile(province: result.$1, candidateRank: result.$2);
    }
  }
}
