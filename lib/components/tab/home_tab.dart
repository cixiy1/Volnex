// Tab 导航组件：封装 NavigationRail（用于宽屏/侧边栏）与 NavigationBar（用于窄屏/底部）
//
// 说明：
// - 本文件包含两个组件：HomeTabView（宽屏侧边栏）和 HomeTabBar（窄屏底部栏）；
// - 两者通过 GetX 的 `TabIndexController` 管理当前选中索引，并通过响应式 `Obx` 自动更新 UI；
// - 在 HomeShell 中，HomeTabView 用于 wide == true 的宽屏布局，HomeTabBar 用于 wide == false 的窄屏布局。
// - 导航项均包含 4 个 Tab：智能填报、高校库、数据库、设置。
//
// 实现要点：
// - NavigationRail 和 NavigationBar 都使用 destinations 属性声明导航项列表；
// - Obx 包裹整个导航组件，使得当 `ctrl.currentIndex.value` 变化时自动重建导航组件并更新选中状态；
// - 控制器通过 `onDestinationSelected` 回调接收用户的选择，调用 `ctrl.select(index)` 更新状态。

// Flutter 核心 UI 库，提供 StatelessWidget、Obx 等基础组件
import 'package:flutter/material.dart';

// GetX 状态管理库，提供 Get.find（依赖查找）和 Obx（响应式包装）
import 'package:get/get.dart';

// Tab 索引控制器，负责维护和更新当前选中的 tab 索引
import 'package:volnex/controllers/tab_index_controller.dart';

// Material Symbols Icons 扩展包，提供更丰富的图标集（如 Symbols.data_table）

/// HomeTabView
///
/// 宽屏或侧边栏场景下使用的导航组件，基于 Flutter 的 [NavigationRail]。
///
/// 功能说明：
/// - 从 GetX 服务中获取 `TabIndexController`（使用 `Get.find<TabIndexController>()`），
///   以读取当前选中索引并提供切换回调。
/// - 使用 `Obx` 将 NavigationRail 包裹为响应式组件，当控制器中的 `currentIndex` 变化时自动重建。
/// - destinations 列表中定义了四个导航项（智能填报、高校库、数据库、设置），
///   分别提供未选中与选中时的 icon，以及文本标签。
///
/// 布局特点：
/// - NavigationRail 默认垂直排列，适合放在 Row 的左侧作为侧边导航；
/// - labelType 设置为 all，标签始终显示（也可设为 selected 仅在选中时显示）。
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // 从 GetX 容器中查找已注册的 TabIndexController 实例。
    // 要求在应用初始化阶段（app() 中）已通过 Get.put 将控制器注册到依赖管理中。
    final TabIndexController ctrl = Get.find<TabIndexController>();

    // 使用 Obx 包裹 NavigationRail：
    // Obx 是一个响应式 observer，当 ctrl.currentIndex.value 发生变化时会触发 NavigationRail 重建，
    // 从而自动更新 selectedIndex，保持 UI 与状态同步。
    return Obx(
      () => NavigationRail(
        // 当前选中的索引，由控制器的 RxInt 类型 currentIndex 提供。
        // 取出 .value 以获取实际的 int 值传给 NavigationRail。
        selectedIndex: ctrl.currentIndex.value,

        // 当用户在 NavigationRail 上点击某项时，调用控制器提供的 select 方法。
        // select 方法内部会更新 currentIndex，Obx 监听到变化后自动重建 NavigationRail。
        onDestinationSelected: ctrl.select,

        // 标签显示方式：
        // - all：始终显示所有标签
        // - selected：仅在选中项下方显示标签
        // - none：不显示标签
        // 此处使用 all，保证用户在任何尺寸下都能看到 Tab 文字标签。
        labelType: NavigationRailLabelType.all,

        // 导航目的地列表：每一项使用 NavigationRailDestination 指定图标与标签。
        destinations: const <NavigationRailDestination>[
          // 导航项 1：智能填报
          NavigationRailDestination(
            // 未选中时显示的描边（outlined）图标，颜色较淡
            icon: Icon(Icons.auto_awesome_outlined),
            // 选中时显示的实心图标，颜色由 NavigationRail 自动高亮
            selectedIcon: Icon(Icons.auto_awesome),
            // 文本标签，使用 Text Widget 并直接传入中文
            label: Text('智能填报'),
          ),
          // 导航项 2：高校库
          NavigationRailDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: Text('高校库'),
          ),
          // 导航项 3：数据中心
          NavigationRailDestination(
            icon: Icon(Icons.source_outlined),
            selectedIcon: Icon(Icons.source),
            label: Text('数据库'),
          ),
          // 导航项 4：设置
          NavigationRailDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text('设置'),
          ),
        ],
      ),
    );
  }
}

/// HomeTabBar
///
/// 窄屏或移动端底部导航场景下使用的组件，基于 Flutter 的 [NavigationBar]。
///
/// 功能说明：
/// - 与 [HomeTabView] 类似，通过 `TabIndexController` 管理选中状态并使用 `Obx` 响应式更新。
/// - 使用 [NavigationDestination] 定义底部导航项（语义上等同于 NavigationRailDestination）。
/// - NavigationBar 自带 Material Design 3 底部导航样式，包括高亮背景和标签动画。
///
/// 布局特点：
/// - NavigationBar 固定在屏幕底部，高度约 80px；
/// - NavigationDestination 的 label 属性为 String 类型（不同于 NavigationRailDestination 的 Widget），
///   这里同样使用中文文字。
class HomeTabBar extends StatelessWidget {
  const HomeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取全局的 TabIndexController，用于读取当前选中索引并接收用户选择事件
    final TabIndexController ctrl = Get.find<TabIndexController>();

    // 使用 Obx 包裹 NavigationBar，使其在 currentIndex 改变时自动刷新选中状态
    return Obx(
      () => NavigationBar(
        // 与 NavigationRail 一致，selectedIndex 绑定到控制器的 currentIndex.value
        selectedIndex: ctrl.currentIndex.value,

        // 点击底部导航项时，调用控制器的 select 方法更新当前索引
        onDestinationSelected: ctrl.select,

        // 底部导航的各项定义，每个 NavigationDestination 对应一个 Tab
        destinations: const <NavigationDestination>[
          // Tab 1：智能填报
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            // NavigationDestination 的 label 为 String 类型而非 Widget
            label: '智能填报',
          ),
          // Tab 2：高校库
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: '高校库',
          ),
          // Tab 3：数据中心
          NavigationDestination(
            // 使用 material_symbols_icons 包中的 data_table 符号图标
            icon: Icon(Icons.source_outlined),
            selectedIcon: Icon(Icons.source),
            label: '数据库',
          ),
          // Tab 4：设置
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
