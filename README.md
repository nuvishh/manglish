# manglish

A small, focused, zero-dependency Dart package that transliterates **Manglish** — Malayalam written in Latin letters — into Malayalam script.

```dart
import 'package:manglish/manglish.dart';

void main() {
  print(transliterateManglish('namaskaram')); // നമസ്കാരം
  print(transliterateManglish('enikku oru chaaya venam')); // എനിക്ക് ഒരു ചായ വേണം
  print('njan keralathil aanu'.toMalayalam()); // ഞാൻ കേരളത്തിൽ ആണ്
}
```

## Why manglish?

Manglish is how millions of Malayalis type Malayalam every day — in chats, comments and search boxes. Existing transliteration packages cover dozens of languages and ship large tables; `manglish` does one thing, does it well, and adds nothing to your dependency tree.

## Usage

### The transliterator

```dart
const t = ManglishTransliterator();
t.transliterate('njan vishnu aanu'); // ഞാൻ വിഷ്ണു ആണ്
```

### Top-level function and extension

```dart
transliterateManglish('sneham'); // സ്നേഹം
'sneham'.toMalayalam();          // സ്നേഹം
```

### Malayalam digits

By default the digits `0-9` pass through unchanged. Pass `malayalamDigits: true` to convert them to ൦–൯:

```dart
const t = ManglishTransliterator(malayalamDigits: true);
t.transliterate('2026'); // ൨൦൨൬
```

### What passes through

Spaces, punctuation, digits (unless `malayalamDigits` is set) and text that is already in Malayalam script are left untouched, so you can transliterate whole sentences safely:

```dart
transliterateManglish('Hello, njan vishnu aanu!'); // Hello, ഞാൻ വിഷ്ണു ആണ്!
```

## The scheme

The transliterator follows a Mozhi-style scheme — the spelling most Malayalis already use — with longest-match tokenisation:

| Manglish | Malayalam | Notes |
| --- | --- | --- |
| `aa`, `ii`, `uu`, `ee`, `oo` | ആ, ഈ, ഊ, ഈ, ഓ | doubled vowels are one long vowel (`ee` is ഈ; use capital `E` inside a word for ഏ) |
| `kh`, `gh`, `ch`, `jh`, `th`, `dh`, `ph`, `bh`, `sh`, `zh` | ഖ, ഘ, ച, ഝ, ത, ധ, ഫ, ഭ, ശ, ഴ | aspirated consonants |
| `chh`, `ksh`, `tth`, `ddh` | ഛ, ക്ഷ, ത്ത, ദ്ധ | three-letter sequences |
| `ng` | ങ്ങ് / ം | `n` + `g` assimilate; see below |
| `nj` | ഞ | only at the start of a word (`njan` → ഞാൻ); inside a word it is ന് + ജ (`anjali` → അഞ്ജലി) |
| `t` and `th` | ത | everyday Manglish uses `th` for ത (`enthu` → എന്ത്); ഥ is written `Th` |
| `c` | ക / സ | സ before `e`, `i`, `y` (`cinema`); ക otherwise (`calicut`) |

### Capitals

Capitals are meaningful inside a word, so sentence case still works:

- A capital at the **start** of a word is just sentence case: `Namaskaram` → നമസ്കാരം, `Thankal` → താങ്കൾ.
- A capital **vowel** inside a word is long: `kEralam` → കേരളം, `chEchi` → ചേച്ചി.
- A capital **consonant** inside a word is retroflex: `kaNda` → കണ്ട, `kaNNan` → കണ്ണൻ.
- Exact-case `Ch`, `Th`, `Dh` inside a word give the aspirated retroflex/palatal: ഛ, ഥ, ഢ.

### Doubled consonants

A doubled consonant is a geminate — the first half takes a virama: `enikku` → എനിക്ക്, `kotta` → കൊട്ട. Doubled `t`/`d` default to the retroflex geminate: `tt` → ട്ട, `dd` → ഡ്ഡ. Use `tth`/`ddh` for the dental geminate: `tth` → ത്ത, `ddh` → ദ്ധ.

### Chillu and anusvara

Word-final and pre-consonantal `n`, `r`, `l`, `L`, `N` become chillu letters (ൻ, ർ, ൽ, ൾ, ണ്): `naalu` → നാല്, `kaarthika` → കാർത്തിക. `m` before a consonant becomes anusvara (ം) except before `p`/`b`/`r`, where it forms a conjunct: `sambhavam` → സംഭവം, `ambalam` → അമ്പലം. `n` assimilates to the following consonant: `sankadam` → സങ്കടം, `anjali` → അഞ്ജലി, `sundari` → സുന്ദരി.

### Word-final `u`

Malayalam drops the final `u` (സംവൃതോകാരം) after certain consonants: `enthu` → എന്ത്, `athu` → അത്, `enikku` → എനിക്ക്, `naalu` → നാല്. It is kept after others: `oru` → ഒരു, `guru` → ഗുരു, `raju` → രാജു.

### Exceptions

About sixty genuinely ambiguous everyday words are pinned in a small exceptions table (`lib/src/tables.dart`) so they always come out right — `keralam` → കേരളം, `chechi` → ചേച്ചി, `innu` → ഇന്ന്, `malayalam` → മലയാളം, `namaskaram` → നമസ്കാരം. If a word you care about comes out wrong, that table is the first place to look.

## Limitations

- This is a **rule-based** transliterator, not a dictionary — it spells words the way they sound. Unusual or English words transliterate phonetically (`english` → ഇംഗ്ലീഷ് works because it is a pinned exception; other English words will be sounded out in Malayalam).
- A few spellings are genuinely ambiguous in Manglish itself (is `kala` കല or കാല?). The exceptions table covers the common ones; for the rest, use the capital or doubled-letter conventions above (`kaala` → കാല).
- **Manglish → Malayalam only.** The reverse direction (Malayalam → Manglish) is not included in this version.

## Contributing

Found a word that transliterates wrong? Open an issue with the Manglish input and the Malayalam you expected — most fixes are one line in the exceptions table or one rule tweak, and they come with a test.
