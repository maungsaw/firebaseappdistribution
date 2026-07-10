package com.sawhtunaung.firebaseappdistribution

import android.app.Activity
import android.app.KeyguardManager
import android.content.Context
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val channelName = "com.sawhtunaung.firebaseappdistribution/device_credential"
    private var pendingAuthResult: MethodChannel.Result? = null

    private val credentialLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { activityResult ->
            val result = pendingAuthResult
            pendingAuthResult = null
            if (result == null) return@registerForActivityResult

            if (activityResult.resultCode == Activity.RESULT_OK) {
                result.success(
                    hashMapOf(
                        "success" to true,
                    ),
                )
            } else {
                result.success(
                    hashMapOf(
                        "success" to false,
                        "errorCode" to "cancelled",
                    ),
                )
            }
        }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isDeviceSecure" -> result.success(isDeviceSecure())
                    "authenticate" -> {
                        if (pendingAuthResult != null) {
                            result.error(
                                "auth_in_progress",
                                "Authentication already in progress",
                                null,
                            )
                            return@setMethodCallHandler
                        }
                        val title = call.argument<String>("title") ?: "Phone Security Required"
                        val description =
                            call.argument<String>("description")
                                ?: "Use your phone PIN, pattern, or password"
                        authenticateWithDeviceCredential(title, description, result)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun isDeviceSecure(): Boolean {
        val keyguardManager =
            getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager ?: return false
        return keyguardManager.isDeviceSecure
    }

    private fun authenticateWithDeviceCredential(
        title: String,
        description: String,
        result: MethodChannel.Result,
    ) {
        val keyguardManager =
            getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
        if (keyguardManager == null || !keyguardManager.isDeviceSecure) {
            result.success(
                hashMapOf(
                    "success" to false,
                    "errorCode" to "PasscodeNotSet",
                ),
            )
            return
        }

        val intent = keyguardManager.createConfirmDeviceCredentialIntent(title, description)
        if (intent == null) {
            result.success(
                hashMapOf(
                    "success" to false,
                    "errorCode" to "NotAvailable",
                ),
            )
            return
        }

        pendingAuthResult = result
        credentialLauncher.launch(intent)
    }
}
