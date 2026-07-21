// 引入 Flutter 的 UI 库
import 'package:flutter/material.dart';

// 应用程序入口：运行 Flutter 应用，启动根 Widget `VolnexApp`
void main() => runApp(const VolnexApp());

// 根应用 Widget ：使用 MaterialApp 包装，设置主题与首页
class VolnexApp extends StatelessWidget {
  const VolnexApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp 提供应用级别配置：标题、主题、以及首页路由
    return MaterialApp(
      title: 'Volnex 高考志愿助手', // 应用标题
      debugShowCheckedModeBanner: false, // 关闭右上角的 debug 横幅
      theme: ThemeData(
        // 从种子色生成配色方案，保持视觉一致性
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff156B5B)),
        // 全局背景色
        scaffoldBackgroundColor: const Color(0xffF6F8F7),
        useMaterial3: true, // 启用 Material 3 设计风格
      ),
      home: const HomePage(), // 应用首页
    );
  }
}

// 数据模型：高校（University）
// 用于表示一所高校的基本���息，例如名称、城市、层次、录取位次等
class University {
  const University({
    required this.name,
    required this.city,
    required this.level,
    required this.cutoffRank,
    required this.tags,
    required this.environment,
    required this.summary,
    required this.color,
  });

  final String name; // 学校名称
  final String city; // 所在城市或省市信息
  final String level; // 学校层次（如 985、211 等）
  final int cutoffRank; // 近年录取位次或参考位次，用于与考生位次比较
  final List<String> tags; // 学校特色标签（用于搜索/筛选展示）
  final String environment; // 校园环境描述
  final String summary; // 适合人群/学校简介
  final Color color; // 在 UI 中用于区分学校的主题色
}

// 示例数据：一些高校信息的常量列表
const List<University> universities = <University>[
  University(
    name: '厦门大学',
    city: '福建 · 厦门',
    level: '985 / 双一流',
    cutoffRank: 6800,
    tags: <String>['海滨校园', '人文社科', '综合'],
    environment: '依山傍海，主校区与白城沙滩相邻；绿化丰富，步行可达海边。',
    summary: '适合偏好海滨生活、综合性学科与开放校园氛围的考生。',
    color: Color(0xff1E7A67),
  ),
  University(
    name: '苏州大学',
    city: '江��� · 苏州',
    level: '211 / 双一流',
    cutoffRank: 14600,
    tags: <String>['园林城市', '医学', '综合'],
    environment: '多个校区融入古城与园林环境，生活配套成熟，通勤便利。',
    summary: '适合重视城市生活品质、医学与材料等优势专业的考生。',
    color: Color(0xff8E5A30),
  ),
  University(
    name: '深圳大学',
    city: '广东 · 深圳',
    level: '省属重点',
    cutoffRank: 22600,
    tags: <String>['现代校园', '科技', '就业'],
    environment: '现代化山海校园，宿舍和运动设施较新，毗邻科技产业集群。',
    summary: '适合意向互联网、工程与希望在大湾区就业的考生。',
    color: Color(0xff3B6FB6),
  ),
  University(
    name: '中国海洋大学',
    city: '山东 · 青岛',
    level: '985 / 双一流',
    cutoffRank: 10500,
    tags: <String>['海景', '海洋科学', '安静'],
    environment: '崂山校区山海相映，校园安静，适合专注学习与户外运动。',
    summary: '海洋、水产、食品等学科特色突出，校园节奏舒适。',
    color: Color(0xff276E9E),
  ),
  University(
    name: '西南大学',
    city: '重庆 · 北碚',
    level: '211 / 双��流',
    cutoffRank: 29800,
    tags: <String>['山地校园', '师范', '农业'],
    environment: '依山而建、植被茂盛，校园规模大，四季景观分明。',
    summary: '师范、心理、农学优势明显，生活成本相对友好。',
    color: Color(0xff8D5D27),
  ),
  University(
    name: '南京信息工程大学',
    city: '江苏 · 南京',
    level: '双一流',
    cutoffRank: 44000,
    tags: <String>['花园校园', '气象', '工科'],
    environment: '校园开阔、绿地和湖景丰富；住宿集中，生活区配套完善。',
    summary: '大气科学全国领先，适合关注气象、计算机和电子信息的考生。',
    color: Color(0xff7950A0),
  ),
];

