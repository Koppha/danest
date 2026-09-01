import 'package:flutter_test/flutter_test.dart';
import 'package:de_nest/data/models/models.dart';

void main() {
  test('a Customer created without an explicit vehicles list can still have vehicles added to it', () {
    // Regression test: the constructor used to default `vehicles` to a
    // `const []`, which is immutable — mutating it (as the New Wash screen
    // does right after creating a vehicle inline) threw
    // "Unsupported operation: Cannot add to an unmodifiable list".
    final customer = Customer(id: 'c1', fullName: 'Test', phone: '+26658000000');
    final vehicle = Vehicle(id: 'v1', customerId: 'c1', regNumberDisplay: 'ABC 123');

    expect(() => customer.vehicles.add(vehicle), returnsNormally);
    expect(customer.vehicles, [vehicle]);
  });
}
