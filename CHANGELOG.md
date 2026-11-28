## 0.1.1

- Shortened the package description to meet pub.dev's 60–180 character guideline (fixes the 10-point "Follow Dart file conventions" deduction; 150/160 → 160/160).

## 0.1.0

- Initial release.
- Manglish (Latin script) to Malayalam script transliteration, pure Dart, zero dependencies.
- Mozhi-style scheme: vowel signs vs independent vowels, chillu letters (ൻ ർ ൽ ൾ ണ്), anusvara (ം), n-assimilation (ങ്ക ഞ്ച ണ്ട), geminates (ട്ട for `tt`, ത്ത via `tth`), word-final `u` handling (എനിക്ക്, എന്ത്, ഒരു).
- Sentence-case friendly: a capital at the start of a word is read as the short form (`Namaskaram` → നമസ്കാരം); capitals inside a word are long/retroflex (`kEralam` → കേരളം, `kaNda` → കണ്ട).
- Small built-in exceptions table for the most common ambiguous words (`keralam`, `malayalam`, `chechi`, `sneham`, `kanda`, `venam`, `venda`, `aano`, `aanu`, `innu`, `onnu`, `vannu` …).
- Optional Malayalam digits (`malayalamDigits: true`).
- `ManglishTransliterator`, `transliterateManglish()` and the `toMalayalam()` String extension.
