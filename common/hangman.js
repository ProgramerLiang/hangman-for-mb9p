/**
 * Hangman game logic module for Mi Band 9 Pro (Vela JS)
 *
 * Handles word selection, letter guessing, win/lose detection.
 */

var Hangman = {
  /** max wrong guesses allowed */
  MAX_WRONG: 6,

  /**
   * Pick a random word from the list, avoiding recently used ones.
   * @param {Array} wordList - array of { word, hint }
   * @param {Array} usedWords - words used this session
   * @returns {{ word: string, hint: string, display: string }}
   */
  pickWord: function (wordList, usedWords) {
    var available = wordList.filter(function (item) {
      return usedWords.indexOf(item.word) === -1
    })
    if (available.length === 0) {
      available = wordList
      usedWords.length = 0
    }
    var idx = Math.floor(Math.random() * available.length)
    var chosen = available[idx]
    return {
      word: chosen.word,
      hint: chosen.hint,
      display: Hangman._maskWord(chosen.word)
    }
  },

  /**
   * Create initial underscore display for a word.
   * @param {string} word
   * @returns {string} e.g. "A P P L E" or "_ _ _ _ _"
   */
  _maskWord: function (word) {
    var parts = []
    for (var i = 0; i < word.length; i++) {
      parts.push('_')
    }
    return parts.join(' ')
  },

  /**
   * Try a letter against the secret word.
   * @param {string} letter - single uppercase letter A-Z
   * @param {string} secretWord - the word to guess
   * @param {string} currentDisplay - current display string
   * @returns {{ hit: boolean, display: string, wordComplete: boolean }}
   */
  guessLetter: function (letter, secretWord, currentDisplay) {
    if (!letter || letter.length !== 1) {
      return { hit: false, display: currentDisplay, wordComplete: false }
    }

    var upper = letter.toUpperCase()
    var displayArr = currentDisplay.split(' ')
    var hit = false

    for (var i = 0; i < secretWord.length; i++) {
      if (secretWord.charAt(i) === upper) {
        if (displayArr[i] === '_') {
          displayArr[i] = upper
          hit = true
        }
      }
    }

    var newDisplay = displayArr.join(' ')
    var wordComplete = newDisplay.indexOf('_') === -1

    return { hit: hit, display: newDisplay, wordComplete: wordComplete }
  },

  /**
   * Build initial letter button states.
   * @returns {Array} [{ char: string, disabled: boolean }]
   */
  initLetterButtons: function () {
    var letters = []
    for (var i = 0; i < 26; i++) {
      letters.push({
        char: String.fromCharCode(65 + i),
        disabled: false
      })
    }
    return letters
  },

  /**
   * Calculate score for a won game.
   * @param {string} word
   * @param {number} wrongCount
   * @returns {number}
   */
  calculateScore: function (word, wrongCount) {
    return (Hangman.MAX_WRONG - wrongCount) * 10 + word.length * 5
  },

  /**
   * Get hangman ASCII art for a given stage (0-6).
   * @param {number} stage
   * @returns {string}
   */
  getHangmanArt: function (stage) {
    var arts = [
      // 0 - empty gallows
      '    \n    \n    \n    \n',
      // 1 - post
      '    |\n    |\n    |\n    |\n',
      // 2 - head
      '    |\n  O |\n    |\n    |\n',
      // 3 - body
      '    |\n  O |\n  | |\n    |\n',
      // 4 - one arm
      '    |\n  O |\n /| |\n    |\n',
      // 5 - both arms
      '    |\n  O |\n /|\\|\n    |\n',
      // 6 - complete
      '    |\n  O |\n /|\\|\n / \\|\n'
    ]
    if (stage < 0) stage = 0
    if (stage > Hangman.MAX_WRONG) stage = Hangman.MAX_WRONG
    return arts[stage]
  }
}

module.exports = Hangman