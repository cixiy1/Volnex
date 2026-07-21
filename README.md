# Volnex

一个基于 Flutter 的 OpenClaw 网关客户端，用来管理本地网关连接、查看 AI 智能体配置、处理多渠道消息收发。

## 目录结构

```
lib/
├── main.dart                 # 入口
├── app/                      # 应用初始化、路由、主题、全局状态
│   ├── app.dart              # MaterialApp 根组件
│   ├── routes.dart           # 路由表
│   ├── theme.dart            # 全局主题（亮/暗）
│   └── global_state.dart     # 登录态 + 网关连接状态
├── core/                     # 底层工具、常量、基类
│   ├── constants/            # api_const.dart / app_const.dart
│   ├── utils/                # storage / toast / format / file_util
│   ├── network/              # http_client（Dio封装）/ api_service（接口）
│   └── base/                 # base_page / base_controller
├── models/                   # agent_model / channel_model / user_model
├── services/                 # 业务逻辑层
│   ├── openclaw_service.dart # 网关启停、重连、消息
│   ├── agent_service.dart    # 智能体管理
│   └── auth_service.dart     # 登录、身份校验
├── pages/                    # 页面

│   ├── home/                 # 首页
│   ├── gateway/              # 网关管理（环境检查）
│   ├── agent/                # 智能体配置
│   └── setting/              # 设置、模型下载路径
├── widgets/                  # 通用组件
│   ├── common_button.dart
│   ├── log_view.dart         # 日志框
│   ├── loading_widget.dart
│   └── sidebar_menu.dart
└── assets/                   # 图片图标等静态资源
```

## 依赖

在 `pubspec.yaml` 里加上这几个：

```yaml
dependencies:
  dio: ^5.4.0
  shared_preferences: ^2.2.2
  intl: ^0.19.0
```

## 架构说明

- **app/**：全局只初始化一次的东西放这。路由用命名路由，跳转统一走 `AppRoutes`。
- **core/**：纯工具层，不依赖业务。`http_client` 自动给请求头塞 token，`api_service` 只管拼接口。
- **services/**：把 UI 和底层逻辑隔开。页面只调 service，不直接碰网络。
- **models/**：接口返回的 JSON 直接转成 Dart 实体，`fromJson` / `toJson` 都写好了。
- **pages/**：每个模块一文件夹，`_page` 管 UI，`_controller` 管状态，基本每页一个 controller。
- **widgets/**：跨页面复用的小组件。

## 运行

```bash
flutter pub get
flutter run
```

默认连的是 `http://localhost:8080`，在 `core/constants/api_const.dart` 里改。
