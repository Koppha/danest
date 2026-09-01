/** Uppercase, strip spaces/punctuation — used for reg-number uniqueness/search. */
export function normalizeRegNumber(raw: string): string {
  return raw.toUpperCase().replace(/[^A-Z0-9]/g, '');
}

/**
 * Normalizes a phone number to a consistent storable form. Defaults to the
 * Lesotho country code (+266) when no country code is present, matching the
 * primary market this deployment serves; a leading '+' or '00' is preserved
 * as an explicit international number.
 */
export function normalizePhone(raw: string, defaultCountryCode = '266'): string {
  let digits = raw.trim().replace(/[^\d+]/g, '');
  if (digits.startsWith('00')) digits = `+${digits.slice(2)}`;
  if (!digits.startsWith('+')) {
    digits = digits.replace(/^0+/, '');
    digits = `+${defaultCountryCode}${digits}`;
  }
  return digits;
}
