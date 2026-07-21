// 高校卡片组件：用于在列表中展示学校摘要信息，点击可进入详情页
import 'package:flutter/material.dart';
import 'package:volnex/models/university.dart';
import 'package:volnex/pages/app/university_detail_page.dart';

class UniversityCard extends StatelessWidget {
  const UniversityCard({
    super.key,
    required this.university,
    required this.candidateRank,
  });

  final University university;
  final int candidateRank;

  @override
  Widget build(BuildContext context) {
    final int delta = university.cutoffRank - candidateRank;
    final String label = delta < -2500 ? '冲刺' : delta > 5000 ? '保底' : '稳妥';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => UniversityDetailPage(university: university)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: university.color, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.account_balance, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Row(children: <Widget>[
                  Expanded(child: Text(university.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
                  Chip(label: Text(label), visualDensity: VisualDensity.compact),
                ]),
                Text('${university.city} · ${university.level}', style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Text(university.environment, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: university.tags.map((String tag) => Chip(label: Text(tag), visualDensity: VisualDensity.compact)).toList(),
                ),
              ]),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade500),
          ]),
        ),
      ),
    );
  }
}
