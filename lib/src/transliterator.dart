import 'tables.dart';

// Precomposed chillu letters (a chillu is a single code point, not the
// base letter + virama): ൻ U+0D7B, ൽ U+0D7D, ൾ U+0D7E, ണ് U+0D7A,
// ർ U+0D7C. The virama forms (ന്, ല്, …) are used only inside conjuncts.
const _chilluN = '\u0D7B';
const _chilluL = '\u0D7D';
const _chilluLL = '\u0D7E';
const _chilluNN = '\u0D7A';
const _chilluR = '\u0D7C';

/// Transliterates Manglish (Malayalam written in Latin script) to Malayalam
/// script.
///
/// The scheme is Mozhi-style and rule-based, so it works fully offline with
/// zero dependencies. See the README for the scheme rules and the cases
/// where a capital letter or the exceptions table resolves an ambiguity.
///
/// ```dart
/// final t = ManglishTransliterator();
/// t.transliterate('namaskaram, enikku vishannu'); // നമസ്കാരം, എനിക്ക് വിശന്നു
/// 'kEralam'.toMalayalam(); // കേരളം
/// ```
class ManglishTransliterator {
  /// Creates a transliterator.
  ///
  /// When [malayalamDigits] is true, ASCII digits are rendered as Malayalam
  /// digits (൦–൯); otherwise they pass through unchanged.
  const ManglishTransliterator({this.malayalamDigits = false});

  final bool malayalamDigits;

  /// Transliterates [input] from Manglish to Malayalam script.
  ///
  /// Non-letters (spaces, punctuation, digits, Malayalam text already in
  /// the input) pass through unchanged.
  String transliterate(String input) {
    final out = StringBuffer();
    var i = 0;
    while (i < input.length) {
      final ch = input[i];
      if (_isAsciiLetter(ch)) {
        var j = i;
        while (j < input.length && _isAsciiLetter(input[j])) {
          j++;
        }
        out.write(_transliterateWord(input.substring(i, j)));
        i = j;
      } else if (malayalamDigits && _isDigit(ch)) {
        out.write(malayalamDigitChars[ch]);
        i++;
      } else {
        out.write(ch);
        i++;
      }
    }
    return out.toString();
  }

  String _transliterateWord(String word) {
    final lower = word.toLowerCase();
    final exception = exceptions[lower];
    if (exception != null) return exception;
    return _buildWord(_tokenize(word));
  }
}

/// Transliterates [input] from Manglish to Malayalam script.
String transliterateManglish(
  String input, {
  bool malayalamDigits = false,
}) =>
    ManglishTransliterator(malayalamDigits: malayalamDigits)
        .transliterate(input);

/// String extension for one-line transliteration.
extension ManglishExtension on String {
  /// Transliterates this Manglish string to Malayalam script.
  String toMalayalam({bool malayalamDigits = false}) =>
      transliterateManglish(this, malayalamDigits: malayalamDigits);
}

bool _isAsciiLetter(String ch) {
  final code = ch.codeUnitAt(0);
  return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
}

bool _isDigit(String ch) {
  final code = ch.codeUnitAt(0);
  return code >= 48 && code <= 57;
}

/// A token produced by the scanner: either a consonant or a vowel.
sealed class _Unit {}

class _ConsonantUnit extends _Unit {
  _ConsonantUnit(this.id);

  final String id;

  Consonant get consonant => consonants[id]!;
}

class _VowelUnit extends _Unit {
  _VowelUnit(this.id);

  final String id;

  Vowel get vowel => vowels[id]!;
}

