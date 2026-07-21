# Volnex · 高考志愿助手

一个基于 **Flutter** 的高考志愿填报辅助应用：根据考生的 **省份 + 全省位次**，把高校按「冲 / 稳 / 保」智能分组推荐，并提供高校库浏览、数据中心与个性化设置。响应式布局，一套代码适配手机 / 平板 / 桌面 / Web。

## 技术栈

| 领域 | 选型 |
|------|------|
| UI | Flutter + Material 3 |
| 状态管理 / 依赖注入 | [GetX](https://pub.dev/packages/get)（`GetxController` + `Obx` + `Get.find`） |
| 路由 | [go_router](https://pub.dev/packages/go_router)（声明式路由 `GetMaterialApp.router`） |
| 本地持久化 | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| 图标 | material_symbols_icons / cupertino_icons |

## 目录结构

```
lib/
├── main.dart                       # 入口，仅调用 app()
├── app/
│   ├── app.dart                    # 启动链：绑定引擎→异常捕获→初始化→GetMaterialApp.router
│   └── router/
│       ├── app_router.dart         # GoRouter 路由表（home / universityDetail）
│       ├── route_paths.dart        # 路由路径常量
│       └── page_routes.dart        # 路由占位/辅助
├── controllers/                    # GetX 控制器（业务状态中心）
│   ├── home_controller.dart        # 考生档案(省份/位次) + 高校列表 + 加载态
│   └── tab_index_controller.dart   # 底部/侧栏 Tab 当前索引
├── core/
│   ├── network/
│   │   └── university_service.dart  # 高校数据获取(当前为模拟) + UniversityRegistry 注册表
│   └── utils/
│       ├── error_util.dart          # 全局异常捕获
│       └── university_resolver.dart # 按 id 解析高校(供路由使用)
├── models/
│   └── university.dart             # 高校数据模型
├── services/
│   └── app_init_service.dart       # 启动初始化：SharedPreferences / 预加载数据 / 注册服务
├── components/                     # 可复用 UI 组件
│   ├── common/                     # info_tile / page_header / profile_sheet / university_card
│   ├── layout/                     # home_shell（响应式导航壳）
│   ├── tab/                        # home_tab / recommendation_group
│   └── state/
├── pages/                          # 页面
│   └── app/
│       ├── home_tab/               # recommendation / university_library / data_hub / settings
│       └── university_detail_page.dart
├── theme/
│   ├── app_color.dart              # 静态默认配色常量
│   └── theme_controller.dart       # 响应式主题(种子色/背景色) + 持久化
└── assets/                         # 静态资源
```

> 说明：`lib/pages/shell_page.dart.bak` 为旧布局备份文件，非活动代码。

## 核心逻辑

- **考生档案**：默认 `广东 / 位次 18000`，点顶部「我的档案」在 `ProfileSheet` 修改；`HomeController.updateProfile()` 更新后所有 `Obx` 自动刷新。
- **智能推荐（冲/稳/保）**：`recommendation_page.dart` 按考生位次与高校 `cutoffRank` 的差距分组。
- **响应式布局**：`home_shell.dart` 用 `LayoutBuilder`，宽度 ≥ 880 用 `NavigationRail`（侧栏），否则用底部 `NavigationBar`；`IndexedStack` 保留各 Tab 状态。
- **数据层**：`fetchUniversities()` 目前返回内置模拟数据并写入 `UniversityRegistry`，对接真实后端时替换此函数即可。

## 运行

```bash
flutter pub get
flutter run
```

## 目录约定

- 页面只写 UI 与交互，业务状态放 `controllers/`（GetX）。
- 数据获取放 `core/network/`，页面通过控制器间接使用，不直接发请求。
- 跨页面复用的小组件放 `components/`。
- 固定配色/常量放 `theme/`，避免散落硬编码。

## 分支与协作

- `main`：主分支（受保护，禁止直接推送，需 PR 审核 + CI 通过）。
- `dev-temp-YYYYMMDD` 等：临时开发分支，功能完成后经 PR 合入 `main`。
