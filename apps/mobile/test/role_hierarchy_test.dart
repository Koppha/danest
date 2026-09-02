import 'package:flutter_test/flutter_test.dart';
import 'package:de_nest/core/role_hierarchy.dart';

void main() {
  test('a role satisfies a requirement at or below its own rank', () {
    expect(roleAtLeast('OWNER', 'SUPERVISOR'), isTrue);
    expect(roleAtLeast('SUPERVISOR', 'SUPERVISOR'), isTrue);
    expect(roleAtLeast('ADMINISTRATOR', 'ATTENDANT'), isTrue);
  });

  test('a role does not satisfy a requirement above its own rank', () {
    expect(roleAtLeast('ATTENDANT', 'SUPERVISOR'), isFalse);
    expect(roleAtLeast('SUPERVISOR', 'OWNER'), isFalse);
  });

  test('an unrecognized role never satisfies any requirement', () {
    expect(roleAtLeast('NOT_A_ROLE', 'ATTENDANT'), isFalse);
  });
}
