// 应用设置页面
//
// 说明：
// - 该页面作为应用的设置/信息中心，用户可在此查看关于应用的详细信息；
// - 目前展示为静态卡片列表，展示数据来源、录取查询、校园生活等功能介绍；
// - 后续可扩展为真实的设置选项（如语言、主题、通知等）。
import 'package:flutter/material.dart';
import 'package:volnex/components/common/page_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: <Widget>[
    const PageHeader(title: '设置'),
    const Card(child: ListTile(
      leading: Icon(Icons.verified_outlined),
      title: Text('数据来源与更新'),
      subtitle: Text('规划接入教育部高校名单、省教育考试院及高校招生网公开数据；每条记录将显示年份、来源和更新时间。'),
    )),
    const Card(child: ListTile(
      leading: Icon(Icons.insights_outlined),
      title: Text('录取数据'),
      subtitle: Text('按省份、选科、院校、专业和年份查询最低分、最低位次与招生计划。'),
    )),
    const Card(child: ListTile(
      leading: Icon(Icons.travel_explore_outlined),
      title: Text('校园生活'),
      subtitle: Text('展示校区环境、住宿、餐饮、交通与开放日等信息，支持官方链接核验。'),
    )),
  ]);
}