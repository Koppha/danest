package com.denest.de_nest

import android.Manifest
import android.content.pm.PackageManager
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// Sends SMS straight through the device's own SIM via SmsManager — the
// same path the stock Messages app uses, billed against whatever SMS
// bundle/airtime is loaded on the SIM. No third-party gateway, no
// internet dependency. See lib/data/local/device_sms_provider.dart for
// the Dart side of this channel.
class MainActivity : FlutterActivity() {
    private val channelName = "de_nest/sms"
    private val smsPermissionRequestCode = 7231
    private var pendingPermissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasSmsPermission" -> result.success(hasSmsPermission())
                "requestSmsPermission" -> requestSmsPermission(result)
                "sendSms" -> sendSms(call.argument("phone"), call.argument("body"), result)
                else -> result.notImplemented()
            }
        }
    }

    private fun hasSmsPermission(): Boolean =
        ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED

    private fun requestSmsPermission(result: MethodChannel.Result) {
        if (hasSmsPermission()) {
            result.success(true)
            return
        }
        pendingPermissionResult = result
        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.SEND_SMS), smsPermissionRequestCode)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode != smsPermissionRequestCode) {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
            return
        }
        val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
        pendingPermissionResult?.success(granted)
        pendingPermissionResult = null
    }

    private fun sendSms(phone: String?, body: String?, result: MethodChannel.Result) {
        if (phone.isNullOrEmpty() || body.isNullOrEmpty()) {
            result.error("BAD_ARGS", "phone and body are required", null)
            return
        }
        if (!hasSmsPermission()) {
            result.error("NO_PERMISSION", "SEND_SMS permission not granted", null)
            return
        }
        try {
            val smsManager = SmsManager.getDefault()
            val parts = smsManager.divideMessage(body)
            if (parts.size > 1) {
                smsManager.sendMultipartTextMessage(phone, null, parts, null, null)
            } else {
                smsManager.sendTextMessage(phone, null, body, null, null)
            }
            result.success(null)
        } catch (e: Exception) {
            result.error("SEND_FAILED", e.message, null)
        }
    }
}
