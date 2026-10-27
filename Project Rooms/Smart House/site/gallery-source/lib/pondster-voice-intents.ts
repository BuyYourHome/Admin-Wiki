/** Explicit complete farewells only; quoted, negated and longer requests stay active. */
export const PONDSTER_FAREWELL_ACK = 'Goodbye for now. My microphone and voice are off.';

export function isPondsterFarewell(input: string): boolean {
  const words = input.toLowerCase().trim()
    .replace(/\bwe['’]re\b/g, 'we are')
    .replace(/\bthat['’]s\b/g, 'that is')
    .replace(/[.,!;:—–-]+/g, ' ')
    .replace(/\s+/g, ' ').trim()
    .replace(/^(?:(?:hey|okay|ok) )?(?:pondster|pond star|pond stir)(?: |$)/, '')
    .replace(/ (?:pondster|pond star|pond stir)$/, '')
    .replace(/^(?:okay|ok|thanks|thank ?you)(?: and)? /, '')
    .replace(/ (?:and )?(?:okay|ok|thanks|thank ?you)$/, '')
    .replace(/^(?:pondster|pond star|pond stir)(?: |$)/, '')
    .replace(/ (?:pondster|pond star|pond stir)$/, '')
    .replace(/^please /, '').replace(/ please$/, '').trim();
  // Quotes and question marks are deliberately not removed by normalization.
  return /^(?:good ?bye(?: for now)?|bye(?: bye| for now)?|see you (?:later|soon)|we are done(?: for now)?|that is all(?: for now)?|end (?:the |our |this )?conversation|stop listening|stop (?:the |your )?voice|turn off (?:the |your )?voice|turn (?:the |your )?voice off)$/.test(words);
}
