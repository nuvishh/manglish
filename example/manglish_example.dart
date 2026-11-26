import 'package:manglish/manglish.dart';

void main() {
  final transliterator = ManglishTransliterator();

  print(transliterator.transliterate('namaskaram'));
  // നമസ്കാരം

  print(transliterator.transliterate('Enikku vishannu, ningalkku sughamano?'));
  // എനിക്ക് വിശന്നു, നിങ്ങൾക്ക് സുഖമാണോ?

  print('kEralam'.toMalayalam());
  // കേരളം

  print(transliterateManglish('malayalam'));
  // മലയാളം

  // Malayalam digits.
  const digits = ManglishTransliterator(malayalamDigits: true);
  print(digits.transliterate('2026'));
  // ൨൦൨൬
}
