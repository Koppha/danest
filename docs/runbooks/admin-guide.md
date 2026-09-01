# De Nest — Administrator Guide

## Roles

| Role | Can do |
|---|---|
| Attendant | Search/register customers & vehicles, run the wash queue, take payment, view loyalty/prepaid balances |
| Supervisor | Everything above + approve voids/discounts via PIN, close shifts |
| Administrator | Everything above + configure services/prices, manage users, prepaid packages, collections, expenses, reports, audit log, SMS log |
| Owner | Everything above + system settings, backup restore, manage administrators |

The seed script creates one **Owner** account (`SEED_ADMIN_USERNAME` /
`SEED_ADMIN_PASSWORD` in `.env`, default `admin` / whatever you set) — sign
in with that first and create real staff accounts from **Settings → Users**
(via the API for now; see `POST /api/v1/users`).

## Daily flow

1. **New Wash** — search the customer by phone, name, or plate; add a
   vehicle if it's their first visit; pick a service + extras; the loyalty
   meter shows their progress this month; **Start Wash** puts it in the
   queue as `WAITING`.
2. **Wash Queue** — move a car `WAITING → WASHING → READY` as it
   progresses. When it's `READY`, **Finish & Send SMS** takes payment and
   texts the customer.
3. Loyalty, prepaid deductions, and the completion SMS all happen
   automatically as part of finishing the wash — nothing extra to do.

## End of shift: Cash Collection (Administrator+)

Go to **Collections**. The screen shows cash sales, cash prepaid deposits,
cash refunds, and cash expenses since the last confirmed collection, netted
into an **expected cash** figure. Count the till, enter the actual amount:

- Matches exactly → confirms as `MATCHED`.
- Doesn't match → you must give a reason; it records as `SHORT` or `OVER`.

Once confirmed, that becomes the cut-off point for the next collection —
confirmed collections can't be edited, only corrected via a new entry.

## Expenses (Administrator+)

**Expenses → Record expense.** Only expenses paid from the till (`CASH`)
reduce expected cash in Collections — card/bank/mobile-money expenses show
in reports but don't touch the physical cash figure. Mistakes are corrected
via **reverse**, which creates an offsetting entry rather than editing the
original.

## Loyalty rules (for reference)

- Tracked **per vehicle**, not per customer — two cars on one account never
  share progress.
- 5 qualifying paid washes in a calendar month → 1 free wash, usable the
  *following* month, expiring at the end of that month if unused.
- Loyalty-paid washes, cancelled/refunded washes, and M0 washes don't
  count toward the 5.
- A refund on a wash that contributed to an earned reward will
  automatically revoke that reward if it hasn't been redeemed yet, or flag
  it in the audit log for manual review if it has already been used.

## If something looks wrong

Check **Audit & SMS** (Administrator+) — every price change, void,
collection, expense, and loyalty adjustment is logged there with who did
it and when.
