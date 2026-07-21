// 高校库页面：支持关键词/标签搜索并展示筛选结果
//
// 说明：
// - 该页面使用 Stateful 以维护本地的搜索条件 `_query`；
// - 用户可以通过输入框搜索高校名称/城市，或点击预设标签快速过滤；
// - 搜索结果通过对高校名称、城市、标签的综合字符串匹配实现，支持子字符串搜索；
// - 与 RecommendationPage 的被动推荐不同，本页提供主动探索高校的能力。

// Flutter 的 Material Design 组件库，提供 UI 基础组件
import 'package:flutter/material.dart';
// GetX 包，提供状态管理、依赖注入功能
import 'package:get/get.dart';
// 自定义页面头部组件，用于显示标题和副标题
import 'package:volnex/components/common/page_header.dart';
// 自定义 University 数据模型，包含学校的基本信息
import 'package:volnex/models/university.dart';
// HomeController：全局状态控制器，管理考生档案和高校列表
import 'package:volnex/controllers/home_controller.dart';
// 自定义高校卡片组件，用于展示单个学校的信息
import 'package:volnex/components/common/university_card.dart';

/// 高校库页面组件
///
/// 继承自 StatefulWidget，表示这是一个有状态的 UI 组件
/// 需要使用 StatefulWidget 是因为该页面维护了本地搜索状态 `_query`
/// 功能：提供高校搜索和筛选功能，用户可以主动探索全国高校
class UniversityLibraryPage extends StatefulWidget {
  /// 构造函数
  ///
  /// {super.key} 是 Flutter 推荐的 key 传递方式
  const UniversityLibraryPage({super.key});

  /// 创建状态对象
  ///
  /// @return `State<UniversityLibraryPage>` 返回该 Widget 对应的状态实例
  @override
  State<UniversityLibraryPage> createState() => _UniversityLibraryPageState();
}

/// 高校库页面的状态类
///
/// 使用 AutomaticKeepAliveClientMixin 混入，可以在页面切换时保持状态
/// 这样用户切换 Tab 后再回来，搜索内容和滚动位置都会保留
class _UniversityLibraryPageState extends State<UniversityLibraryPage>
    with AutomaticKeepAliveClientMixin {
  /// 本地搜索查询字符串
  ///
  /// 用于存储用户在搜索框中输入的关键词
  /// 当用户点击预设标签时，也会更新这个变量
  String _query = '';

  /// 设置是否保持页面存活状态
  ///
  /// 返回 true 表示该页面在切换到其他 Tab 时不会被销毁
  /// 配合 AutomaticKeepAliveClientMixin 使用
  /// 这样搜索内容和滚动位置在 Tab 切换时可以保留
  @override
  bool get wantKeepAlive => true;

  /// 构建 UI 组件树
  ///
  /// @param context BuildContext 对象，提供组件在树中的位置信息
  /// @return Widget 返回该页面的完整组件树
  @override
  Widget build(BuildContext context) {
    // 必须调用 super.build，这是 AutomaticKeepAliveClientMixin 的要求
    // 这样才能正确实现页面保活功能
    super.build(context); // required when using AutomaticKeepAliveClientMixin

    // 使用 Get.find 获取全局注册的 HomeController 实例
    // HomeController 在 app.dart 中通过 Get.put 注册为全局单例
    // 它持有考生档案和高校列表数据
    final HomeController ctrl = Get.find<HomeController>();

    // 返回一个可滚动的列表视图
    // 使用 PageStorageKey 保存滚动位置，当页面切换回来时可以恢复到之前的位置
    return ListView(
      // PageStorageKey 用于标识这个 ListView，配合 PageStorage 保存滚动偏移
      key: const PageStorageKey('university_list'),
      // 设置内边距为 24 逻辑像素，使内容不贴边
      padding: const EdgeInsets.all(24),
      // children 列表包含页面的所有子组件
      children: <Widget>[
        // 页面头部，显示标题和副标题
        const PageHeader(
          // 主标题：全国高校库
          title: '全国高校库',
          // 副标题：说明该页面的内容范围
          subtitle: '收录院校、专业、分数线与校园生活信息',
          // 设置标题与副标题之间的间距为 6 逻辑像素
          spacing: 6,
        ),

        // 搜索输入框
        TextField(
          // onChanged 回调：当用户输入内容时触发
          // value 参数是用户输入的当前文本
          onChanged: (String value) => setState(() {
            // 使用 setState 触发 UI 重建
            // value.trim() 去除首尾空格后赋值给 _query
            _query = value.trim();
          }),
          // decoration 设置输入框的装饰样式
          decoration: const InputDecoration(
            // prefixIcon 在输入框左侧显示搜索图标
            prefixIcon: Icon(Icons.search),
            // hintText 设置占位提示文本
            hintText: '搜索院校、城市、特色标签',
            // filled: true 使输入框有填充背景色
            filled: true,
            // border 设置边框样式
            // OutlineInputBorder 配合 BorderSide.none 创建无边框的圆角输入框
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),

        // 垂直间距组件，高度 16 逻辑像素
        const SizedBox(height: 16),

        // Wrap 组件：流式布局，子组件会自动换行
        // 用于展示预设的标签筛选按钮
        Wrap(
          // spacing 设置水平方向子组件之间的间距为 8 逻辑像素
          spacing: 8,
          // children 是 Wrap 的子组件列表
          // 使用 map 方法将字符串列表转换为 FilterChip 组件列表
          children: <String>['海滨校园', '园林城市', '现代校园', '山地校园']
              .map(
                (String tag) => FilterChip(
                  // label 设置标签显示的文本
                  label: Text(tag),
                  // selected 表示该标签是否被选中
                  // 当 _query 等于当前标签文本时，显示为选中状态
                  selected: _query == tag,
                  // onSelected 回调：当标签被点击时触发
                  // _ 参数是当前的选中状态（此处未使用）
                  onSelected: (_) => setState(() {
                    // 点击标签时切换状态
                    // 如果点击的是已选中的标签，则取消选中（_query 设为空字符串）
                    // 如果点击的是未选中的标签，则选中它（_query 设为该标签）
                    _query = _query == tag ? '' : tag;
                  }),
                ),
              )
              // toList() 将 Iterable 转换为 List
              .toList(),
        ),

        // 垂直间距组件，高度 12 逻辑像素
        const SizedBox(height: 12),

        // Obx 是 GetX 的响应式组件包装器
        // 当 ctrl.isLoading 等响应式变量变化时，会自动重建内部组件
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

          // 对高校列表进行筛选
          // where 方法根据条件过滤列表
          final List<University> filtered = ctrl.universities
              .where(
                (University university) =>
                    // 筛选条件：将学校的名称、城市、标签拼接成一个字符串
                    // 然后检查是否包含用户输入的查询关键词 _query
                    // contains 支持子字符串匹配，即部分匹配
                    '${university.name}${university.city}${university.tags.join()}'
                        .contains(_query),
              )
              // where 返回 Iterable，需要用 toList() 转换为 List
              .toList();

          // 返回一个纵向排列的列组件，展示筛选后的高校卡片
          return Column(
            // children 是 Column 的子组件列表
            // 使用 map 方法将筛选后的高校列表转换为 UniversityCard 组件列表
            children: filtered
                .map(
                  (University university) => UniversityCard(
                    // university 参数：传入学校数据模型
                    university: university,
                    // candidateRank 参数：传入考生位次
                    // 用于在卡片上显示录取概率
                    candidateRank: ctrl.candidateRank.value,
                  ),
                )
                // toList() 将 Iterable 转换为 List
                .toList(),
          );
        }),
      ],
    );
  }
}
