import 'package:flutter/services.dart';

import 'sms_service.dart';

class SmsPermissionDeniedException implements Exception {
  @override
  String toString() => 'SMS permission was not granted';
}

/// Sends SMS straight through the device's own SIM (Android's SmsManager),
/// the same path the stock Messages app uses — billed against whatever
/// SMS bundle/airtime is loaded on the SIM. No internet, no third-party
/// gateway account. See android/.../MainActivity.kt for the native side.
class DeviceSmsProvider implements SmsProvider {
  static const _channel = MethodChannel('de_nest/sms');

  Future<bool> hasPermission() async => (await _channel.invokeMethod<bool>('hasSmsPermission')) ?? false;

  Future<bool> requestPermission() async => (await _channel.invokeMethod<bool>('requestSmsPermission')) ?? false;

  @override
  Future<void> send({required String phone, required String body, bool allowPermissionPrompt = true}) async {
    final granted = await hasPermission() || (allowPermissionPrompt && await requestPermission());
    if (!granted) {
      throw SmsPermissionDeniedException();
    }
    await _channel.invokeMethod('sendSms', {'phone': phone, 'body': body});
  }
}
