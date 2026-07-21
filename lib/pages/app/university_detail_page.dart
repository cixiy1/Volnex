// 学校详情页：展示更丰富的学校信息与若干信息项卡片
import 'package:flutter/material.dart';
import 'package:volnex/models/university.dart';
import 'package:volnex/components/common/info_tile.dart';

class UniversityDetailPage extends StatelessWidget {
  const UniversityDetailPage({super.key, required this.university});

  final University university;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(university.name)),
        body: ListView(padding: const EdgeInsets.all(24), children: <Widget>[
          // 顶部大卡片：以学校主题色渐变背景
          Container(
            height: 170,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[university.color, university.color.withValues(alpha: 0.55)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                const Icon(Icons.park, color: Colors.white, size: 36),
                const Spacer(),
                Text(university.city, style: const TextStyle(color: Colors.white70)),
                Text(university.name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          Text('校园环境', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(university.environment),
          const SizedBox(height: 20),
          const InfoTile(
            icon: Icons.home_work_outlined,
            title: '住宿与生活',
            text: '提供校内住宿；宿舍配置、费用与校区安排以当年招生及后勤公告为准。',
          ),
          const InfoTile(
            icon: Icons.restaurant_outlined,
            title: '食堂与配套',
            text: '校内设有多处餐饮、运动与学习空间，周边生活服务便利。',
          ),
          InfoTile(
            icon: Icons.directions_transit_outlined,
            title: '交通与区位',
            text: '${university.city}，建议结合校区位置、通勤时间与实地开放日考察。',
          ),
          const SizedBox(height: 20),
          Text('适合什么样的你？', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(university.summary),
          const SizedBox(height: 28),
          const Text(
            '提示：校园环境为辅助信息，填报前请以高校官方招生网、校园开放日及当年招生章程为准。',
            style: TextStyle(color: Colors.grey),
          ),
        ]),
      );
}
