// 智能推荐页：根据考生位次将高校分为冲、稳、保三类
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volnex/components/common/page_header.dart';
import 'package:volnex/models/university.dart';
import 'package:volnex/controllers/home_controller.dart';
import 'package:volnex/components/tab/recommendation_group.dart';

class RecommendationPage extends StatelessWidget {
  const RecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 独立从 Controller 获取共享状态，无需外部传参
    final HomeController ctrl = Get.find<HomeController>();

    // 为 ListView 指定 PageStorageKey，可在页面树重建时保留滚动位置
    return ListView(key: const PageStorageKey('recommendation_list'), padding: const EdgeInsets.all(24), children: <Widget>[
      Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final int rank = ctrl.candidateRank.value;
        final String province = ctrl.province.value;
        final List<University> all = ctrl.universities;

        final List<University> rush = all.where((University u) => u.cutoffRank < rank).take(2).toList();
        final List<University> steady = all.where((University u) => (u.cutoffRank - rank).abs() < 9000).take(3).toList();
        final List<University> safe = all.where((University u) => u.cutoffRank > rank).take(2).toList();

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          PageHeader(
            title: '为你生成志愿方案',
            subtitle: '$province · 全省位次 $rank · 依据近三年录取位次与招生计划',
            bottomSpacing: 20,
          ),
          RecommendationGroup(title: '冲一冲', color: Colors.deepOrange, universities: rush, candidateRank: rank),
          RecommendationGroup(title: '稳一稳', color: const Color(0xff156B5B), universities: steady, candidateRank: rank),
          RecommendationGroup(title: '保一保', color: Colors.indigo, universities: safe, candidateRank: rank),
        ]);
      }),
    ]);
  }
}
