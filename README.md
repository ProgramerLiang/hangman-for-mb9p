# Hangman for Mi Band 9 Pro 🎮

猜单词游戏（Hangman）—— 专为 Xiaomi Mi Band 9 Pro 设计的 Vela JS 小程序。

![Platform](https://img.shields.io/badge/platform-Vela%20JS-blue)
![Band](https://img.shields.io/badge/device-Mi%20Band%209%20Pro-orange)
![Version](https://img.shields.io/badge/version-1.0.0-brightgreen)

## 功能

- **3200+ 单词词库** — 4–7 个字母的常用英语单词，附带中文释义
- **可自定义主题色** — 8 种预设配色（红 / 蓝 / 青 / 橙 / 紫 / 粉 / 天蓝 / 黄绿）
- **横向滚动键盘** — 大键帽（56×56px），三行 QWERTY 错排布局，左右滑动浏览
- **连胜计分** — 连胜次数 × 10 = 得分，中断清零，激励连续闯关
- **振动反馈** — 每次按键可选触感反馈，可开关
- **记录最高分** — 持久化存储，关设备不丢失

## 界面

| 主菜单 | 游戏中 | 结果页 |
|--------|--------|--------|
| 显示最高分 | 单词/释义/吊人画 | 胜负结果 + 连胜数 |

| 键盘 | 设置 | 关于 |
|------|------|------|
| 横向滚动 QWERTY | 8 色主题 + 振动开关 | 开发者 & 技术栈信息 |

## 技术栈

| 层级 | 技术 |
|------|------|
| 平台 | Xiaomi Vela JS (Quick App) |
| 构建 | aiot-toolkit 2.0.5 |
| 运行时 | Node.js v24.17.0, Linux x64 |
| 语言 | JavaScript ES5 (CommonJS) |
| UI | 纯 `<div>` / `<text>` / `<scroll>` 组件，深色主题 |

## 项目结构

```
hangman/
├── src/
│   ├── manifest.json          # 应用配置（权限/特性声明）
│   ├── app.ux                 # 应用入口
│   ├── common/
│   │   ├── hangman.js         # 游戏核心逻辑
│   │   └── words.js           # 3200 词库（紧凑扁平数组）
│   └── pages/index/
│       └── index.ux           # 主页面（菜单/游戏/设置/结果/键盘）
├── package.json
└── README.md
```

## 构建 & 部署

```bash
# 安装依赖
npm install

# 构建调试包
npm run build
# → dist/com.corripo.hangman.debug.1.0.0.rpk

# 构建发布包
npm run release

# 侧载到手表：通过工具或 adb 安装 RPK
```

## 设计参考

- **词库**：来自 [Bingak/MiBand-Daily-Word-Practice](https://github.com/Bingak/MiBand-Daily-Word-Practice) 的大学英语四级词库，经去重和筛选后保留 3200 个 4–7 字母单词
- **键盘 UI**：参考 [yzl3014/SimpleRSS](https://github.com/yzl3014/SimpleRSS) 的 InputMethod 组件风格 —— 大圆角键帽、三行错排、横向滚动

## 开发者

- **Developed by** Corripo
- **AI 辅助**：DeepSeek V4 Pro
- **设备**：Xiaomi Mi Band 9 Pro
- **平台**：Vela JS (Quick App Framework)

---

© 2026 Corripo. Built with ❤️ and AI.
