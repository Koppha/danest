const _roleRank = {
  'ATTENDANT': 0,
  'SUPERVISOR': 1,
  'ADMINISTRATOR': 2,
  'OWNER': 3,
};

/// True if [actual]'s role outranks or matches [required] in the
/// ATTENDANT < SUPERVISOR < ADMINISTRATOR < OWNER hierarchy — e.g.
/// `roleAtLeast('OWNER', 'SUPERVISOR')` is true.
bool roleAtLeast(String actual, String required) => (_roleRank[actual] ?? -1) >= (_roleRank[required] ?? 999);
