#!/usr/bin/env bash
# autoresearch.sh — benchmark harness for Hangman Vela JS project
# Validates: documentation + source code implementation

set -euo pipefail
FAIL=0

REPO="$(cd "$(dirname "$0")" && pwd)"

# ---- Metrics ----
doc_total=0
doc_passed=0

check() {
    local name="$1" desc="$2"
    doc_total=$((doc_total + 1))
    if eval "$3" 2>/dev/null; then
        doc_passed=$((doc_passed + 1))
        echo "  PASS: $desc"
    else
        echo "  FAIL: $desc"
        FAIL=1
    fi
}

echo "=== Hangman Vela JS Project Harness ==="

# ---- 1. Documentation ----
check "doc_exists" "DEVELOPMENT.md exists" \
    'test -s "$REPO/DEVELOPMENT.md"'

check "doc_overview" "Contains Game Overview section" \
    'grep -q "## 1. Game Overview" "$REPO/DEVELOPMENT.md"'

check "doc_platform" "Contains Platform Constraints section" \
    'grep -q "## 2. Platform Constraints" "$REPO/DEVELOPMENT.md"'

check "doc_pages" "Contains Page Architecture section" \
    'grep -q "## 3. Page Architecture" "$REPO/DEVELOPMENT.md"'

check "doc_components" "Contains Component Details section" \
    'grep -q "## 4. Component Details" "$REPO/DEVELOPMENT.md"'

check "doc_logic" "Contains Game Logic section" \
    'grep -q "## 5. Game Logic" "$REPO/DEVELOPMENT.md"'

check "doc_dict" "Contains Word Dictionary section" \
    'grep -q "## 6. Word Dictionary" "$REPO/DEVELOPMENT.md"'

check "doc_steps" "Contains Development Steps section" \
    'grep -q "## 7. Development Steps" "$REPO/DEVELOPMENT.md"'

check "doc_struct" "Contains Vela JS App Structure section" \
    'grep -q "## 8. Vela JS App Structure" "$REPO/DEVELOPMENT.md"'

check "doc_refs" "Contains References section" \
    'grep -q "## 9. References" "$REPO/DEVELOPMENT.md"'

check "doc_size" "DEVELOPMENT.md >= 5000 bytes" \
    'test "$(wc -c < "$REPO/DEVELOPMENT.md")" -ge 5000'

check "doc_components_listed" "Lists vela components (div, text, span, input, image)" \
    'grep -qi "div" "$REPO/DEVELOPMENT.md" && grep -qi "text" "$REPO/DEVELOPMENT.md" && grep -qi "span" "$REPO/DEVELOPMENT.md" && grep -qi "input" "$REPO/DEVELOPMENT.md" && grep -qi "image" "$REPO/DEVELOPMENT.md"'

check "doc_features_listed" "Lists vela features (storage, router, prompt)" \
    'grep -qi "system.storage" "$REPO/DEVELOPMENT.md" && grep -qi "system.router" "$REPO/DEVELOPMENT.md" && grep -qi "system.prompt" "$REPO/DEVELOPMENT.md"'

check "doc_strikes" "Describes 6-strike mechanic" \
    'grep -qi "6.*wrong\|6.*strike\|maxWrong\|max_wrong" "$REPO/DEVELOPMENT.md"'

check "doc_screens" "Describes screen layouts (menu, playing, result)" \
    'grep -qi "menu" "$REPO/DEVELOPMENT.md" && grep -qi "playing" "$REPO/DEVELOPMENT.md" && grep -qi "result" "$REPO/DEVELOPMENT.md"'

check "doc_state_model" "Describes game state model" \
    'grep -qi "secretWord\|secret.*word" "$REPO/DEVELOPMENT.md" && grep -qi "wrongCount\|wrong.*count" "$REPO/DEVELOPMENT.md"'

check "doc_words" "Contains example word list with hints" \
    'grep -qi "apple\|house\|water\|cloud\|dream" "$REPO/DEVELOPMENT.md" && grep -qi "hint" "$REPO/DEVELOPMENT.md"'

check "doc_design" "Contains key design decisions" \
    'grep -qi "关键设计决策\|design decision" "$REPO/DEVELOPMENT.md"'

# ---- 2. Vela docs integrity ----
check "vela_components" "vela_docs/components/index.md exists" \
    'test -f "$REPO/vela_docs/components/index.md"'

check "vela_features" "vela_docs/features/index.md exists" \
    'test -f "$REPO/vela_docs/features/index.md"'

check "vela_grammar" "vela_docs/features/grammar.md exists" \
    'test -f "$REPO/vela_docs/features/grammar.md"'

# ---- 3. Source code: manifest.json ----
check "manifest_exists" "manifest.json exists" \
    'test -s "$REPO/manifest.json"'

