# Hangman Game for Xiaomi Mi Band 9 Pro (Vela JS)

## 1. Game Overview

Hangman is a word-guessing game. One player (the host) picks a secret word, and the
other player(s) guess letters one at a time. Correct guesses fill in the word's
blanks; wrong guesses advance a hangman drawing. The guesser wins by completing
the word before the drawing is finished.

### Core Mechanics (for single-player + AI host)

- **Secret word**: pre-selected from a dictionary list (English).
- **Guesses**: player picks one letter per turn from the 26-letter alphabet.
- **Reveal**: correct letter → fill all occurrences; wrong letter → +1 strike.
- **Strikes**: 6 wrong guesses → game over (hangman complete).
- **Win condition**: all letters revealed before 6 strikes.
- **Hint/category**: optional, improve UX on a small screen.

### Drawing stages (6 strikes)

```
1. Gallows post        (upside-down L)
2. Head                (circle below gallows bar)
3. Body                (vertical line from head)
4. Left arm            (horizontal from body)
5. Right arm           (horizontal from body)
6. Leg                 (diagonal from body bottom)
```

## 2. Platform Constraints (Mi Band 9 Pro / Vela JS)

### Screen
- Small rectangular watch/band screen (~192×490 or similar).
- Touch input only (no keyboard).
- Device info via `system.device`: `screenWidth`, `screenHeight`, `screenDensity`.
- Use `device.getInfo()` at startup to adapt layout.

### Display Components (from vela_docs)

| Component | Use in Hangman |
|-----------|----------------|
| `<div>`   | Layout container, flexbox rows/columns |
| `<text>`  | Display word blanks, guessed letters, status messages |
| `<span>`  | Styled sub-text within `<text>` (colored letters) |
| `<image>` | Optional: hangman drawing as PNG frames |
| `<input>` | Button type for letter input, checkbox/radio not needed |
| `<stack>` | Overlay layers (e.g., hangman image + word text) |

### Styling
- Flexbox layout (`flex-direction: row|column`, `justify-content`, `align-items`).
- Only `px` units; no `%` for borders/margins in some properties.
- `position: absolute|relative` for precise placement.
- Colors: hex or rgba.
- `display: flex|none` for show/hide.
- `visibility: visible|hidden` alternative.
- Text: `font-size`, `color`, `font-weight`, `text-align`, `lines`, `text-overflow`.
- Box: `padding`, `margin`, `border`, `border-radius`, `background-color`, `box-shadow`.

### Events
- `click` / `@click` — primary interaction for letter buttons.
- `touchstart`, `touchmove`, `touchend` — for swipe or custom gestures.
- `longpress` — maybe for hint or reset.
- `swipe` — direction detection (`left`, `right`, `up`, `down`).

### Data Storage (`system.storage`)
- `storage.get({ key, success, fail })` — read highscores, settings.
- `storage.set({ key, value, success, fail })` — persist.
- Key-value only, values are strings.

### Available Features

| Feature | Module | Purpose |
|---------|--------|---------|
| `system.storage` | `@system.storage` | Save high scores, game state |
| `system.router` | `@system.router` | Navigate between pages |
| `system.prompt` | `@system.prompt` | Toast notifications |
| `system.app` | `@system.app` | App info, terminate |
| `system.device` | `@system.device` | Screen dimensions |
| `system.audio` | `@system.audio` | Sound effects (optional) |

### Manifest Configuration
```json
{
  "features": [
    { "name": "system.storage" },
    { "name": "system.prompt" }
  ]
}
```

## 3. Page Architecture

### 3.1 Page Structure

Given the small screen, a single-page with state switching is recommended
(no router overhead, faster transitions).

```
App State:
  MENU    -> main menu
  PLAYING -> game in progress
  RESULT  -> show result (win/lose)
```

### 3.2 Game State Model

```javascript
// In <script>
export default {
  private: {
    screen: 'menu',            // 'menu' | 'playing' | 'result'
    secretWord: '',            // the word to guess
    wordDisplay: '',           // e.g. "_ _ p p e _"
    guessedLetters: '',        // letters already tried
    wrongCount: 0,             // 0..6
    maxWrong: 6,
    win: false,
    score: 0,

    message: '',
    letterButtons: [],         // 26 letter states: { char, disabled }
    hangmanArt: '',            // ASCII art string for current stage
    highScore: 0,
    showHint: false,
    currentHint: '',

    _usedWords: []             // track used words per session
  }
}
```

### 3.3 UI Layout (Single Page)

#### Screen: MENU
```
+-------------------+
| HANGMAN           |  标题
| 猜单词游戏         |  副标题
|                    |
| [开始游戏]         |  按钮
|  最高分: 120       |  分数显示
+-------------------+
```

