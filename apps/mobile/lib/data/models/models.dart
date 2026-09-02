import '../../core/money.dart';

class Customer {
  final String id;
  final String fullName;
  final String phone;
  final List<Vehicle> vehicles;

  Customer({required this.id, required this.fullName, required this.phone, List<Vehicle>? vehicles})
      // Always a fresh growable list — screens mutate `.vehicles` directly
      // (e.g. after adding a vehicle inline), which throws on a `const []`.
      : vehicles = vehicles ?? [];

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        phone: json['phone'] as String,
        vehicles: (json['vehicles'] as List<dynamic>? ?? []).map((v) => Vehicle.fromJson(v as Map<String, dynamic>)).toList(),
      );
}

class Vehicle {
  final String id;
  final String customerId;
  final String regNumberDisplay;
  final String? make;
  final String? model;
  final String? colour;

  Vehicle({required this.id, required this.customerId, required this.regNumberDisplay, this.make, this.model, this.colour});

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id'] as String,
        customerId: json['customerId'] as String,
        regNumberDisplay: json['regNumberDisplay'] as String,
        make: json['make'] as String?,
        model: json['model'] as String?,
        colour: json['colour'] as String?,
      );
}

class WashService {
  final String id;
  final String name;
  final String tier;
  final int basePrice; // cents
  final int durationMinutes;

  WashService({required this.id, required this.name, required this.tier, required this.basePrice, required this.durationMinutes});

  factory WashService.fromJson(Map<String, dynamic> json) => WashService(
        id: json['id'] as String,
        name: json['name'] as String,
        tier: json['tier'] as String? ?? 'standard',
        basePrice: currencyUnitsToCents(json['basePrice']),
        durationMinutes: json['durationMinutes'] as int,
      );
}

class WashExtra {
  final String id;
  final String name;
  final int price; // cents

  WashExtra({required this.id, required this.name, required this.price});

  factory WashExtra.fromJson(Map<String, dynamic> json) =>
      WashExtra(id: json['id'] as String, name: json['name'] as String, price: currencyUnitsToCents(json['price']));
}

class WashOrder {
  final String id;
  final String status;
  final int totalAmount; // cents
  final DateTime createdAt;
  final Vehicle? vehicle;
  final Customer? customer;

  WashOrder({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    this.vehicle,
    this.customer,
  });

  factory WashOrder.fromJson(Map<String, dynamic> json) => WashOrder(
        id: json['id'] as String,
        status: json['status'] as String,
        totalAmount: currencyUnitsToCents(json['totalAmount']),
        createdAt: DateTime.parse(json['createdAt'] as String),
        vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>) : null,
        customer: json['customer'] != null ? Customer.fromJson(json['customer'] as Map<String, dynamic>) : null,
      );
}

class LoyaltySummary {
  final int qualifyingCount;
  final int remaining;
  final bool hasAvailableReward;

  LoyaltySummary({required this.qualifyingCount, required this.remaining, required this.hasAvailableReward});

  factory LoyaltySummary.fromJson(Map<String, dynamic> json) => LoyaltySummary(
        qualifyingCount: json['qualifyingCount'] as int,
        remaining: json['remaining'] as int,
        hasAvailableReward: json['availableReward'] != null,
      );
}
