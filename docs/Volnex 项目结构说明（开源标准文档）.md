# Volnex 项目结构说明

> 本文档描述项目**真实**的目录结构与分层职责，供快速理解与二次开发。

## 一、项目概述

Volnex 是一个基于 **Flutter** 的高考志愿填报辅助应用。核心能力：依据考生 **省份 + 全省位次**，将高校按「冲 / 稳 / 保」智能分组推荐，并提供高校库、数据中心与设置。

- 状态管理 / 依赖注入：**GetX**
- 路由：**go_router**（`GetMaterialApp.router`）
- 本地存储：**shared_preferences**
- 一套代码多端编译：Android / iOS / Windows / macOS / Linux / Web

## 二、根目录结构

```text
volnex/
├── lib/                # Flutter 核心业务源码（开发重心）
├── test/               # 单元/组件测试
├── android/ ios/ web/
│   windows/ macos/ linux/   # 各平台原生工程（打包/权限，日常不动）
├── build/              # 编译产物（已被 .gitignore 忽略，可随时删除）
├── assets/             # 静态资源
├── pubspec.yaml        # 依赖与资源声明
├── pubspec.lock        # 依赖锁定（应用需纳入版本控制）
├── analysis_options.yaml   # Dart 静态分析/lint 规则
├── .githooks/          # 版本化的 git 钩子（pre-commit / commit-msg）
└── README.md           # 项目说明
```

## 三、lib 分层结构（开发重点）

采用 **入口 / 应用配置 / 控制器 / 核心 / 模型 / 服务 / 组件 / 页面 / 主题** 的分层：

```text
lib/
├── main.dart        # 入口，仅调用 app()
├── app/             # 应用启动与路由
├── controllers/     # GetX 控制器（业务状态中心）
├── core/            # 底层能力（网络、工具）
├── models/          # 数据实体
├── services/        # 启动初始化/业务服务
├── components/      # 可复用 UI 组件
├── pages/           # 业务页面
└── theme/           # 主题与配色
```

### 各层职责

| 层 | 目录 | 职责 |
|----|------|------|
| 入口 | `main.dart` → `app/app.dart` | 引擎绑定 → 全局异常捕获 → 初始化 → 启动 `GetMaterialApp.router` |
| 路由 | `app/router/` | `app_router.dart` 定义路由表；`route_paths.dart` 路径常量 |
| 状态 | `controllers/` | `HomeController`（省份/位次/高校列表/加载态）、`TabIndexController`（Tab 索引） |
| 核心 | `core/network/` `core/utils/` | 高校数据服务 + 注册表；异常捕获；按 id 解析高校 |
| 模型 | `models/university.dart` | 高校实体（名称/城市/层次/录取位次/标签等） |
| 服务 | `services/app_init_service.dart` | 初始化 SharedPreferences、预加载数据、注册全局服务 |
| 组件 | `components/common\|layout\|tab` | 卡片、页头、档案弹窗、响应式导航壳、推荐分组等 |
| 页面 | `pages/app/...` | 智能推荐、高校库、数据中心、设置、高校详情 |
| 主题 | `theme/` | 静态默认配色常量 + 响应式主题控制器（持久化） |

## 四、关键机制

- **响应式状态**：控制器用 `Rx*` 变量，页面用 `Obx` 监听，`Get.find` 获取单例。
- **响应式布局**：`home_shell.dart` 用 `LayoutBuilder` + 880px 阈值切换侧栏/底栏；`IndexedStack` 保留各 Tab 状态。
- **数据注册表**：`UniversityRegistry` 提供按 id 的同步查找，供路由在 build 前解析 URL 参数。
- **数据可替换**：`fetchUniversities()` 当前返回内置模拟数据；对接后端时替换该函数即可，上层无需改动。

## 五、开发规范

- 页面只写 UI 与交互；业务状态放 `controllers/`。
- 数据获取集中在 `core/network/`，页面经控制器间接使用，不直接发请求。
- 通用组件抽到 `components/`；固定配色/常量放 `theme/`，禁止散落硬编码。
- 所有结构化数据使用 `models/` 实体，避免手写裸 Map。

## 六、分支与协作

- `main`：主分支，受保护（禁止直接推送，需 PR 审核 + CI 通过）。
- `dev-temp-YYYYMMDD`：临时开发分支，完成后经 PR 合入 `main`。
- 提交信息遵循 Conventional Commits（见 `.githooks/commit-msg`）。
