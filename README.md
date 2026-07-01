# Hangman 猜单词 — Mi Band 9 Pro

Vela JS 小游戏，适用于小米手环 9 Pro。

## 特性

- 🎮 **猜单词游戏** — 经典的 Hangman 玩法，6 次错误机会
- 🎨 **可定制主题色** — 8 种预设颜色，自由切换
- 📳 **按键振动反馈** — 可开关，增强手感
- 🔥 **连胜计分** — 连胜越高，得分越多（连胜 × 10）
- ⌨️ **原生 QWERTY 键盘** — 三行错位布局，圆角按键
- 🌙 **暗色主题** — SimpleRSS 风格，纯黑背景 + #262626 卡片
- 📖 **500 词库** — 4–7 字母单词，带中文释义

## 界面

三屏单页状态机：

| 屏幕 | 内容 |
|------|------|
| **首页** | 最高分显示、开始游戏、设置、关于 |
| **游戏** | 单词展示、错误计数、绞刑架 ASCII 艺术、原生键盘 |
| **结果** | 正确单词 + 中文释义、连胜/得分、重玩/回菜单 |

## 致谢

- 词库源于 [MiBand-Daily-Word-Practice](https://github.com/Bingak/MiBand-Daily-Word-Practice) 的 6574 词列表
- 键盘 UI 参考 [SimpleRSS](https://github.com/yzl3014/SimpleRSS) 的暗色主题与圆角按键风格
- Developed by **Corripo**，由 **DeepSeek V4 Pro** 强力辅助

## 构建

```bash
npm install
npm run build
```

RPK 输出在 `dist/` 目录。

## 技术栈

- **Vela JS** — Xiaomi IoT 快速应用框架
- **aiot-toolkit 2.0.5** — 构建工具
- **designWidth: 336** — 适配 Mi Band 9 Pro 分辨率
- **minPlatformVersion: 1000**