# TODO — manglish

## Deferred (user's call, 2026-11-26)

- [ ] Number-to-words: `numberToMalayalamWords(2500)` → "രണ്ടായിരത്തി അഞ്ഞൂറ്".
  Declined for now ("Venda, ippo venda", 2026-11-26). Digits only become
  ൨൫൦൦ today with `malayalamDigits: true`; words need a new feature.

## Before first publish

- [ ] Create github.com/nuvishh/manglish (public) — user creates it;
      the GitHub App cannot create repos.
- [ ] `git init`, commit, push to that repo.
- [ ] `dart pub publish --dry-run` — 0 warnings on 2026-11-25; re-check
      before publishing.
- [ ] `dart pub publish` with his Google account (browser sign-in).

## Ideas (not decided)

- [ ] Reverse transliteration: Malayalam → Manglish. Forward-only today;
      Malayalam input passes through unchanged.
