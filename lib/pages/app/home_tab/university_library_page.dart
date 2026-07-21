// 高校库页面：支持关键词/标签搜索并展示筛选结果
//
// 说明：
// - 该页面使用 Stateful 以维护本地的搜索条件 `_query`；
// - 用户可以通过输入框搜索高校名称/城市，或点击预设标签快速过滤；
// - 搜索结果通过对高校名称、城市、标签的综合字符串匹配实现，支持子字符串搜索；
// - 与 RecommendationPage 的被动推荐不同，本页提供主动探索高校的能力。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volnex/components/common/page_header.dart';
import 'package:volnex/models/university.dart';
import 'package:volnex/controllers/home_controller.dart';
import 'package:volnex/components/common/university_card.dart';

class UniversityLibraryPage extends StatefulWidget {
  const UniversityLibraryPage({super.key});

  @override
  State<UniversityLibraryPage> createState() => _UniversityLibraryPageState();
}

class _UniversityLibraryPageState extends State<UniversityLibraryPage> with AutomaticKeepAliveClientMixin {
  String _query = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // required when using AutomaticKeepAliveClientMixin
    final HomeController ctrl = Get.find<HomeController>();

    // 为 ListView 指定 PageStorageKey，可在页面切换或部分重建时保留滚动位置
    return ListView(key: const PageStorageKey('university_list'), padding: const EdgeInsets.all(24), children: <Widget>[
      const PageHeader(
        title: '全国高校库',
        subtitle: '收录院校、专业、分数线与校园生活信息',
        spacing: 6,
      ),
      TextField(
        onChanged: (String value) => setState(() => _query = value.trim()),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: '搜索院校、城市、特色标签',
          filled: true,
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        children: <String>['海滨校园', '园林城市', '现代校园', '山地校园']
            .map((String tag) => FilterChip(
                  label: Text(tag),
                  selected: _query == tag,
                  onSelected: (_) => setState(() => _query = _query == tag ? '' : tag),
                ))
            .toList(),
      ),
      const SizedBox(height: 12),
      Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final List<University> filtered = ctrl.universities
            .where((University university) =>
                '${university.name}${university.city}${university.tags.join()}'.contains(_query))
            .toList();

        return Column(
          children: filtered
              .map((University university) => UniversityCard(
                    university: university,
                    candidateRank: ctrl.candidateRank.value,
                  ))
              .toList(),
        );
      }),
    ]);
  }
}