/// Splits a word into consonant/vowel units, longest match first.
List<_Unit> _tokenize(String word) {
  final units = <_Unit>[];
  var i = 0;
  while (i < word.length) {
    // Three-letter sequences.
    if (i + 3 <= word.length) {
      final lower3 = word.substring(i, i + 3).toLowerCase();
      if (lower3 == 'chh' ||
          lower3 == 'ksh' ||
          lower3 == 'tth' ||
          lower3 == 'ddh') {
        units.add(_ConsonantUnit(lower3));
        i += 3;
        continue;
      }
    }
    // Two-letter sequences.
    if (i + 2 <= word.length) {
      final two = word.substring(i, i + 2);
      final lower2 = two.toLowerCase();
      // Exact-case aspirated retroflex / palatal: Ch → ഛ, Th → ഥ, Dh → ഢ.
      // Only inside a word — at the start of a word the capital is just
      // sentence case (`Thankal` → താങ്കൾ, `Dharma` → ധർമ്മം).
      if (two == 'Ch' && i != 0) {
        units.add(_ConsonantUnit('chh'));
        i += 2;
        continue;
      }
      if (two == 'Th' && i != 0) {
        units.add(_ConsonantUnit('Th'));
        i += 2;
        continue;
      }
      if (two == 'Dh' && i != 0) {
        units.add(_ConsonantUnit('Dh'));
        i += 2;
        continue;
      }
      // `nj` is the single letter ഞ only at the start of a word
      // (`njan` → ഞാൻ); inside a word it is n + j (`anjali` → അഞ്ജലി).
      if (lower2 == 'nj' && i == 0) {
        units.add(_ConsonantUnit('nj'));
        i += 2;
        continue;
      }
      if (twoLetterConsonants.contains(lower2)) {
        units.add(_ConsonantUnit(lower2));
        i += 2;
        continue;
      }
      if (twoLetterVowels.contains(lower2)) {
        units.add(_VowelUnit(lower2));
        i += 2;
        continue;
      }
    }
    // Single letters.
    final ch = word[i];
    final lower = ch.toLowerCase();
    final isCapital = ch != lower;
    if (vowels.containsKey(lower)) {
      // A capital vowel inside a word is long (`kEralam` → കേരളം);
      // at the start of a word it is the short form, so sentence case
      // keeps working (`Enikku` → എനിക്ക്).
      if (isCapital && i != 0) {
        units.add(_VowelUnit(capitalLongVowel[ch]!));
      } else {
        units.add(_VowelUnit(lower));
      }
      i++;
      continue;
    }
    if (lower == 'c') {
      // `c` before e/i/y sounds like സ (`cinema`), otherwise ക (`calicut`).
      final next = i + 1 < word.length ? word[i + 1].toLowerCase() : '';
      units.add(
        _ConsonantUnit(
          next == 'e' || next == 'i' || next == 'y' ? 's' : 'k',
        ),
      );
      i++;
      continue;
    }
    if (consonants.containsKey(lower)) {
      // A capital consonant inside a word is retroflex where one exists
      // (`kaNda` → കണ്ട); at the start of a word it is the plain form
      // (`Namaskaram` → നമസ്കാരം).
      if (isCapital && i != 0 && capitalRetroflex.containsKey(ch)) {
        units.add(_ConsonantUnit(capitalRetroflex[ch]!));
      } else {
        units.add(_ConsonantUnit(lower));
      }
      i++;
      continue;
    }
    // Anything else inside a word passes through (defensive; words are
    // letter runs, so this is normally unreachable).
    units.add(_PassthroughUnit(ch));
    i++;
  }
  return units;
}

class _PassthroughUnit extends _Unit {
  _PassthroughUnit(this.text);

  final String text;
}