// 首页：包含底部导航 / 侧边导航以及三个主页面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Home 页面的 State：保存当前选中页、考生位次与省份等状态
class _HomePageState extends State<HomePage> {
  int _page = 0; // 当前选中页索引
  int _candidateRank = 18000; // 示例考生位次（可由用户调整）
  String _province = '广东'; // 示例省份

  @override
  Widget build(BuildContext context) {
    // 三个主页面：智能推荐、高校库、数据中心
    final List<Widget> pages = <Widget>[
      RecommendationPage(rank: _candidateRank, province: _province, onProfileTap: _showProfile),
      UniversityLibraryPage(candidateRank: _candidateRank),
      const DataHubPage(),
    ];

    // 使用 LayoutBuilder 判断宽屏或窄屏来选择不同导航样式
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= 880; // 宽屏阈值
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            // 顶部 title 区包含图标与应用名
            title: const Row(children: <Widget>[CircleAvatar(backgroundColor: Color(0xff156B5B), child: Icon(Icons.auto_awesome, color: Colors.white, size: 18)), SizedBox(width: 10), Text('Volnex', style: TextStyle(fontWeight: FontWeight.w800)), SizedBox(width: 8), Text('高考志愿助手', style: TextStyle(fontSize: 14))]),
            // 右侧操作：打开个人档案弹窗
            actions: <Widget>[TextButton.icon(onPressed: _showProfile, icon: const Icon(Icons.person_outline), label: const Text('我的档案')), const SizedBox(width: 12)],
          ),

          // 主体：宽屏使用 NavigationRail + 侧边展示，窄屏直接展示当前页面并在底部显示 NavigationBar
          body: wide
              ? Row(children: <Widget>[
                  NavigationRail(
                    selectedIndex: _page,
                    onDestinationSelected: (int value) => setState(() => _page = value),
                    labelType: NavigationRailLabelType.all,
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: Text('智能填报')),
                      NavigationRailDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: Text('高校库')),
                      NavigationRailDestination(icon: Icon(Icons.storage_outlined), selectedIcon: Icon(Icons.storage), label: Text('数据中心'))
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: pages[_page])
                ])
              : pages[_page],

          // 窄屏底部导航
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _page,
                  onDestinationSelected: (int value) => setState(() => _page = value),
                  destinations: const <NavigationDestination>[
                    NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: '智能填报'),
                    NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: '高校库'),
                    NavigationDestination(icon: Icon(Icons.storage_outlined), selectedIcon: Icon(Icons.storage), label: '数据中心')
                  ],
                ),
        );
      },
    );
  }

  // 弹出底部表单，允许用户完善考生档案（省份、位次等），并在保存后刷新推荐
  void _showProfile() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Padding(
          // 根据键盘高度调整底部内边距，避免被遮挡
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.viewInsetsOf(sheetContext).bottom),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            const Text('完善考生档案', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // 省份下拉选择
            DropdownButtonFormField<String>(
              initialValue: _province,
              decoration: const InputDecoration(labelText: '高考省份', border: OutlineInputBorder()),
              items: <String>['浙江', '江苏', '山东', '广东']
                  .map((String value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                  .toList(),
              onChanged: (String? value) {
                if (value != null) _province = value; // 临时更新省份（保存时生效）
              },
            ),
            const SizedBox(height: 14),
            // 位次输入框
            TextFormField(
              initialValue: '$_candidateRank',
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '全省位次', helperText: '推荐以位次为主要依据', border: OutlineInputBorder()),
              onChanged: (String value) => _candidateRank = int.tryParse(value) ?? _candidateRank,
            ),
            const SizedBox(height: 20),
            // 保存按钮：会触发父页面刷新并关闭弹窗
            SizedBox(width: double.infinity, child: FilledButton(onPressed: () {
              setState(() {}); // 使用新的状态刷新 UI
              Navigator.pop(sheetContext); // 关闭弹窗
            }, child: const Text('保存并更新推荐'))),
          ]),
        );
      },
    );
  }
}

// 智能推荐页：根据考生位次将高校分为冲、稳、保三类
class RecommendationPage extends StatelessWidget {
  const RecommendationPage({super.key, required this.rank, required this.province, required this.onProfileTap});
  final int rank; // 考生位次
  final String province; // 考生省份
  final VoidCallback onProfileTap; // 打开档案页面的回调

