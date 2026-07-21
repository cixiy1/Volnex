// 数据中心页面：展示数据来源、录取数据与校园生活等模块的简介
//
// 说明：
// - 该页面作为信息展示区，简要介绍应用数据的来源来源和更新策略、高级查询能力、校园生活信息等；
// - 目前展示为静态卡片列表，后续可扩展为完整的数据查询与浏览界面；
// - 作为应用的功能概览，帮助用户理解各模块的作用。

// Flutter 的 Material Design 组件库，提供 UI 基础组件（如 Scaffold、ListView、Card 等）
import 'package:flutter/material.dart';
// 自定义页面头部组件，用于统一显示页面标题和副标题
import 'package:volnex/components/common/page_header.dart';

/// 数据中心页面组件
///
/// 继承自 StatelessWidget，表示这是一个无状态的 UI 组件
/// 页面功能：展示应用数据来源、录取数据查询能力、校园生活信息三个功能模块
class DataHubPage extends StatelessWidget {
  /// 构造函数
  ///
  /// {super.key} 是 Flutter 推荐的 key 传递方式，允许父组件控制该组件的身份
  const DataHubPage({super.key});

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
      // 页面头部组件，显示"数据中心"标题
      const PageHeader(title: '数据中心'),

      // 第一个卡片：数据来源与更新
      const Card(
        // Card 内部使用 ListTile 作为内容布局
        child: ListTile(
          // leading 属性设置左侧图标，使用已验证图标表示数据可信度
          leading: Icon(Icons.verified_outlined),
          // title 设置主标题文本
          title: Text('数据来源与更新'),
          // subtitle 设置副标题，说明数据来源和更新策略
          subtitle: Text('规划接入教育部高校名单、省教育考试院及高校招生网公开数据；每条记录将显示年份、来源和更新时间。'),
        ),
      ),

      // 第二个卡片：录取数据查询
      const Card(
        child: ListTile(
          // 使用洞察图标表示数据分析能力
          leading: Icon(Icons.insights_outlined),
          title: Text('录取数据'),
          // 说明录取数据的查询维度：省份、选科、院校、专业、年份
          subtitle: Text('按省份、选科、院校、专业和年份查询最低分、最低位次与招生计划。'),
        ),
      ),

      // 第三个卡片：校园生活信息
      const Card(
        child: ListTile(
          // 使用探索图标表示信息探索
          leading: Icon(Icons.travel_explore_outlined),
          title: Text('校园生活'),
          // 说明校园生活模块涵盖的信息类型
          subtitle: Text('展示校区环境、住宿、餐饮、交通与开放日等信息，支持官方链接核验。'),
        ),
      ),
    ],
  );
}