/// Builds Malayalam text from the token list of one word.
String _buildWord(List<_Unit> units) {
  final out = StringBuffer();
  Consonant? pending;
  var pendingGeminate = false;
  var prevWasVowel = false;

  // Last emitted syllable, for the word-final `u` drop and the visarga.
  var lastStart = 0;
  Consonant? lastConsonant;
  String? lastVowelId;
  var lastGeminate = false;
  var lastWasSyllable = false;

  void emitSyllable(Consonant c, String vowelId, bool geminate) {
    lastStart = out.length;
    lastConsonant = c;
    lastVowelId = vowelId;
    lastGeminate = geminate;
    lastWasSyllable = true;
    // The second half of a doubled `t`/`d` is retroflex (ട്ട, ഡ്ഡ),
    // not the plain base (ത, ദ).
    out.write(geminate ? (c.geminateBase ?? c.base) : c.base);
    out.write(vowels[vowelId]!.sign);
  }

  void resolvePending(Consonant next) {
    final p = pending!;
    if (p == next) {
      // Doubled consonant: the first one takes virama
      // (`kka` → ക്ക, `tta` → ട്ട).
      out.write(p.geminatePure ?? p.pure);
      pendingGeminate = true;
    } else if (identical(p, consonants['m'])) {
      // `m` before p/b/r forms a conjunct (അമ്പലം, അമൃതം);
      // before anything else it becomes anusvara (സംഭവം, സംസാരം).
      if (next == consonants['p'] ||
          next == consonants['b'] ||
          next == consonants['r']) {
        out.write('മ്');
      } else {
        out.write('ം');
      }
      pendingGeminate = false;
    } else if (identical(p, consonants['n'])) {
      // `n` takes the shape of the following consonant: ങ് only before
      // `k` (സങ്കടം, തിങ്കൾ); ം before the other velars (മംഗളം, സംഘം);
      // മ് before `p` (അമ്പ്); ഞ്/ണ്/ന് by class otherwise.
      final nextId = _idOf(next);
      if (nextId == 'k') {
        out.write('ങ്');
      } else if (nextId == 'kh' || nextId == 'g' || nextId == 'gh') {
        out.write('ം');
      } else if (nextId == 'p') {
        out.write('മ്');
      } else {
        switch (next.assimilationClass) {
          case AssimilationClass.palatal:
            out.write('ഞ്');
          case AssimilationClass.retroflex:
            out.write('ണ്');
          case AssimilationClass.dental:
            out.write('ന്');
          case AssimilationClass.velar:
            out.write('ങ്');
          case AssimilationClass.labial:
          case AssimilationClass.other:
            out.write(_chilluN);
        }
      }
      pendingGeminate = false;
    } else if (identical(p, consonants['r'])) {
      out.write(_chilluR);
      pendingGeminate = false;
    } else if (identical(p, consonants['l'])) {
      out.write(_chilluL);
      pendingGeminate = false;
    } else if (identical(p, consonants['L'])) {
      out.write(_chilluLL);
      pendingGeminate = false;
    } else if (identical(p, consonants['N'])) {
      out.write(_chilluNN);
      pendingGeminate = false;
    } else {
      out.write(p.pure);
      pendingGeminate = false;
    }
    lastWasSyllable = false;
  }

  for (final unit in units) {
    if (unit is _ConsonantUnit) {
      final c = unit.consonant;
      if (pending != null) {
        resolvePending(c);
      } else {
        pendingGeminate = false;
      }
      pending = c;
      prevWasVowel = false;
    } else if (unit is _VowelUnit) {
      final v = unit.vowel;
      if (pending != null) {
        emitSyllable(pending, unit.id, pendingGeminate);
        pending = null;
        pendingGeminate = false;
      } else if (prevWasVowel && (unit.id == 'i' || unit.id == 'ii')) {
        // `i` after a vowel glides to യ് + vowel (`saai` → സായി);
        // write it as തായ് with an explicit `y` (`taay` → തായ്).
        lastStart = out.length;
        lastConsonant = consonants['y'];
        lastVowelId = unit.id;
        lastGeminate = false;
        lastWasSyllable = true;
        out.write('യ');
        out.write(v.sign);
      } else if (prevWasVowel && (unit.id == 'u' || unit.id == 'uu')) {
        // `u` after a vowel glides to വ് + vowel.
        lastStart = out.length;
        lastConsonant = consonants['v'];
        lastVowelId = unit.id;
        lastGeminate = false;
        lastWasSyllable = true;
        out.write('വ');
        out.write(v.sign);
      } else {
        lastStart = out.length;
        lastConsonant = null;
        lastVowelId = unit.id;
        lastGeminate = false;
        lastWasSyllable = true;
        out.write(v.independent);
      }
      prevWasVowel = true;
    } else if (unit is _PassthroughUnit) {
      if (pending != null) {
        out.write(_wordFinal(pending));
        pending = null;
      }
      lastWasSyllable = false;
      prevWasVowel = false;
      out.write(unit.text);
    }
  }

  if (pending != null) {
    // A word-final `h` immediately after short `a` is the visarga (`ah` → അഃ).
    if (identical(pending, consonants['h']) &&
        lastWasSyllable &&
        lastVowelId == 'a') {
      out.write('ഃ');
    } else if (pendingGeminate) {
      // A doubled consonant at the end of a word keeps its geminate
      // form (`kott` → കൊട്ട്, `kall` → കല്ല്).
      out.write(pending.geminatePure ?? pending.pure);
    } else {
      out.write(_wordFinal(pending));
    }
    return out.toString();
  }

  // Word-final short `u` after a consonant is usually dropped
  // (സംവൃതോകാരം): `enikku` → എനിക്ക്, `enthu` → എന്ത്, `naalu` → നാല്.
  // It is kept after most other consonants: `puku` → പുക, `raju` → രാജു,
  // `vasu` → വസു, `oru` → ഒരു.
  if (lastWasSyllable && lastConsonant != null && lastVowelId == 'u') {
    final c = lastConsonant!;
    final id = _idOf(c);
    if (lastGeminate || uDropConsonants.contains(id)) {
      final text = out.toString();
      out.clear();
      out.write(text.substring(0, lastStart));
      if (lastGeminate) {
        out.write(c.geminatePure ?? c.pure);
      } else if (id == 'k') {
        // A single `k` left bare after the dropped `u`
        // (`puku` → പുക, not പുക്); a doubled `k` keeps its virama
        // (`enikku` → എനിക്ക്).
        out.write(c.base);
      } else {
        out.write(_wordFinal(c));
      }
    }
  }
  return out.toString();
}

/// Word-final form of a consonant: chillu for n/r/l/L/N, anusvara for m,
/// virama for everything else.
String _wordFinal(Consonant c) {
  if (identical(c, consonants['m'])) return 'ം';
  if (identical(c, consonants['n'])) return _chilluN;
  if (identical(c, consonants['r'])) return _chilluR;
  if (identical(c, consonants['l'])) return _chilluL;
  if (identical(c, consonants['L'])) return _chilluLL;
  if (identical(c, consonants['N'])) return _chilluNN;
  return c.pure;
}

String _idOf(Consonant c) {
  for (final entry in consonants.entries) {
    if (identical(entry.value, c)) return entry.key;
  }
  return '';
}
