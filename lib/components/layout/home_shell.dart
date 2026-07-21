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

// Flutter 核心 UI 库，提供 Scaffold、AppBar、Row、Column 等 Material Design 组件
import 'package:flutter/material.dart';

// GetX 状态管理库，提供依赖注入（Get.find）和响应式状态（Obx）
import 'package:get/get.dart';

// 应用内控制器：HomeController 管理考生档案（省份、位次）和高校列表
import 'package:volnex/controllers/home_controller.dart';

// 应用内控制器：TabIndexController 管理底部/侧边栏的当前选中 tab 索引
import 'package:volnex/controllers/tab_index_controller.dart';

// 考生档案底部弹窗组件（通过 ProfileSheet.show 调用）
import 'package:volnex/components/common/profile_sheet.dart';

// Tab 导航组件：封装 NavigationRail（宽屏侧边栏）和 NavigationBar（窄屏底部栏）
import 'package:volnex/components/tab/home_tab.dart';

// 各业务页面：智能推荐页
import 'package:volnex/pages/app/home_tab/recommendation_page.dart';

// 各业务页面：高校库页
import 'package:volnex/pages/app/home_tab/university_library_page.dart';

// 各业务页面：数据中心页
import 'package:volnex/pages/app/home_tab/data_hub_page.dart';

// 各业务页面：应用设置页
import 'package:volnex/pages/app/home_tab/settings_page.dart';

/// HomeShell
///
/// 顶层布局组件（StatelessWidget）。它根据屏幕宽度选择不同的导航展现方式：
/// - 宽屏（maxWidth >= 880）：左侧显示 `HomeTabView` (NavigationRail)，右侧显示页面内容
/// - 窄屏：使用底部 `HomeTabBar` (NavigationBar) 并直接显示当前页面内容
///
/// 整体结构为 Scaffold，包含 AppBar、body 和可选的 bottomNavigationBar。
/// body 中的页面内容通过 `IndexedStack` 保持各页面 State，不会因切换而被销毁。
class HomeShell extends StatelessWidget {
  // const 构造函数，HomeShell 作为无状态的顶层容器，无须额外参数
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    // 通过 Get.find 从 GetX 容器中查找已注册的 TabIndexController 实例。
    // 依赖注入在 app() 初始化阶段完成（见 main.dart / app.dart）。
    final TabIndexController tabCtrl = Get.find<TabIndexController>();

    // 定义每个 tab 页面的 Widget 列表（按导航顺序排列）。
    // 在运行时构造列表以避免 const 限制（页面构造器非 const）。
    final List<Widget> pages = <Widget>[
      // 第 0 个 tab：智能推荐页（根据考生档案推荐高校）
      RecommendationPage(),
      // 第 1 个 tab：高校库页（浏览/搜索全部高校）
      UniversityLibraryPage(),
      // 第 2 个 tab：数据中心（分数线、位次等数据可视化）
      DataHubPage(),
      // 第 3 个 tab：应用设置（主题、语言、关于等）
      SettingsPage(),
    ];

    // 使用 LayoutBuilder 获取父容器的尺寸约束，据此判断应该采用何种布局。
    // LayoutBuilder 会在父容器尺寸变化时重建子树，实现响应式布局。
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 根据可用宽度判断屏幕类型：宽屏用侧边栏导航，窄屏用底部导航。
        // 阈值 880px 是平板/桌面与手机的典型分界点。
        final bool wide = constraints.maxWidth >= 880;

        return Scaffold(
          // 顶部 AppBar：包含应用 Logo、应用名与"我的档案"按钮
          appBar: AppBar(
            // 白色背景，与整体设计风格保持一致
            backgroundColor: Colors.white,
            // 标题行：左侧 Logo 圆形图标 + "Volnex" 主标题 + "高考志愿助手" 副标题
            title: const Row(
              children: <Widget>[
                // 圆形图标作为应用 Logo，深绿色底白色图标
                CircleAvatar(
                  backgroundColor: Color(0xff156B5B),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(width: 10),
                // 主标题（应用名），加粗样式突出品牌
                Text('Volnex', style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(width: 8),
                // 副标题（应用描述），较小字号
                Text('高考志愿助手', style: TextStyle(fontSize: 14)),
              ],
            ),
            // 右上角操作按钮区域
            actions: <Widget>[
              // 点击打开个人档案弹窗（ProfileSheet），允许用户设置省份和位次
              TextButton.icon(
                onPressed: () => _showProfile(context),
                icon: const Icon(Icons.person_outline),
                label: const Text('我的档案'),
              ),
              // 右侧留一点间距，防止按钮紧贴边缘
              const SizedBox(width: 12),
            ],
          ),

          // 主体内容区域：
          // - 宽屏：Row 将左侧导航（HomeTabView）与右侧内容区并排显示
          // - 窄屏：直接显示 IndexedStack（底部导航由 bottomNavigationBar 承接）
          body: wide
              ? Row(
                  children: <Widget>[
                    // 左侧 NavigationRail 封装在 HomeTabView 中，提供垂直导航
                    const HomeTabView(),
                    // 导航与内容区之间的分隔线（宽 1px）
                    const VerticalDivider(width: 1),
                    // 内容区使用 IndexedStack 保留每个页面的 State，切换时不会销毁重建
                    Expanded(
                      child: Obx(
                        // Obx 使 IndexedStack 变为响应式：currentIndex 变化时重建
                        () => IndexedStack(
                          // 根据控制器的 currentIndex 决定显示哪一页
                          index: tabCtrl.currentIndex.value,
                          // 所有页面子 Widget，index 超出范围则显示第一项
                          children: pages,
                        ),
                      ),
                    ),
                  ],
                )
              // 窄屏布局：直接在 body 中显示 IndexedStack（底部导航单独处理）
              : Obx(
                  () => IndexedStack(
                    index: tabCtrl.currentIndex.value,
                    children: pages,
                  ),
                ),

          // 底部导航栏：仅在窄屏时显示（wide == false）；宽屏时为 null，由侧边栏承担导航职责
          bottomNavigationBar: wide ? null : const HomeTabBar(),
        );
      },
    );
  }

  /// 打开"我的档案"弹窗并处理返回结果
  ///
  /// 逻辑：
  /// - 通过 Get.find 获取 `HomeController`（包含用户档案信息：省份、位次）
  /// - 调用 `ProfileSheet.show` 弹出底部面板，传入当前的省份与排位作为表单初始值
  /// - 若用户在面板中确认并返回结果，则调用控制器的 `updateProfile` 更新数据
  Future<void> _showProfile(BuildContext context) async {
    // 获取 HomeController，用于读取当前档案值并接收更新后的结果
    final HomeController ctrl = Get.find<HomeController>();

    // 弹出底部档案编辑面板（ProfileSheet），等待用户输入或确认
    final result = await ProfileSheet.show(
      context,
      // 从控制器中读取当前已保存的省份作为表单初始值
      initialProvince: ctrl.province.value,
      // 从控制器中读取当前已保存的全省位次作为表单初始值
      initialRank: ctrl.candidateRank.value,
    );

    // 如果用户点击"保存"（返回非 null），result 为 (province, candidateRank) 元组
    if (result != null) {
      // 将用户输入的新值同步回 HomeController，触发推荐结果重新计算
      ctrl.updateProfile(province: result.$1, candidateRank: result.$2);
    }
    // 若用户取消（返回 null），不执行任何操作，档案保持原值
  }
}
