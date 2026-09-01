import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import 'api_client.dart';

const _uuid = Uuid();

class PosRepository {
  final Dio _dio;
  PosRepository(this._dio);

  Future<List<Customer>> searchCustomers(String query) async {
    final resp = await _dio.get(
      '/customers',
      queryParameters: {if (query.isNotEmpty) 'q': query},
    );
    return (resp.data as List<dynamic>)
        .map((e) => Customer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Customer> createCustomer({
    required String fullName,
    required String phone,
    required String branchId,
  }) async {
    final resp = await _dio.post(
      '/customers',
      data: {
        'id': _uuid.v4(),
        'branchId': branchId,
        'fullName': fullName,
        'phone': phone,
      },
    );
    return Customer.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Vehicle> createVehicle({
    required String customerId,
    required String regNumber,
    String? make,
    String? model,
    String? colour,
  }) async {
    final resp = await _dio.post(
      '/vehicles',
      data: {
        'id': _uuid.v4(),
        'customerId': customerId,
        'regNumber': regNumber,
        'make': ?make,
        'model': ?model,
        'colour': ?colour,
      },
    );
    return Vehicle.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<WashService>> listServices() async {
    final resp = await _dio.get('/wash-services');
    return (resp.data as List<dynamic>)
        .map((e) => WashService.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<WashExtra>> listExtras() async {
    final resp = await _dio.get('/wash-extras');
    return (resp.data as List<dynamic>)
        .map((e) => WashExtra.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LoyaltySummary> loyaltySummary(String vehicleId) async {
    final resp = await _dio.get('/loyalty/vehicles/$vehicleId/summary');
    return LoyaltySummary.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<WashOrder> startWash({
    required String vehicleId,
    required List<Map<String, dynamic>> items,
  }) async {
    final resp = await _dio.post(
      '/wash-orders',
      data: {'id': _uuid.v4(), 'vehicleId': vehicleId, 'items': items},
    );
    return WashOrder.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<WashOrder>> queue() async {
    final resp = await _dio.get('/wash-orders/queue');
    return (resp.data as List<dynamic>)
        .map((e) => WashOrder.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> transitionWash(String washOrderId, String toStatus) async {
    await _dio.patch(
      '/wash-orders/$washOrderId/status',
      data: {'toStatus': toStatus},
    );
  }

  Future<void> finishWash(
    String washOrderId,
    List<Map<String, dynamic>> components,
  ) async {
    await _dio.post(
      '/wash-orders/$washOrderId/finish',
      data: {'components': components},
      options: Options(headers: {'Idempotency-Key': 'finish:$washOrderId'}),
    );
  }

  Future<Map<String, dynamic>> prepaidOverview(String customerId) async {
    final resp = await _dio.get('/prepaid/customers/$customerId/overview');
    return resp.data as Map<String, dynamic>;
  }

  Future<void> depositToWallet({
    required String customerId,
    required double amount,
    required String method,
  }) async {
    await _dio.post(
      '/prepaid/deposits',
      data: {
        'customerId': customerId,
        'amount': amount,
        'method': method,
        'clientEntryId': _uuid.v4(),
      },
    );
  }

  Future<Map<String, dynamic>> dashboardSummary({
    required DateTime from,
    required DateTime to,
  }) async {
    final resp = await _dio.get(
      '/reports/summary',
      queryParameters: {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
      },
    );
    return resp.data as Map<String, dynamic>;
  }
}

final posRepositoryProvider = Provider<PosRepository>(
  (ref) => PosRepository(ref.watch(apiClientProvider)),
);
