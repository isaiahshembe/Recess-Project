package com.example.touristapp

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.ActionCodeSettings

class MainActivity: FlutterActivity() {

    private val TAG = "MainActivity"
    private val auth = FirebaseAuth.getInstance()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set up ActionCodeSettings
        val actionCodeSettings = ActionCodeSettings.newBuilder()
            .setUrl("https://www.example.com/finishSignUp?cartId=1234")
            .setHandleCodeInApp(true)
            .setIOSBundleId("com.example.ios")
            .setAndroidPackageName(
                "com.example.android",
                true, // installIfNotAvailable
                "12" // minimumVersion
            )
            .build()

        // Example usage of sendSignInLinkToEmail
        val email = "user@example.com" // Replace with actual email
        auth.sendSignInLinkToEmail(email, actionCodeSettings)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    Log.d(TAG, "Email sent.")
                } else {
                    Log.e(TAG, "Error sending email: ${task.exception?.message}")
                }
            }

        // Handling the sign-in link
        val intent = intent
        val emailLink = intent.data.toString()

        if (auth.isSignInWithEmailLink(emailLink)) {
            val email = "someemail@domain.com" // Retrieve this from storage

            auth.signInWithEmailLink(email, emailLink)
                .addOnCompleteListener { task ->
                    if (task.isSuccessful) {
                        Log.d(TAG, "Sign-in successful.")
                    } else {
                        Log.e(TAG, "Sign-in failed: ${task.exception?.message}")
                    }
                }
        }
    }
}
