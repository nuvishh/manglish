import 'package:manglish/manglish.dart';
import 'package:test/test.dart';

void main() {
  const t = ManglishTransliterator();

  String tr(String input) => t.transliterate(input);

  group('everyday words', () {
    test('greetings and common words', () {
      expect(tr('namaskaram'), 'നമസ്കാരം');
      expect(tr('sugham'), 'സുഖം');
      expect(tr('sheri'), 'ശരി');
      expect(tr('shari'), 'ശരി');
      expect(tr('pinne'), 'പിന്നെ');
      expect(tr('ippo'), 'ഇപ്പോ');
      expect(tr('alla'), 'അല്ല');
      expect(tr('illa'), 'ഇല്ല');
      expect(tr('ini'), 'ഇനി');
      expect(tr('naale'), 'നാളെ');
      expect(tr('innale'), 'ഇന്നലെ');
    });

    test('Kerala and Malayalam', () {
      expect(tr('keralam'), 'കേരളം');
      expect(tr('malayalam'), 'മലയാളം');
      expect(tr('malayaalam'), 'മലയാളം');
      expect(tr('kEralam'), 'കേരളം');
      expect(tr('keralam'), 'കേരളം');
    });

    test('pronouns and people', () {
      expect(tr('njan'), 'ഞാൻ');
      expect(tr('ningal'), 'നിങ്ങൾ');
      expect(tr('njangal'), 'ഞങ്ങൾ');
      expect(tr('avan'), 'അവൻ');
      expect(tr('aval'), 'അവൾ');
      expect(tr('oru'), 'ഒരു');
      expect(tr('guru'), 'ഗുരു');
      expect(tr('manu'), 'മനു');
      expect(tr('chechi'), 'ചേച്ചി');
      expect(tr('chetta'), 'ചേട്ടാ');
      expect(tr('chettan'), 'ചേട്ടൻ');
    });
  });

  group('samvruthokaram — word-final u', () {
    test('dropped after a consonant', () {
      expect(tr('enikku'), 'എനിക്ക്');
      expect(tr('ninakku'), 'നിനക്ക്');
      expect(tr('enthu'), 'എന്ത്');
      expect(tr('athu'), 'അത്');
      expect(tr('ithu'), 'ഇത്');
      expect(tr('naalu'), 'നാ\u0D7D');
      expect(tr('randu'), 'രണ്ട്');
      expect(tr('kallu'), 'കല്ല്');
      expect(tr('cheyyu'), 'ചെയ്യ്');
      expect(tr('nokku'), 'നോക്ക്');
    });

    test('kept after most consonants', () {
      expect(tr('oru'), 'ഒരു');
      expect(tr('guru'), 'ഗുരു');
      expect(tr('parayu'), 'പറയു');
      expect(tr('manu'), 'മനു');
      expect(tr('puku'), 'പുക');
      expect(tr('pooku'), 'പോക');
      expect(tr('raju'), 'രാജു');
      expect(tr('vasu'), 'വസു');
      expect(tr('ketu'), 'കേതു');
      expect(tr('parayoo'), 'പറയൂ');
      expect(tr('aaLu'), 'ആ\u0D7E');
    });

    test('the nnu words are pinned by the exceptions table', () {
      expect(tr('innu'), 'ഇന്ന്');
      expect(tr('onnu'), 'ഒന്ന്');
      expect(tr('kannu'), 'കണ്ണ്');
      expect(tr('vannu'), 'വന്നു');
      expect(tr('ninnu'), 'നിന്നു');
      expect(tr('thannu'), 'തന്നു');
      expect(tr('vishannu'), 'വിശന്നു');
    });
  });

  group('chillu and anusvara', () {
    test('word-final chillu', () {
      expect(tr('avan'), 'അവൻ');
      expect(tr('aval'), 'അവൾ');
      expect(tr('maram'), 'മരം');
      expect(tr('kaalam'), 'കാലം');
      expect(tr('pal'), 'പൽ');
      expect(tr('paal'), 'പാൽ');
      expect(tr('mar'), 'മർ');
      expect(tr('maar'), 'മാർ');
    });

    test('m before a consonant', () {
      expect(tr('ambalam'), 'അമ്\u0D2Cലം');
      expect(tr('amrutham'), 'അമൃതം');
      expect(tr('sambhavam'), 'സംഭവം');
      expect(tr('samsaaram'), 'സംസാരം');
      expect(tr('amma'), 'അമ്മ');
      expect(tr('kamalam'), 'കമലം');
    });

    test('n assimilation', () {
      expect(tr('mangalam'), 'മംഗളം');
      expect(tr('thingal'), 'തിങ്കൾ');
      expect(tr('anjali'), 'അഞ്ജലി');
      expect(tr('sundari'), 'സുന്ദരി');
      expect(tr('anbu'), 'അൻബു');
      expect(tr('pancha'), 'പഞ്ച');
    });

    test('r and l before a consonant', () {
      expect(tr('karthika'), 'കാർത്തിക');
      expect(tr('kalpana'), 'ക\u0D7Dപന');
      expect(tr('varsham'), 'വർഷം');
    });
  });

  group('capitals', () {
    test('sentence case at the start of a word', () {
      expect(tr('Namaskaram'), 'നമസ്കാരം');
      expect(tr('Enikku'), 'എനിക്ക്');
      expect(tr('Avan'), 'അവൻ');
      expect(tr('Njan'), 'ഞാൻ');
      expect(tr('Thankal'), 'താങ്കൾ');
    });

    test('capitals inside a word are long or retroflex', () {
      expect(tr('kEralam'), 'കേരളം');
      expect(tr('chEchi'), 'ചേച്ചി');
      expect(tr('snEham'), 'സ്നേഹം');
      expect(tr('kaNda'), 'കണ്ട');
      expect(tr('kaNNan'), 'കണ്ണൻ');
      expect(tr('kannan'), 'കന്നൻ');
    });

    test('e is short by default (Mozhi rule)', () {
      // Plain `e` is എ; write a capital E inside the word for ഏ.
      expect(tr('keralam'), 'കേരളം');
      expect(tr('sneham'), 'സ്നേഹം');
      expect(tr('chechi'), 'ചേച്ചി');
      expect(tr('ente'), 'എന്റെ');
    });

    test('dental vs retroflex geminates', () {
      expect(tr('kotta'), 'കൊട്ട');
      expect(tr('ketta'), 'കെട്ട');
      expect(tr('pattu'), 'പട്ട്');
      expect(tr('paattu'), 'പാട്ട്');
      expect(tr('kott'), 'കൊട്ട്');
      expect(tr('kall'), 'കല്ല്');
      expect(tr('kann'), 'കന്ന്');
      expect(tr('kamm'), 'കമ്മ്');
    });
  });

  group('conjuncts and special sequences', () {
    test('clusters', () {
      expect(tr('sneham'), 'സ്നേഹം');
      expect(tr('mitram'), 'മിത്രം');
      expect(tr('kshama'), 'ക്ഷമ');
      expect(tr('pakshi'), 'പക്ഷി');
      expect(tr('jnanam'), 'ജ്ഞാനം');
    });

    test('vowel glides', () {
      expect(tr('saai'), 'സായി');
      expect(tr('taay'), 'തായ്');
    });

    test('visarga', () {
      expect(tr('ah'), 'അഃ');
      expect(tr('namah'), 'നമഃ');
      expect(tr('narh'), 'നർഹ്');
    });

    test('long vowels and diphthongs', () {
      expect(tr('aadi'), 'ആദി');
      expect(tr('thee'), 'തീ');
      expect(tr('nee'), 'നീ');
      expect(tr('puku'), 'പുക');
      expect(tr('kainikku'), 'കൈനിക്ക്');
    });
  });

  group('common ambiguous words (exceptions table)', () {
    test('is / want / no', () {
      expect(tr('aano'), 'ആണോ');
      expect(tr('aanu'), 'ആണ്');
      expect(tr('aane'), 'ആണ്');
      expect(tr('undo'), 'ഉണ്ടോ');
      expect(tr('undu'), 'ഉണ്ട്');
      expect(tr('und'), 'ഉണ്ട്');
      expect(tr('venam'), 'വേണം');
      expect(tr('venda'), 'വേണ്ട');
      expect(tr('vere'), 'വേറെ');
      expect(tr('peru'), 'പേര്');
      expect(tr('kanda'), 'കണ്ട');
      expect(tr('katha'), 'കഥ');
      expect(tr('artham'), 'അർഥം');
      expect(tr('cheythu'), 'ചെയ്തു');
      expect(tr('hethu'), 'ഹേതു');
      expect(tr('randu'), 'രണ്ട്');
      expect(tr('mundu'), 'മുണ്ട്');
      expect(tr('veedu'), 'വീട്');
      expect(tr('paadu'), 'പാടു');
      expect(tr('kodu'), 'കൊടു');
      expect(tr('naadu'), 'നാടു');
      expect(tr('kaadu'), 'കാട്');
    });
  });

  group('sentences and passthrough', () {
    test('full sentences', () {
      expect(
        tr('Enikku vishannu'),
        'എനിക്ക് വിശന്നു',
      );
      expect(
        tr('Namaskaram, ningalkku sughamano?'),
        'നമസ്കാരം, നിങ്ങൾക്ക് സുഖമാണോ?',
      );
      expect(
        tr('Njan naale varum.'),
        'ഞാൻ നാളെ വരും.',
      );
    });

    test('punctuation, digits and Malayalam pass through', () {
      expect(tr('hello, 2026!'), 'ഹെല്ലോ, 2026!');
      expect(tr('12/11/2026'), '12/11/2026');
      expect(tr('മലയാളം + manglish'), 'മലയാളം + മംഗ്ലിഷ്');
      expect(tr(''), '');
    });

    test('Malayalam digits option', () {
      const digits = ManglishTransliterator(malayalamDigits: true);
      expect(digits.transliterate('2026'), '൨൦൨൬');
      expect(digits.transliterate('2 per'), '൨ പെ\u0D7C');
      expect(tr('2026'), '2026');
    });
  });

  group('API', () {
    test('top-level function and extension', () {
      expect(transliterateManglish('namaskaram'), 'നമസ്കാരം');
      expect('namaskaram'.toMalayalam(), 'നമസ്കാരം');
      expect(
        'kEralam'.toMalayalam(),
        'കേരളം',
      );
    });
  });
}