  @override
  Widget build(BuildContext context) {
    // 简单的分组逻辑：以 cutoffRank 与考生位次比较来决定分类（示例逻辑）
    final List<University> rush = universities.where((University u) => u.cutoffRank < rank).take(2).toList();
    final List<University> steady = universities.where((University u) => (u.cutoffRank - rank).abs() < 9000).take(3).toList();
    final List<University> safe = universities.where((University u) => u.cutoffRank > rank).take(2).toList();

    // 页面布局：标题、信息卡片、以及推荐分组
    return ListView(padding: const EdgeInsets.all(24), children: <Widget>[
      Text('为你生成志愿方案', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('$province · 全省位次 $rank · 依据近三年录取位次与招生计划', style: TextStyle(color: Colors.grey.shade700)),
      const SizedBox(height: 20),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Wrap(spacing: 16, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: <Widget>[
            const Icon(Icons.tune, color: Color(0xff156B5B)),
            const Text('还可加入：选科、专业、城市与校园环境偏好'),
            OutlinedButton(onPressed: onProfileTap, child: const Text('修改档案'))
          ]),
        ),
      ),
      const SizedBox(height: 24),
      _RecommendationGroup(title: '冲一冲', color: Colors.deepOrange, universities: rush, candidateRank: rank),
      _RecommendationGroup(title: '稳一稳', color: const Color(0xff156B5B), universities: steady, candidateRank: rank),
      _RecommendationGroup(title: '保一保', color: Colors.indigo, universities: safe, candidateRank: rank),
    ]);
  }
}

// 推荐分组组件���展示每个分组的标题与高校卡片列表
class _RecommendationGroup extends StatelessWidget {
  const _RecommendationGroup({required this.title, required this.color, required this.universities, required this.candidateRank});
  final String title; // 分组标题，例如“冲一冲”“稳一稳”“保一保”
  final Color color; // 标题颜色
  final List<University> universities; // 分组内高校列表
  final int candidateRank; // 传递考生位次以便在高校卡片中计算差距

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 10),
        // 将每个高校映射为一个 UniversityCard
        ...universities.map((University university) => UniversityCard(university: university, candidateRank: candidateRank)),
        const SizedBox(height: 12)
      ]);
}

// 高校库页面：支持关键词/标签搜索并展示筛选结果
class UniversityLibraryPage extends StatefulWidget {
  const UniversityLibraryPage({super.key, required this.candidateRank});
  final int candidateRank; // 用于在列表中显示与考生的匹配度
  @override
  State<UniversityLibraryPage> createState() => _UniversityLibraryPageState();
}

class _UniversityLibraryPageState extends State<UniversityLibraryPage> {
  String _query = ''; // 当前搜索关键词或所选标签

  @override
  Widget build(BuildContext context) {
    // 简单的过滤逻辑：在学校名、城市和标签的拼接字符串中查找关键词
    final List<University> filtered = universities.where((University university) => '${university.name}${university.city}${university.tags.join()}'.contains(_query)).toList();

    return ListView(padding: const EdgeInsets.all(24), children: <Widget>[
      Text('全国高校库', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('收录院校、专业、分数线与校园生活信息'),
      const SizedBox(height: 18),

      // 搜索框：输入时更新 _query 并触发重建
      TextField(
        onChanged: (String value) => setState(() => _query = value.trim()),
        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: '搜索院校、城市、特色标签', filled: true, border: OutlineInputBorder(borderSide: BorderSide.none)),
      ),
      const SizedBox(height: 16),

      // 常用标签：��击标签会将其设为查询条件或取消
      Wrap(spacing: 8, children: <String>['海滨校园', '园林城市', '现代校园', '山地校园'].map((String tag) => FilterChip(label: Text(tag), selected: _query == tag, onSelected: (_) => setState(() => _query = _query == tag ? '' : tag))).toList()),
      const SizedBox(height: 12),

      // 根据过滤结果生成高校卡片
      ...filtered.map((University university) => UniversityCard(university: university, candidateRank: widget.candidateRank))
    ]);
  }
}

// 高校卡片组件：用于在列表中展示学校摘要信息，点击可进入详情页
class UniversityCard extends StatelessWidget {
  const UniversityCard({super.key, required this.university, required this.candidateRank});
  final University university; // 本卡片展示的高校
  final int candidateRank; // 考生位次，用于计算标签（冲/稳/保）

