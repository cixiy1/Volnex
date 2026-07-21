// 学校详情页：展示更丰富的学校信息与若干信息项卡片
//
// universityId 由路由传入，本页调用 resolveUniversity(id) 解析为 University 对象后展示。
// 解析失败时回退首页。

// Flutter 的 Material Design 组件库，提供 UI 基础组件
import 'package:flutter/material.dart';
// GoRouter 的路由导航包，提供声明式路由功能
// context.go() 用于编程式导航到指定路由
import 'package:go_router/go_router.dart';
// 自定义 University 数据模型，包含学校的完整信息
import 'package:volnex/models/university.dart';
// 自定义工具函数，用于根据 universityId 解析出 University 对象
import 'package:volnex/core/utils/university_resolver.dart';
// 自定义路由路径常量，定义了应用中所有路由的路径字符串
import 'package:volnex/app/router/route_paths.dart';
// 自定义信息项卡片组件，用于显示图标+标题+文本的信息项
import 'package:volnex/components/common/info_tile.dart';

/// 学校详情页面组件
///
/// 继承自 StatelessWidget，表示这是一个无状态的 UI 组件
/// 功能：展示单个学校的详细信息，包括基本信息、校园环境、住宿生活等
///
/// 路由参数：
/// - universityId: 从 URL 路径参数传入的学校 ID，用于解析学校数据
class UniversityDetailPage extends StatelessWidget {
  /// 构造函数
  ///
  /// @param universityId URL 路径参数，学校的唯一标识符
  /// {super.key} 是 Flutter 推荐的 key 传递方式
  const UniversityDetailPage({super.key, required this.universityId});

  /// URL 路径参数 id
  ///
  /// 该参数由 GoRouter 路由系统从 URL 中解析并传入
  /// 类型为 String?（可空），因为路由参数可能不存在或为空
  /// 使用此 ID 调用 resolveUniversity() 获取学校数据
  final String? universityId;

  /// 构建 UI 组件树
  ///
  /// @param context BuildContext 对象，提供组件在树中的位置信息
  /// @return Widget 返回该页面的完整组件树
  @override
  Widget build(BuildContext context) {
    // 调用 resolveUniversity 工具函数解析学校数据
    // 传入从路由获取的 universityId
    // 返回 University? 类型，如果解析失败则返回 null
    final University? university = resolveUniversity(universityId);

    // 处理学校数据解析失败的情况
    if (university == null) {
      // WidgetsBinding.instance.addPostFrameCallback 用于在当前帧渲染完成后执行回调
      // 这里用于在解析失败时导航回首页，避免在 build 方法中直接进行导航
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 检查 context 是否仍然挂载（mounted），避免使用已销毁的 context
        if (context.mounted) {
          // 使用 GoRouter 的 context.go() 方法导航到首页
          // RoutePaths.home 是首页的路由路径常量
          context.go(RoutePaths.home);
        }
      });
      // 在导航执行前，先显示一个加载指示器作为过渡 UI
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 将可空的 University 赋值给非空变量 u，便于后续使用
    // 此时已经确保 university 不为 null
    final University u = university;

    // 返回 Scaffold 作为页面的基础布局结构
    return Scaffold(
      // appBar 设置页面的应用栏
      appBar: AppBar(
        // title 显示学校名称作为页面标题
        title: Text(u.name),
      ),
      // body 设置页面的主体内容
      body: ListView(
        // 设置内边距为 24 逻辑像素，使内容不贴边
        padding: const EdgeInsets.all(24),
        // children 是 ListView 的子组件列表
        children: <Widget>[
          // 顶部大卡片：以学校主题色渐变背景展示学校基本信息
          Container(
            // 设置卡片高度为 170 逻辑像素
            height: 170,
            // decoration 设置容器的装饰样式
            decoration: BoxDecoration(
              // LinearGradient 创建线性渐变背景
              gradient: LinearGradient(
                // colors 定义渐变的颜色数组
                // 从学校的主题色 u.color 渐变到半透明的主题色
                // withValues(alpha: 0.55) 将颜色透明度设为 55%
                colors: <Color>[u.color, u.color.withValues(alpha: 0.55)],
              ),
              // borderRadius 设置圆角，半径为 24 逻辑像素
              borderRadius: BorderRadius.circular(24),
            ),
            // child 设置容器的子组件
            child: Padding(
              // 设置内边距为 22 逻辑像素
              padding: const EdgeInsets.all(22),
              // Column 用于纵向排列子组件
              child: Column(
                // 设置子组件左对齐
                crossAxisAlignment: CrossAxisAlignment.start,
                // children 是 Column 的子组件列表
                children: <Widget>[
                  // 顶部图标：使用公园图标代表校园环境
                  // 设置为白色，大小 36 逻辑像素
                  const Icon(Icons.park, color: Colors.white, size: 36),
                  // Spacer 占据剩余空间，将下面的内容推到底部
                  const Spacer(),
                  // 显示学校所在城市
                  // 使用白色70%透明度的文本样式
                  Text(u.city, style: const TextStyle(color: Colors.white70)),
                  // 显示学校名称
                  // 使用白色粗体大号文本（28 号字体）
                  Text(
                    u.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 垂直间距组件，高度 24 逻辑像素
          const SizedBox(height: 24),

          // 校园环境标题
          // 使用主题的 titleLarge 样式，并加粗显示
          Text(
            '校园环境',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),

          // 垂直间距组件，高度 8 逻辑像素
          const SizedBox(height: 8),

          // 显示学校的环境描述文本
          Text(u.environment),

          // 垂直间距组件，高度 20 逻辑像素
          const SizedBox(height: 20),

          // 住宿与生活信息卡片
          const InfoTile(
            // icon 设置左侧图标
            icon: Icons.home_work_outlined,
            // title 设置标题
            title: '住宿与生活',
            // text 设置详细说明文本
            text: '提供校内住宿；宿舍配置、费用与校区安排以当年招生及后勤公告为准。',
          ),

          // 食堂与配套信息卡片
          const InfoTile(
            // icon 使用餐厅图标
            icon: Icons.restaurant_outlined,
            title: '食堂与配套',
            text: '校内设有多处餐饮、运动与学习空间，周边生活服务便利。',
          ),

          // 交通与区位信息卡片
          // 使用 InfoTile 构造函数（非 const），因为 text 内容包含变量
          InfoTile(
            // icon 使用交通图标
            icon: Icons.directions_transit_outlined,
            title: '交通与区位',
            // text 使用字符串插值，包含学校所在城市信息
            text: '${u.city}，建议结合校区位置、通勤时间与实地开放日考察。',
          ),

          // 垂直间距组件，高度 20 逻辑像素
          const SizedBox(height: 20),

          // 适合什么样的你？标题
          Text(
            '适合什么样的你？',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),

          // 垂直间距组件，高度 8 逻辑像素
          const SizedBox(height: 8),

          // 显示学校的适合人群描述文本
          Text(u.summary),

          // 垂直间距组件，高度 28 逻辑像素
          const SizedBox(height: 28),

          // 底部提示文本
          // 提醒用户以官方信息为准
          const Text(
            '提示：校园环境为辅助信息，填报前请以高校官方招生网、校园开放日及当年招生章程为准。',
            // 使用灰色文本样式
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
