/// Korean Hangul jamo composition engine (2-beolsik layout).
///
/// Handles the full lifecycle of Korean syllable composition:
/// - Initial consonant (초성) + vowel (중성) → syllable
/// - Syllable + final consonant (종성) → complete syllable
/// - Complete syllable + vowel → split final consonant to next syllable
/// - Compound vowels (ㅗ+ㅏ=ㅘ) and compound finals (ㄱ+ㅅ=ㄳ)
class HangulComposer {
  String _committed = '';

  // Current composition state
  int? _cho; // 초성 index (0-18)
  int? _jung; // 중성 index (0-20)
  int? _jong; // 종성 index (1-27, 0 = none)

  String get text => _committed + _composingChar;

  String get committed => _committed;

  String get composing => _composingChar;

  String get _composingChar {
    if (_cho == null) return '';
    if (_jung == null) {
      // Only initial consonant — show as jamo
      return _choToJamo[_cho!];
    }
    // Build syllable: 0xAC00 + (cho * 21 + jung) * 28 + jong
    final code = 0xAC00 + (_cho! * 21 + _jung!) * 28 + (_jong ?? 0);
    return String.fromCharCode(code);
  }

  /// Process a single jamo character input.
  void addJamo(String jamo) {
    if (_isConsonant(jamo)) {
      _addConsonant(jamo);
    } else if (_isVowel(jamo)) {
      _addVowel(jamo);
    }
  }

  void _addConsonant(String jamo) {
    final choIdx = _choIndex(jamo);

    if (_cho == null) {
      // No composition — start new with initial consonant
      _cho = choIdx;
      return;
    }

    if (_jung == null) {
      // Had only initial consonant — commit it, start new
      _committed += _choToJamo[_cho!];
      _cho = choIdx;
      return;
    }

    // Have cho + jung (possibly + jong)
    if (_jong == null) {
      // Try to add as final consonant
      final jongIdx = _jongIndexFromJamo(jamo);
      if (jongIdx != null) {
        _jong = jongIdx;
        return;
      }
      // Can't be a final consonant — commit current, start new
      _commitComposing();
      _cho = choIdx;
      return;
    }

    // Already have jong — try compound final
    final compound = _compoundJong(_jong!, jamo);
    if (compound != null) {
      _jong = compound;
      return;
    }

    // Can't compound — commit current, start new
    _commitComposing();
    _cho = choIdx;
  }

  void _addVowel(String jamo) {
    final jungIdx = _jungIndex(jamo);

    if (_cho == null) {
      // No initial consonant — commit vowel directly
      _committed += jamo;
      return;
    }

    if (_jung == null) {
      // Have initial consonant — combine
      _jung = jungIdx;
      return;
    }

    // Try compound vowel
    final compound = _compoundJung(_jung!, jungIdx);
    if (compound != null && _jong == null) {
      _jung = compound;
      return;
    }

    if (_jong == null) {
      // Already have cho+jung, no jong, can't compound vowel
      // Commit current syllable, start new with just this vowel
      _commitComposing();
      _committed += jamo;
      return;
    }

    // Have cho+jung+jong — split jong off as new cho
    final split = _splitJong(_jong!);
    if (split != null) {
      // Compound jong: keep first part, move second to new syllable
      _jong = split.$1;
      _commitComposing();
      _cho = _choIndexFromJong(split.$2);
      _jung = jungIdx;
    } else {
      // Simple jong: move entire jong to new syllable
      final jongJamo = _jongToJamo[_jong!];
      final newCho = _choIndex(jongJamo);
      _jong = null;
      _commitComposing();
      _cho = newCho;
      _jung = jungIdx;
    }
  }

