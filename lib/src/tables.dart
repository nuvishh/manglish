// Tables for the Manglish transliteration scheme.
//
// The scheme is Mozhi-style and deterministic: every input maps to exactly
// one output, so the ambiguous cases are resolved by fixed rules (see the
// README for the full list) plus a small exceptions table for the most
// common words.
//
// Consonant ids are the lowercase roman sequences, plus the capital
// retroflex ids `T`, `Th`, `D`, `Dh`, `N`, `L`, `R`, `S` and the aspirated
// dental `Th` (from `Th`) / `Dh` (from `Dh`).

/// Which class a consonant belongs to, for the `n` assimilation rule
/// (`n` before a velar becomes ങ്, before a palatal ഞ്, …).
enum AssimilationClass { velar, palatal, retroflex, dental, labial, other }

/// A consonant unit.
///
/// [base] is the letter with its inherent `a` (ക), [pure] is the letter
/// with virama (ക്). [geminatePure] is the form of the first consonant of a
/// doubled pair when it differs from [pure] — `t` doubles to ട്ട, not ത്ത,
/// and `d` doubles to ഡ്ഡ, not ദ്ധ. [geminateBase] is the matching base
/// form of the second consonant of the pair (ട, ഡ).
class Consonant {
  const Consonant(
    this.base,
    this.pure, {
    this.geminatePure,
    this.geminateBase,
    this.assimilationClass = AssimilationClass.other,
  });

  final String base;
  final String pure;
  final String? geminatePure;
  final String? geminateBase;
  final AssimilationClass assimilationClass;
}

/// Consonants, keyed by id.
const Map<String, Consonant> consonants = {
  // Velars.
  'k': Consonant('ക', 'ക്', assimilationClass: AssimilationClass.velar),
  'kh': Consonant('ഖ', 'ഖ്', assimilationClass: AssimilationClass.velar),
  'g': Consonant('ഗ', 'ഗ്', assimilationClass: AssimilationClass.velar),
  'gh': Consonant('ഘ', 'ഘ്', assimilationClass: AssimilationClass.velar),
  'q': Consonant('ക', 'ക്', assimilationClass: AssimilationClass.velar),
  // Palatals.
  'ch': Consonant('ച', 'ച്', assimilationClass: AssimilationClass.palatal),
  'chh': Consonant('ഛ', 'ഛ്', assimilationClass: AssimilationClass.palatal),
  'j': Consonant('ജ', 'ജ്', assimilationClass: AssimilationClass.palatal),
  'jh': Consonant('ഝ', 'ഝ്', assimilationClass: AssimilationClass.palatal),
  'nj': Consonant('ഞ', 'ഞ്', assimilationClass: AssimilationClass.palatal),
  'jn': Consonant('ജ്ഞ', 'ജ്ഞ്', assimilationClass: AssimilationClass.palatal),
  // Dentals. `t` and `th` both give ത — in everyday Manglish `th` is
  // almost always ത (athu, ithu, enthu, cheythu); ഥ is written `Th`.
  't': Consonant(
    'ത',
    'ത്',
    geminatePure: 'ട്',
    geminateBase: 'ട',
    assimilationClass: AssimilationClass.dental,
  ),
  'th': Consonant('ത', 'ത്', assimilationClass: AssimilationClass.dental),
  'Th': Consonant('ഥ', 'ഥ്', assimilationClass: AssimilationClass.dental),
  'd': Consonant(
    'ദ',
    'ദ്',
    geminatePure: 'ഡ്',
    geminateBase: 'ഡ',
    assimilationClass: AssimilationClass.dental,
  ),
  'dh': Consonant('ധ', 'ധ്', assimilationClass: AssimilationClass.dental),
  'n': Consonant('ന', 'ന്', assimilationClass: AssimilationClass.dental),
  // Retroflex (written with a capital inside a word: kaNda → കണ്ട).
  'T': Consonant('ട', 'ട്', assimilationClass: AssimilationClass.retroflex),
  'Dh': Consonant('ഢ', 'ഢ്', assimilationClass: AssimilationClass.retroflex),
  'D': Consonant('ഡ', 'ഡ്', assimilationClass: AssimilationClass.retroflex),
  'N': Consonant('ണ', 'ണ്', assimilationClass: AssimilationClass.retroflex),
  // Labials.
  'p': Consonant('പ', 'പ്', assimilationClass: AssimilationClass.labial),
  'ph': Consonant('ഫ', 'ഫ്', assimilationClass: AssimilationClass.labial),
  'b': Consonant('ബ', 'ബ്', assimilationClass: AssimilationClass.labial),
  'bh': Consonant('ഭ', 'ഭ്', assimilationClass: AssimilationClass.labial),
  'm': Consonant('മ', 'മ്', assimilationClass: AssimilationClass.labial),
  // Others.
  'y': Consonant('യ', 'യ്'),
  'r': Consonant('ര', 'ര്'),
  'R': Consonant('റ', 'റ്'),
  'l': Consonant('ല', 'ല്'),
  'L': Consonant('ള', 'ള്'),
  'v': Consonant('വ', 'വ്'),
  'w': Consonant('വ', 'വ്'),
  'sh': Consonant('ശ', 'ശ്'),
  'S': Consonant('ശ', 'ശ്'),
  's': Consonant('സ', 'സ്'),
  'zh': Consonant('ഴ', 'ഴ്'),
  'z': Consonant('ഴ', 'ഴ്'),
  'h': Consonant('ഹ', 'ഹ്'),
  'f': Consonant('ഫ', 'ഫ്'),
  'x': Consonant('ക്സ', 'ക്സ്'),
  'ksh': Consonant('ക്ഷ', 'ക്ഷ്'),
  'tth': Consonant(
    'ത്ത',
    'ത്ത്',
    assimilationClass: AssimilationClass.dental,
  ),
  'ddh': Consonant(
    'ദ്ധ',
    'ദ്ധ്',
    assimilationClass: AssimilationClass.dental,
  ),
};

