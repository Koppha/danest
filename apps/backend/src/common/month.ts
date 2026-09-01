/** Normalizes to the first day of the UTC month (loyalty period key). */
export function monthStart(date: Date): Date {
  return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), 1));
}

export function addMonths(date: Date, n: number): Date {
  return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth() + n, 1));
}

export function sameMonth(a: Date, b: Date): boolean {
  return monthStart(a).getTime() === monthStart(b).getTime();
}