  /// Delete the last element of the composition.
  void backspace() {
    if (_jong != null) {
      // Try to decompose compound jong
      final split = _splitJong(_jong!);
      if (split != null) {
        _jong = split.$1;
      } else {
        _jong = null;
      }
      return;
    }

    if (_jung != null) {
      // Try to decompose compound jung
      final split = _splitJung(_jung!);
      if (split != null) {
        _jung = split.$1;
      } else {
        _jung = null;
      }
      return;
    }

    if (_cho != null) {
      _cho = null;
      return;
    }

    // Nothing composing — delete from committed
    if (_committed.isNotEmpty) {
      // Check if last char is a Hangul syllable — decompose it
      final lastCode = _committed.codeUnitAt(_committed.length - 1);
      if (lastCode >= 0xAC00 && lastCode <= 0xD7A3) {
        _committed = _committed.substring(0, _committed.length - 1);
        final offset = lastCode - 0xAC00;
        _cho = offset ~/ (21 * 28);
        _jung = (offset ~/ 28) % 21;
        final jongVal = offset % 28;
        _jong = jongVal > 0 ? jongVal : null;
        // Remove the jong (user pressed backspace)
        if (_jong != null) {
          final split = _splitJong(_jong!);
          if (split != null) {
            _jong = split.$1;
          } else {
            _jong = null;
          }
        } else {
          // Remove jung
          final split = _splitJung(_jung!);
          if (split != null) {
            _jung = split.$1;
          } else {
            _jung = null;
          }
        }
      } else {
        _committed = _committed.substring(0, _committed.length - 1);
      }
    }
  }

  /// Commit the current composing character and reset state.
  void commit() {
    _commitComposing();
  }

  /// Clear everything.
  void reset() {
    _committed = '';
    _cho = null;
    _jung = null;
    _jong = null;
  }

  /// Set text directly (e.g., from external source).
  void setText(String text) {
    _committed = text;
    _cho = null;
    _jung = null;
    _jong = null;
  }

  void _commitComposing() {
    final c = _composingChar;
    if (c.isNotEmpty) {
      _committed += c;
    }
    _cho = null;
    _jung = null;
    _jong = null;
  }

  // ─── Jamo tables ───