/// A vowel unit: [independent] is the standalone letter (അ),
/// [sign] is the vowel sign used after a consonant (ാ, or empty for `a`,
/// whose sign is the inherent vowel).
class Vowel {
  const Vowel(this.independent, this.sign);

  final String independent;
  final String sign;
}

/// Vowels, keyed by id. `E` is the long `e` (ഏ) — written as a capital `E`
/// inside a word (`kEralam` → കേരളം).
const Map<String, Vowel> vowels = {
  'a': Vowel('അ', ''),
  'aa': Vowel('ആ', 'ാ'),
  'i': Vowel('ഇ', 'ി'),
  'ii': Vowel('ഈ', 'ീ'),
  'u': Vowel('ഉ', 'ു'),
  'uu': Vowel('ഊ', 'ൂ'),
  'e': Vowel('എ', 'െ'),
  'ee': Vowel('ഈ', 'ീ'),
  'E': Vowel('ഏ', 'േ'),
  'o': Vowel('ഒ', 'ൊ'),
  'oo': Vowel('ഓ', 'ോ'),
  'ai': Vowel('ഐ', 'ൈ'),
  'au': Vowel('ഔ', 'ൗ'),
};

/// Two-letter consonant sequences (matched case-insensitively).
const Set<String> twoLetterConsonants = {
  'kh',
  'gh',
  'ch',
  'jh',
  'th',
  'dh',
  'ph',
  'bh',
  'sh',
  'zh',
  'jn',
};

/// Two-letter vowel sequences (matched case-insensitively).
const Set<String> twoLetterVowels = {'aa', 'ii', 'uu', 'ee', 'oo', 'ai', 'au'};

/// Single capital letters inside a word map to these retroflex consonants.
/// A capital at the start of a word is read as its lowercase form instead,
/// so sentence case keeps working (`Namaskaram` → നമസ്കാരം).
const Map<String, String> capitalRetroflex = {
  'T': 'T',
  'D': 'D',
  'N': 'N',
  'L': 'L',
  'R': 'R',
  'S': 'S',
  'Z': 'zh',
};

/// A single capital vowel inside a word is the long form of that vowel.
const Map<String, String> capitalLongVowel = {
  'A': 'aa',
  'E': 'E',
  'I': 'ii',
  'O': 'oo',
  'U': 'uu',
};

/// Word-final short `u` after a consonant is dropped (സംവൃതോകാരം) when the
/// consonant is doubled (`enikku` → എനിക്ക്, `innu` → ഇന്ന്) or when it is
/// one of these ids (`enthu` → എന്ത്, `athu` → അത്, `naalu` → നാല്).
/// After any other consonant it is kept (`puku` → പുക, `raju` → രാജു,
/// `vasu` → വസു, `oru` → ഒരു, `guru` → ഗുരു, `manu` → മനു).
const Set<String> uDropConsonants = {
  'th',
  'Th',
  'k',
  'l',
  'L',
  'N',
  'x',
  'ksh',
  'jn',
  'tth',
  'ddh',
};