check "manifest_features" "manifest.json declares storage + prompt" \
    'grep -qi "system.storage" "$REPO/manifest.json" && grep -qi "system.prompt" "$REPO/manifest.json"'

check "manifest_package" "manifest.json has package name" \
    'grep -qi "package" "$REPO/manifest.json"'

check "manifest_version" "manifest.json has version" \
    'grep -qi "versionName" "$REPO/manifest.json"'

# ---- 4. Source code: common/words.js ----
check "words_exists" "common/words.js exists" \
    'test -s "$REPO/common/words.js"'

check "words_export" "words.js exports word list" \
    'grep -qi "module.exports" "$REPO/common/words.js"'

check "words_count" "words.js has >= 50 word entries" \
    'test "$(grep -c "word:" "$REPO/common/words.js")" -ge 50'

check "words_hints" "words.js entries have hints" \
    'grep -qi "hint:" "$REPO/common/words.js"'

# ---- 5. Source code: common/hangman.js ----
check "logic_exists" "common/hangman.js exists" \
    'test -s "$REPO/common/hangman.js"'

check "logic_export" "hangman.js exports module" \
    'grep -qi "module.exports" "$REPO/common/hangman.js"'

check "logic_pickword" "hangman.js has pickWord function" \
    'grep -qi "pickWord" "$REPO/common/hangman.js"'

check "logic_guess" "hangman.js has guessLetter function" \
    'grep -qi "guessLetter" "$REPO/common/hangman.js"'

check "logic_score" "hangman.js has calculateScore function" \
    'grep -qi "calculateScore" "$REPO/common/hangman.js"'

check "logic_art" "hangman.js has getHangmanArt function" \
    'grep -qi "getHangmanArt" "$REPO/common/hangman.js"'

check "logic_max" "hangman.js defines MAX_WRONG = 6" \
    'grep -qi "MAX_WRONG.*6\|max.*wrong.*6" "$REPO/common/hangman.js"'

check "logic_init" "hangman.js has initLetterButtons" \
    'grep -qi "initLetterButtons" "$REPO/common/hangman.js"'

# ---- 6. Source code: pages/index/index.ux ----
check "ux_exists" "pages/index/index.ux exists" \
    'test -s "$REPO/pages/index/index.ux"'

check "ux_template" "index.ux has <template> section" \
    'grep -qi "<template>" "$REPO/pages/index/index.ux"'

check "ux_style" "index.ux has <style> section" \
    'grep -qi "<style>" "$REPO/pages/index/index.ux"'

check "ux_script" "index.ux has <script> section" \
    'grep -qi "<script>" "$REPO/pages/index/index.ux"'

check "ux_screens" "index.ux has 3 screens (menu/playing/result)" \
    'grep -qi "menu" "$REPO/pages/index/index.ux" && grep -qi "playing" "$REPO/pages/index/index.ux" && grep -qi "result" "$REPO/pages/index/index.ux"'

check "ux_require" "index.ux requires hangman + words modules" \
    'grep -qi "hangman.js" "$REPO/pages/index/index.ux" && grep -qi "words.js" "$REPO/pages/index/index.ux"'

check "ux_storage" "index.ux uses system.storage" \
    'grep -qi "system.storage" "$REPO/pages/index/index.ux"'

check "ux_onstart" "index.ux has onStartGame handler" \
    'grep -qi "onStartGame" "$REPO/pages/index/index.ux"'

check "ux_onletter" "index.ux has onLetterClick handler" \
    'grep -qi "onLetterClick" "$REPO/pages/index/index.ux"'

check "ux_ongomenu" "index.ux has onGoMenu handler" \
    'grep -qi "onGoMenu" "$REPO/pages/index/index.ux"'

check "ux_for" "index.ux uses for directive for letter grid" \
    'grep -qi "for=" "$REPO/pages/index/index.ux"'

check "ux_if" "index.ux uses if directive for screen switching" \
    'grep -qi "if=" "$REPO/pages/index/index.ux"'

check "ux_click" "index.ux uses @click event binding" \
    'grep -qi "@click" "$REPO/pages/index/index.ux"'

check "ux_dark" "index.ux has dark theme (#1a1a2e)" \
    'grep -qi "1a1a2e" "$REPO/pages/index/index.ux"'

check "ux_private" "index.ux has private data block" \
    'grep -qi "private" "$REPO/pages/index/index.ux"'

check "ux_oninit" "index.ux has onInit lifecycle" \
    'grep -qi "onInit" "$REPO/pages/index/index.ux"'

# ---- Compute primary metric ----
completeness=$(( doc_passed * 100 / doc_total ))

echo ""
echo "--- Results ---"
echo "  Checks passed: ${doc_passed}/${doc_total}"
echo "  Completeness:  ${completeness}%"

# ---- Emit METRIC lines ----
echo "METRIC completeness=${completeness}"
echo "METRIC checks_passed=${doc_passed}"
echo "METRIC files_created=4"

exit $FAIL