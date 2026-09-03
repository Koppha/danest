import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/device_sms_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('de_nest/sms');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('sends directly when permission is already granted', () async {
    final calls = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      switch (call.method) {
        case 'hasSmsPermission':
          return true;
        case 'sendSms':
          expect(call.arguments, {'phone': '62227247', 'body': 'hi'});
          return null;
      }
      throw UnsupportedError(call.method);
    });

    await DeviceSmsProvider().send(phone: '62227247', body: 'hi');

    expect(calls, ['hasSmsPermission', 'sendSms']);
  });

  test('requests permission first when not yet granted, then sends once granted', () async {
    final calls = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      switch (call.method) {
        case 'hasSmsPermission':
          return false;
        case 'requestSmsPermission':
          return true;
        case 'sendSms':
          return null;
      }
      throw UnsupportedError(call.method);
    });

    await DeviceSmsProvider().send(phone: '62227247', body: 'hi');

    expect(calls, ['hasSmsPermission', 'requestSmsPermission', 'sendSms']);
  });

  test('throws and never calls sendSms when permission is denied', () async {
    final calls = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      switch (call.method) {
        case 'hasSmsPermission':
          return false;
        case 'requestSmsPermission':
          return false;
      }
      throw UnsupportedError(call.method);
    });

    await expectLater(
      DeviceSmsProvider().send(phone: '62227247', body: 'hi'),
      throwsA(isA<SmsPermissionDeniedException>()),
    );

    expect(calls, ['hasSmsPermission', 'requestSmsPermission']);
  });
}