/// Malayalam digits 0-9, used when [malayalamDigits] is on.
const Map<String, String> malayalamDigitChars = {
  '0': '൦',
  '1': '൧',
  '2': '൨',
  '3': '൩',
  '4': '൪',
  '5': '൫',
  '6': '൬',
  '7': '൭',
  '8': '൮',
  '9': '൯',
};

/// Common words where the plain rules would give the wrong (or uncommon)
/// spelling. Looked up on the lowercased word before the rules run.
///
/// These are the genuinely ambiguous cases — `e` can be എ or ഏ, `n`
/// before `d` can be ന് or ണ്, `tt` can be ട്ട or ത്ത — so the most
/// frequent words are pinned here. Everything else follows the rules.
const Map<String, String> exceptions = {
  'innu': 'ഇന്ന്',
  'onnu': 'ഒന്ന്',
  'kannu': 'കണ്ണ്',
  'vannu': 'വന്നു',
  'ninnu': 'നിന്നു',
  'thannu': 'തന്നു',
  'vishannu': 'വിശന്നു',
  'keralam': 'കേരളം',
  'malayalam': 'മലയാളം',
  'chechi': 'ചേച്ചി',
  'chetta': 'ചേട്ടാ',
  'chettan': 'ചേട്ടൻ',
  'sneham': 'സ്നേഹം',
  'kanda': 'കണ്ട',
  'ketta': 'കെട്ട',
  'katha': 'കഥ',
  'artham': 'അർഥം',
  'sheri': 'ശരി',
  'vere': 'വേറെ',
  'peru': 'പേര്',
  'aano': 'ആണോ',
  'aanu': 'ആണ്',
  'aane': 'ആണ്',
  'undo': 'ഉണ്ടോ',
  'undu': 'ഉണ്ട്',
  'und': 'ഉണ്ട്',
  'venam': 'വേണം',
  'venda': 'വേണ്ട',
  'veedu': 'വീട്',
  'paadu': 'പാടു',
  'kodu': 'കൊടു',
  'naadu': 'നാടു',
  'kaadu': 'കാട്',
  'randu': 'രണ്ട്',
  'mundu': 'മുണ്ട്',
  'kundu': 'കുണ്ട്',
  'thundu': 'തുണ്ട്',
  'kambu': 'കമ്പ്',
  'thambu': 'തമ്പ്',
  'cheythu': 'ചെയ്തു',
  'hethu': 'ഹേതു',
  'sethu': 'സേതു',
  'kethu': 'കേതു',
  'sughamano': 'സുഖമാണോ',
  'sughamaano': 'സുഖമാണോ',
  'sugham': 'സുഖം',
  'naale': 'നാളെ',
  'thingal': 'തിങ്കൾ',
  'ippo': 'ഇപ്പോ',
  'njangal': 'ഞങ്ങൾ',
  'manglish': 'മംഗ്ലിഷ്',
  'english': 'ഇംഗ്ലീഷ്',
  'nokku': 'നോക്ക്',
  'pokku': 'പോക്ക്',
  'nokkan': 'നോക്കാൻ',
  'pokkan': 'പോക്കാൻ',
  'raju': 'രാജു',
  'saju': 'സാജു',
  'varsham': 'വർഷം',
  'harsham': 'ഹർഷം',
  'thankal': 'താങ്കൾ',
  'thankalude': 'താങ്കളുടെ',
  'thankalkku': 'താങ്കൾക്ക്',
  'ketu': 'കേതു',
  'krishna': 'കൃഷ്ണ',
  'krishnan': 'കൃഷ്ണൻ',
  'amrutham': 'അമൃതം',
  'hrudayam': 'ഹൃദയം',
  'srishti': 'സൃഷ്ടി',
  'mrugam': 'മൃഗം',
  'thripthi': 'തൃപ്തി',
  'namaskaram': 'നമസ്കാരം',
  'malayaalam': 'മലയാളം',
  'njan': 'ഞാൻ',
  'aval': 'അവൾ',
  'avalkku': 'അവൾക്ക്',
  'ningal': 'നിങ്ങൾ',
  'ningalkku': 'നിങ്ങൾക്ക്',
  'ningalude': 'നിങ്ങളുടെ',
  'mangalam': 'മംഗളം',
  'karthika': 'കാർത്തിക',
  'ente': 'എന്റെ',
  'ende': 'എന്റെ',
  'jnanam': 'ജ്ഞാനം',
  'paadam': 'പാടം',
  'hello': 'ഹെല്ലോ',
  'parayu': 'പറയു',
  'parayoo': 'പറയൂ',
  'parayan': 'പറയൻ',
  'parayuka': 'പറയുക',
};