  // 초성 (19): ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ
  static const _choToJamo = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
    'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  static final _choMap = {
    for (var i = 0; i < _choToJamo.length; i++) _choToJamo[i]: i,
  };

  // 중성 (21): ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ
  static const _jungToJamo = [
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ',
    'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ',
  ];

  static final _jungMap = {
    for (var i = 0; i < _jungToJamo.length; i++) _jungToJamo[i]: i,
  };

  // 종성 (28, index 0 = no final):
  // (none) ㄱ ㄲ ㄳ ㄴ ㄵ ㄶ ㄷ ㄹ ㄺ ㄻ ㄼ ㄽ ㄾ ㄿ ㅀ ㅁ ㅂ ㅄ ㅅ ㅆ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ
  static const _jongToJamo = [
    '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ',
    'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ',
    'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  // Simple jamo → jong index (single consonants only)
  static final _jongFromJamoMap = <String, int>{
    'ㄱ': 1, 'ㄲ': 2, 'ㄴ': 4, 'ㄷ': 7, 'ㄹ': 8,
    'ㅁ': 16, 'ㅂ': 17, 'ㅅ': 19, 'ㅆ': 20, 'ㅇ': 21,
    'ㅈ': 22, 'ㅊ': 23, 'ㅋ': 24, 'ㅌ': 25, 'ㅍ': 26, 'ㅎ': 27,
  };

  // jong index → cho index (for splitting)
  static final _jongToCho = <int, int>{
    1: 0, // ㄱ
    2: 1, // ㄲ
    4: 2, // ㄴ
    7: 3, // ㄷ
    8: 5, // ㄹ
    16: 6, // ㅁ
    17: 7, // ㅂ
    19: 9, // ㅅ
    20: 10, // ㅆ
    21: 11, // ㅇ
    22: 12, // ㅈ
    23: 14, // ㅊ
    24: 15, // ㅋ
    25: 16, // ㅌ
    26: 17, // ㅍ
    27: 18, // ㅎ
  };

  // Compound jongs: (base jong index, jamo) → compound jong index
  static final _compoundJongMap = <(int, String), int>{
    (1, 'ㅅ'): 3, // ㄱ+ㅅ=ㄳ
    (4, 'ㅈ'): 5, // ㄴ+ㅈ=ㄵ
    (4, 'ㅎ'): 6, // ㄴ+ㅎ=ㄶ
    (8, 'ㄱ'): 9, // ㄹ+ㄱ=ㄺ
    (8, 'ㅁ'): 10, // ㄹ+ㅁ=ㄻ
    (8, 'ㅂ'): 11, // ㄹ+ㅂ=ㄼ
    (8, 'ㅅ'): 12, // ㄹ+ㅅ=ㄽ
    (8, 'ㅌ'): 13, // ㄹ+ㅌ=ㄾ
    (8, 'ㅍ'): 14, // ㄹ+ㅍ=ㄿ
    (8, 'ㅎ'): 15, // ㄹ+ㅎ=ㅀ
    (17, 'ㅅ'): 18, // ㅂ+ㅅ=ㅄ
  };

  // Compound jong → (first jong, second jong) for splitting
  static final _compoundJongSplit = <int, (int, int)>{
    3: (1, 19), // ㄳ → ㄱ, ㅅ
    5: (4, 22), // ㄵ → ㄴ, ㅈ
    6: (4, 27), // ㄶ → ㄴ, ㅎ
    9: (8, 1), // ㄺ → ㄹ, ㄱ
    10: (8, 16), // ㄻ → ㄹ, ㅁ
    11: (8, 17), // ㄼ → ㄹ, ㅂ
    12: (8, 19), // ㄽ → ㄹ, ㅅ
    13: (8, 25), // ㄾ → ㄹ, ㅌ
    14: (8, 26), // ㄿ → ㄹ, ㅍ
    15: (8, 27), // ㅀ → ㄹ, ㅎ
    18: (17, 19), // ㅄ → ㅂ, ㅅ
  };

  // Compound jungs: (base jung index, new jung index) → compound jung index
  static final _compoundJungMap = <(int, int), int>{
    (8, 0): 9, // ㅗ+ㅏ=ㅘ
    (8, 1): 10, // ㅗ+ㅐ=ㅙ
    (8, 20): 11, // ㅗ+ㅣ=ㅚ
    (13, 4): 14, // ㅜ+ㅓ=ㅝ
    (13, 5): 15, // ㅜ+ㅔ=ㅞ
    (13, 20): 16, // ㅜ+ㅣ=ㅟ
    (18, 20): 19, // ㅡ+ㅣ=ㅢ
  };

  // Compound jung → (first jung, second jung) for backspace
  static final _compoundJungSplit = <int, (int, int)>{
    9: (8, 0), // ㅘ → ㅗ, ㅏ
    10: (8, 1), // ㅙ → ㅗ, ㅐ
    11: (8, 20), // ㅚ → ㅗ, ㅣ
    14: (13, 4), // ㅝ → ㅜ, ㅓ
    15: (13, 5), // ㅞ → ㅜ, ㅔ
    16: (13, 20), // ㅟ → ㅜ, ㅣ
    19: (18, 20), // ㅢ → ㅡ, ㅣ
  };

  // ─── Helpers ───

  bool _isConsonant(String c) => _choMap.containsKey(c);

  bool _isVowel(String c) => _jungMap.containsKey(c);

  int _choIndex(String jamo) => _choMap[jamo]!;

  int _jungIndex(String jamo) => _jungMap[jamo]!;

  int? _jongIndexFromJamo(String jamo) => _jongFromJamoMap[jamo];

  int? _choIndexFromJong(int jongIdx) => _jongToCho[jongIdx];

  int? _compoundJong(int baseJong, String jamo) =>
      _compoundJongMap[(baseJong, jamo)];

  int? _compoundJung(int baseJung, int newJung) =>
      _compoundJungMap[(baseJung, newJung)];

  /// Split a compound jong into (remaining jong, split-off jong).
  /// Returns null if jong is not compound.
  (int, int)? _splitJong(int jongIdx) => _compoundJongSplit[jongIdx];

  /// Split a compound jung into (remaining jung, split-off jung).
  /// Returns null if jung is not compound.
  (int, int)? _splitJung(int jungIdx) => _compoundJungSplit[jungIdx];
}
