// 应用设置页面
//
// 说明：
// - 该页面作为应用的设置/信息中心，用户可在此查看关于应用的详细信息；
// - 目前展示为静态卡片列表，展示数据来源、录取查询、校园生活等功能介绍；
// - 后续可扩展为真实的设置选项（如语言、主题、通知等）。

// Flutter 的 Material Design 组件库，提供 UI 基础组件（如 Scaffold、ListView、Card 等）
import 'package:flutter/material.dart';
// 自定义页面头部组件，用于统一显示页面标题
import 'package:volnex/components/common/page_header.dart';

/// 设置页面组件
///
/// 继承自 StatelessWidget，表示这是一个无状态的 UI 组件
/// 功能：展示应用的信息和功能介绍，未来可扩展为真实的设置页面
class SettingsPage extends StatelessWidget {
  /// 构造函数
  ///
  /// {super.key} 是 Flutter 推荐的 key 传递方式，允许父组件控制该组件的身份
  const SettingsPage({super.key});

  /// 构建 UI 组件树
  ///
  /// @param context BuildContext 对象，提供组件在树中的位置信息和主题等
  /// @return Widget 返回该页面的完整组件树
  ///
  /// 使用 expression body (=>) 简化代码，直接返回 ListView
  @override
  Widget build(BuildContext context) => ListView(
    // 设置 ListView 内边距为 24 逻辑像素，使内容不贴边
    padding: const EdgeInsets.all(24),
    // children 是 ListView 的子组件列表
    children: <Widget>[
      // 页面头部组件，显示"设置"标题
      const PageHeader(title: '设置'),

      // 第一个卡片：数据来源与更新
      const Card(
        // Card 内部使用 ListTile 作为内容布局
        // ListTile 提供了 leading、title、subtitle 的标准布局
        child: ListTile(
          // leading 属性设置左侧图标
          // Icons.verified_outlined 表示已验证/可信的含义
          leading: Icon(Icons.verified_outlined),
          // title 设置主标题文本
          title: Text('数据来源与更新'),
          // subtitle 设置副标题，说明数据的来源和更新策略
          // 文本内容说明了三个数据来源：教育部、省教育考试院、高校招生网
          subtitle: Text('规划接入教育部高校名单、省教育考试院及高校招生网公开数据；每条记录将显示年份、来源和更新时间。'),
        ),
      ),

      // 第二个卡片：录取数据查询
      const Card(
        child: ListTile(
          // leading 设置洞察图标，表示数据分析能力
          // Icons.insights_outlined 用于展示数据可视化/分析功能
          leading: Icon(Icons.insights_outlined),
          title: Text('录取数据'),
          // subtitle 说明录取数据可以按多个维度进行查询
          // 包括：省份、选科、院校、专业、年份
          // 可查询的内容：最低分、最低位次、招生计划
          subtitle: Text('按省份、选科、院校、专业和年份查询最低分、最低位次与招生计划。'),
        ),
      ),

      // 第三个卡片：校园生活信息
      const Card(
        child: ListTile(
          // leading 设置探索图标，表示信息探索和发现
          // Icons.travel_explore_outlined 与校园生活、探索校园的主题契合
          leading: Icon(Icons.travel_explore_outlined),
          title: Text('校园生活'),
          // subtitle 说明校园生活模块涵盖的信息类型
          // 包括：校区环境、住宿、餐饮、交通、开放日
          // 支持官方链接核验，确保信息可靠性
          subtitle: Text('展示校区环境、住宿、餐饮、交通与开放日等信息，支持官方链接核验。'),
        ),
      ),
    ],
  );
}
