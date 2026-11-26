/// Manglish (Malayalam in Latin script) to Malayalam script transliteration.
///
/// ```dart
/// import 'package:manglish/manglish.dart';
///
/// void main() {
///   final t = ManglishTransliterator();
///   print(t.transliterate('namaskaram')); // നമസ്കാരം
///   print('kEralam'.toMalayalam()); // കേരളം
/// }
/// ```
library;

export 'src/transliterator.dart';
