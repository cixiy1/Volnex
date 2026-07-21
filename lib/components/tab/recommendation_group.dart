// 推荐分组组件：展示每个分组的标题与高校卡片列表
import 'package:flutter/material.dart';
import 'package:volnex/models/university.dart';
import 'package:volnex/components/common/university_card.dart';

class RecommendationGroup extends StatelessWidget {
  const RecommendationGroup({
    super.key,
    required this.title,
    required this.color,
    required this.universities,
    required this.candidateRank,
  });

  final String title;
  final Color color;
  final List<University> universities;
  final int candidateRank;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 10),
          ...universities.map((University university) => UniversityCard(university: university, candidateRank: candidateRank)),
          const SizedBox(height: 12),
        ],
      );
}