#### Screen: PLAYING
```
+-------------------+
| _ _ _ _ _         |  单词显示（空格分隔字母）
| 提示: 一种水果     |  提示文字
|                    |
|    |               |
|  O |               |  ASCII 挂人画（6 阶段）
| /|\|               |
| / \|               |
|                    |
| 错误: 2/6          |  错误计数
|                    |
| A B C D E F G H   |  字母按钮网格（7×4）
| I J K L M N O P   |
| Q R S T U V W X   |
| Y Z               |
+-------------------+
```

#### Screen: RESULT
```
+-------------------+
| 恭喜过关!          |  结果标题（红=输，金=赢）
| 单词: APPLE       |
| 得分: 100         |
|                    |
| [再来一局]         |  按钮
| [返回菜单]         |  按钮
+-------------------+
```

## 4. Component Details

### Word Display
- `<text>` with large font, letters separated by spaces.
- Underscores for unguessed letters, revealed letter once guessed.

### Hangman Drawing
- ASCII art using `<text>` with preformatted multiline string.
- 7 stages (0-6): empty gallows → head → body → arms → legs → complete.
- No image assets needed, pure text rendering.

### Letter Input Grid
- `<div>` clickable elements in a flex-wrap grid (7 columns × 4 rows).
- Each cell: 36px square with letter character.
- After guess: disabled state via `opacity: 0.4` + gray background.
- Click handler reads `data-letter` attribute from event target.

### Status Bar
- Wrong guesses counter: `<text>` showing `错误: N/6`.
- Hint text shown when `showHint` is true.

## 5. Game Logic (Pseudocode)

```
onStartGame():
  pick unplayed word from wordList
  set secretWord
  compute initial wordDisplay as underscores
  clear guessedLetters
  reset wrongCount to 0
  reset hangmanArt to stage 0
  enable all letter buttons
  switch screen to 'playing'

onLetterClick(letter):
  if letter already guessed -> ignore
  mark letter as guessed (disable button)
  add to guessedLetters

  if letter is in secretWord:
    update wordDisplay (reveal all occurrences)
    if wordDisplay has no underscores -> WIN
      call onWin()
  else:
    wrongCount++
    hangmanArt = getHangmanArt(wrongCount)
    if wrongCount >= maxWrong -> LOSE
      call onLose()

onWin():
  calculate score = (maxWrong - wrongCount) * 10 + word length * 5
  save score to high score if better
  switch screen to 'result' with win=true

onLose():
  reveal full word
  switch screen to 'result' with win=false

onPlayAgain():
  onStartGame()

onGoMenu():
  switch screen to 'menu'
```

## 6. Word Dictionary

Embed ~60 common English words with Chinese hints. All words 4-7 letters.

| Word | Hint |
|------|------|
| APPLE | 一种水果 |
| HOUSE | 居住的建筑 |
| WATER | 每天都要喝的 |
| CLOUD | 在天上飘的 |
| DREAM | 睡觉时发生的 |
| ... | ... |

Words should be 4-7 letters for balanced difficulty on a small screen.

## 7. Development Steps

1. Scaffold Vela JS project structure (manifest, pages, common)
2. Create `manifest.json` with storage + prompt features
3. Implement single-page layout (menu/playing/result)
4. Implement game logic (word selection, letter validation, win/lose)
5. Implement hangman drawing (ASCII art method)
6. Implement letter input grid
7. Add storage for high scores
8. Polish: dark theme, Chinese hints
9. Test on device/simulator

## 8. Vela JS App Structure

```
hangman/
  manifest.json           # 应用配置：包名、接口声明、权限
  pages/
    index/
      index.ux             # 主页面：template + style + script（单页面三态）
  common/
    words.js               # 词库：60 个 4-7 字母英文单词 + 中文提示
    hangman.js             # 游戏逻辑：选词、猜字母、计分、ASCII 挂人画
```

### 已实现文件清单

| 文件 | 用途 |
|------|------|
| `manifest.json` | 声明 `system.storage`、`system.prompt` 接口 |
| `common/words.js` | 60 词条，每个含 `word` + 中文 `hint` |
| `common/hangman.js` | `pickWord()`、`guessLetter()`、`calculateScore()`、`getHangmanArt()` |
| `pages/index/index.ux` | 三屏界面：menu / playing / result |

### 关键设计决策

1. **单页面三态（screen: menu/playing/result）** — 无需 router，减少开销
2. **ASCII 挂人画** — 不用图片资源，6 阶段纯文本渲染
3. **60 词词库** — 4-7 字母，每局不重复（用完重置）
4. **字母网格** — 触屏友好 36px 方块，猜过后变灰禁用
5. **中文提示** — 所有 hint 均为中文，方便理解
6. **storage** — 持久化最高分，每次赢局自动检查更新
7. **深色主题** — `#1a1a2e` 背景 + `#e94560` 红色高亮，适配手表 OLED 屏

## 9. References

- Xiaomi Vela JS Docs: https://iot.mi.com/vela/quickapp/zh/
- Components: text, div, span, input, image, stack
- Features: storage, router, prompt, device
- Common styles: flexbox, colors, borders
- Hangman rules: Wikipedia, wikiHow