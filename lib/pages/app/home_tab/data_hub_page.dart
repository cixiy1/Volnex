// 数据中心页面：展示数据来源、录取数据与校园生活等模块的简介
//
// 说明：
// - 该页面作为信息展示区，简要介绍应用数据的来源来源和更新策略、高级查询能力、校园生活信息等���
// - 目前展示为静态卡片列表，后续可扩展为完整的数据查询与浏览界面；
// - 作为应用的功能概览，帮助用户理解各模块的作用。
import 'package:flutter/material.dart';
import 'package:volnex/components/common/page_header.dart';

class DataHubPage extends StatelessWidget {
  const DataHubPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: <Widget>[
        const PageHeader(title: '数据中心'),
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
