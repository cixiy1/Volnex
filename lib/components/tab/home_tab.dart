// Tab 导航组件：封装 NavigationRail（用于宽屏/侧边栏）与 NavigationBar（用于窄屏/底部）
// 通过 GetX 的控制器 `TabIndexController` 管理当前选中索引，并通过响应式 Obx 自动更新 UI
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volnex/controllers/tab_index_controller.dart';
import 'package:material_symbols_icons/symbols.dart';

/// HomeTabView
///
/// 宽屏或侧边栏场景下使用的导航组件，基于 Flutter 的 [NavigationRail]。
///
/// 功能说明：
/// - 从 GetX 服务中获取 `TabIndexController`（使用 `Get.find<TabIndexController>()`），
///   以读取当前选中索引并提供切换回调。
/// - 使用 `Obx` 将 NavigationRail 包裹为响应式组件，当控制器中的 `currentIndex` 变化时自动重建。
/// - destinations 列表中定义了三个导航项（智能填报、高校库、设置），
///   分别提供未选中与选中时的 icon，以及文本标签。

/// - 宽屏（maxWidth >= 880）：左侧显示 `HomeTabView` (NavigationRail)，右侧显示页面内容
/// - 窄屏：使用底部 `HomeTabBar` (NavigationBar) 并直接显示当前页面内容
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // 从 GetX 容器中查找已注册的 TabIndexController 实例。
    // 要求在应用初始化阶段已通过 Get.put 或类似方法将控制器注册到依赖管理中。
    final TabIndexController ctrl = Get.find<TabIndexController>();

    // 使用 Obx 创建响应式 UI：当 ctrl.currentIndex.value 改变时，NavigationRail 会重新构建并反映最新选中项。
    return Obx(() => NavigationRail(
          // 当前选中的索引由控制器的 currentIndex 提供（RxInt）。
          selectedIndex: ctrl.currentIndex.value,

          // 当用户在 NavigationRail 上选择某项时，调用控制器的 select 方法进行处理（通常会更新 currentIndex）。
          onDestinationSelected: ctrl.select,

          // 始终显示标签（选中与未选中都显示）。可以根据需要改为 selected 仅或 none。
          labelType: NavigationRailLabelType.all,

          // 导航目的地列表：每一项使用 NavigationRailDestination 指定 icon、selectedIcon、label。
          destinations: const <NavigationRailDestination>[
            NavigationRailDestination(
              // 未选中时显示的图标
              icon: Icon(Icons.auto_awesome_outlined),
              // 选中时显示的图标（更醒目）
              selectedIcon: Icon(Icons.auto_awesome),
              // 文本标签：这里使用中文显示
              label: Text('智能填报'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school),
              label: Text('高校库'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.eighteen_mp_outlined),
              selectedIcon: Icon(Icons.e_mobiledata),
              label: Text('数据库'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: Text('设置'),
            ),
          ],
        ));
  }
}

/// HomeTabBar
///
/// 窄屏或移动端底部导航场景下使用的组件，基于 Flutter 的 [NavigationBar]。
///
/// 功能说明：
/// - 与 [HomeTabView] 类似，也通过 `TabIndexController` 管理选中状态并使用 `Obx` 响应式更新。
/// - 使用 [NavigationDestination] 定义底部导航项。
class HomeTabBar extends StatelessWidget {
  const HomeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取全局的 TabIndexController，用于读取与设置当前选中索引
    final TabIndexController ctrl = Get.find<TabIndexController>();

    // 使用 Obx 包裹 NavigationBar，以便在 currentIndex 改变时自动刷新选中状态
    return Obx(() => NavigationBar(
          // 与 NavigationRail 一致，selectedIndex 来自控制器
          selectedIndex: ctrl.currentIndex.value,

          // 点击底部导航项时调用控制器的 select 方法
          onDestinationSelected: ctrl.select,

          // 底部导航的各项定义
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              // NavigationDestination 的 label 为 String 而非 Widget
              label: '智能填报',
            ),
            NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school),
              label: '高校库',
            ),
            NavigationDestination(
              icon: Icon(Symbols.data_table),
              selectedIcon: Icon(Icons.e_mobiledata),
              label: '数据库',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: '设置',
            ),
          ],
        ));
  }
}