  @override
  Widget build(BuildContext context) {
    // 计算位次差：用于给出“冲刺/稳妥/保底”的建议标签
    final int delta = university.cutoffRank - candidateRank;
    final String label = delta < -2500 ? '冲刺' : delta > 5000 ? '保底' : '稳妥';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // 点击卡片进入学校详情页
        onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => UniversityDetailPage(university: university))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            // 左侧图标区域：使用学校主题色
            Container(width: 48, height: 48, decoration: BoxDecoration(color: university.color, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.account_balance, color: Colors.white)),
            const SizedBox(width: 14),
            // 中间文本区域：名称、城市/层次、环境摘要与标签
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Row(children: <Widget>[Expanded(child: Text(university.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))), Chip(label: Text(label), visualDensity: VisualDensity.compact)]),
                Text('${university.city} · ${university.level}', style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Text(university.environment, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Wrap(spacing: 6, runSpacing: 6, children: university.tags.map((String tag) => Chip(label: Text(tag), visualDensity: VisualDensity.compact)).toList())
              ]),
            ),
            // 右侧箭头指示可进入详情
            Icon(Icons.chevron_right, color: Colors.grey.shade500)
          ]),
        ),
      ),
    );
  }
}

// 学校详情页：展示更丰富的学校信息与若干信息项卡
class UniversityDetailPage extends StatelessWidget {
  const UniversityDetailPage({super.key, required this.university});
  final University university;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(university.name)),
        body: ListView(padding: const EdgeInsets.all(24), children: <Widget>[
          // 顶部大卡片：以学校主题色渐变背景，展示学校名称与城市
          Container(
            height: 170,
            decoration: BoxDecoration(gradient: LinearGradient(colors: <Color>[university.color, university.color.withValues(alpha: 0.55)]), borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                const Icon(Icons.park, color: Colors.white, size: 36),
                const Spacer(),
                Text(university.city, style: const TextStyle(color: Colors.white70)),
                Text(university.name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))
              ]),
            ),
          ),
          const SizedBox(height: 24),
          Text('校园环境', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(university.environment),
          const SizedBox(height: 20),
          // 典型信息项：住宿、食堂、交通等说明
          const _InfoTile(icon: Icons.home_work_outlined, title: '住宿与生活', text: '提供校内住宿；宿舍配置、费用与校区安排以当年招生及后勤公告为准。'),
          const _InfoTile(icon: Icons.restaurant_outlined, title: '食堂与配套', text: '校内设有多处餐饮、运动与学习空间，周边生活服务便利。'),
          _InfoTile(icon: Icons.directions_transit_outlined, title: '交通与区位', text: '${university.city}，建议结合校区位置、通勤时间与实地开放日考察。'),
          const SizedBox(height: 20),
          Text('适合什么样的你？', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(university.summary),
          const SizedBox(height: 28),
          const Text('提示：校园环境为辅助信息，填报前请以高校官方招生网、校园开放日及当年招生章程为准。', style: TextStyle(color: Colors.grey))
        ]),
      );
}

// 信息条目组件：在详情页中复用的卡片样式（图标 + 标题 + 描述）
class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.title, required this.text});
  final IconData icon; // 左侧图标
  final String title; // 信息标题
  final String text; // 说明文本

  @override
  Widget build(BuildContext context) => Card(child: ListTile(leading: Icon(icon, color: const Color(0xff156B5B)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(text))));
}

// 数据中心页面：展示数据来源、录取数据与校园生活等模块的简介
class DataHubPage extends StatelessWidget {
  const DataHubPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: <Widget>[
        Text('数据中心', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        const Card(child: ListTile(leading: Icon(Icons.verified_outlined), title: Text('数据来源与更新'), subtitle: Text('规划接入教育部高校名单、省教育考试院及高校招生网公开数据；每条记录将显示年份、来源和更新时间。'))),
        const Card(child: ListTile(leading: Icon(Icons.insights_outlined), title: Text('录取数据'), subtitle: Text('按省份、选科、院校、专业和年份查询最低分、最低位次与招生计划。'))),
        const Card(child: ListTile(leading: Icon(Icons.travel_explore_outlined), title: Text('校园生活'), subtitle: Text('展示校区环境、住宿、餐饮、交通与开放日等信息，支持官方链接核验。')))
      ]);
}
