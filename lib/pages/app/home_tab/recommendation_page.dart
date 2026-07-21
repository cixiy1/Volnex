// 智能推荐页：根据考生位次将高校分为冲、稳、保三类
//
// 说明：
// - 该页面从 HomeController 获取全局的考生档案与高校列表，并根据"学校最低录取位次"与"考生位次"的差值分组；
// - 冲刺组（delta > -2500）：学校位次低很多，上岸概率较低但值得尝试；
// - 稳妥组（1000 < delta < 9000）：学校位次接近，上岸概率较高；
// - 保底组（delta > 9000）：学校位次高很多，上岸概率高，作为兜底选项。

// Flutter 的 Material Design 组件库，提供 UI 基础组件
import 'package:flutter/material.dart';
// GetX 包，提供状态管理、依赖注入、路由管理等功能
import 'package:get/get.dart';
// 自定义页面头部组件，用于显示标题和副标题
import 'package:volnex/components/common/page_header.dart';
// 自定义 University 数据模型，包含学校的基本信息（名称、城市、录取位次等）
import 'package:volnex/models/university.dart';
// HomeController：全局状态控制器，管理考生档案和高校列表
import 'package:volnex/controllers/home_controller.dart';
// 自定义推荐分组组件，用于展示"冲一冲"、"稳一稳"、"保一保"三个分组
import 'package:volnex/components/tab/recommendation_group.dart';

/// 智能推荐页面组件
///
/// 继承自 StatelessWidget，表示这是一个无状态的 UI 组件
/// 功能：根据考生位次自动生成"冲、稳、保"三类志愿推荐
class RecommendationPage extends StatelessWidget {
  /// 构造函数
  ///
  /// {super.key} 是 Flutter 推荐的 key 传递方式
  const RecommendationPage({super.key});

  /// 构建 UI 组件树
  ///
  /// @param context BuildContext 对象，提供组件在树中的位置信息
  /// @return Widget 返回该页面的完整组件树
  @override
  Widget build(BuildContext context) {
    // 使用 Get.find 获取全局注册的 HomeController 实例
    // HomeController 是在 app.dart 中通过 Get.put 注册的全局单例
    // 它持有考生档案（province 省份、candidateRank 位次）和高校列表
    final HomeController ctrl = Get.find<HomeController>();

    // 返回一个可滚动的列表视图
    // 使用 PageStorageKey 保存滚动位置，当页面切换回来时可以恢复到之前的位置
    return ListView(
      // PageStorageKey 用于标识这个 ListView，配合 PageStorage 保存滚动偏移
      key: const PageStorageKey('recommendation_list'),
      // 设置内边距为 24 逻辑像素
      padding: const EdgeInsets.all(24),
      // children 列表包含页面的所有子组件
      children: <Widget>[
        // Obx 是 GetX 的响应式组件包装器
        // 当 ctrl.isLoading、ctrl.candidateRank 等响应式变量变化时，会自动重建内部组件
        Obx(() {
          // 检查数据是否正在加载
          if (ctrl.isLoading.value) {
            // 如果正在加载，显示一个居中的加载指示器
            return const Center(
              child: Padding(
                // 设置上下左右 40 逻辑像素的内边距
                padding: EdgeInsets.all(40),
                // CircularProgressIndicator 是 Material 风格的圆形进度指示器
                child: CircularProgressIndicator(),
              ),
            );
          }

          // 从 Controller 获取考生的全省位次
          // .value 用于访问 RxInt 类型的实际值
          final int rank = ctrl.candidateRank.value;
          // 从 Controller 获取考生所在省份
          final String province = ctrl.province.value;
          // 从 Controller 获取所有高校列表
          // universities 是一个普通 List<University>，不是响应式变量
          final List<University> all = ctrl.universities;

          // 冲刺组（冲一冲）：选择录取位次低于考生位次的学校
          // 条件：u.cutoffRank < rank，表示该校录取要求比考生位次更高（位次数字越小要求越高）
          // take(2) 只取前 2 所学校作为冲刺选项
          final List<University> rush = all
              .where((University u) => u.cutoffRank - rank > -2500)
              .take(5)
              .toList();

          // 稳妥组（稳一稳）：选择录取位次与考生位次接近的学校
          // 条件：|u.cutoffRank - rank| < 9000，表示位次差距在 9000 以内
          // take(3) 取前 3 所学校作为稳妥选项
          final List<University> steady = all
              .where(
                (University u) =>
                    u.cutoffRank - rank >= 1000 && u.cutoffRank - rank <= 9000,
              )
              // .take(3)
              .toList();

          // 保底组（保一保）：选择录取位次高于考生位次的学校
          // 条件：u.cutoffRank > rank，表示该校录取要求比考生位次更低
          // take(2) 只取前 2 所学校作为保底选项
          final List<University> safe = all
              .where((University u) => u.cutoffRank - rank > 9000)
              .take(10)
              .toList();

          // 返回一个纵向排列的列组件
          return Column(
            // 设置子组件左对齐
            crossAxisAlignment: CrossAxisAlignment.start,
            // children 列表包含列的所有子组件
            children: <Widget>[
              // 页面头部，显示标题和副标题
              PageHeader(
                // 主标题，说明这是为考生定制的志愿方案
                title: '为你生成志愿方案',
                // 副标题，显示考生的省份、位次，以及推荐的依据
                subtitle: '$province · 全省位次 $rank · 依据近三年录取位次与招生计划',
                // 设置底部间距为 20 逻辑像素
                bottomSpacing: 20,
              ),

              // 冲刺组推荐卡片
              // title: 组名显示"冲一冲"
              // color: 使用深橙色，表示需要努力冲刺
              // universities: 传入筛选后的冲刺组学校列表
              // candidateRank: 传入考生位次，用于显示录取概率
              RecommendationGroup(
                title: '冲一冲',
                color: Colors.deepOrange,
                universities: rush,
                candidateRank: rank,
              ),

              // 稳妥组推荐卡片
              // color: 使用深绿色（#156B5B），表示稳妥可靠
              RecommendationGroup(
                title: '稳一稳',
                color: const Color(0xff156B5B),
                universities: steady,
                candidateRank: rank,
              ),

              // 保底组推荐卡片
              // color: 使用靛蓝色，表示安全的兜底选择
              RecommendationGroup(
                title: '保一保',
                color: Colors.indigo,
                universities: safe,
                candidateRank: rank,
              ),
            ],
          );
        }),
      ],
    );
  }
}
