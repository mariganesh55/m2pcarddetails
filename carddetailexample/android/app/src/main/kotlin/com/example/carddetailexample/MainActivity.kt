package com.example.carddetailexample
import io.flutter.plugins.GeneratedPluginRegistrant;
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

import org.spongycastle.asn1.ASN1Sequence
import org.spongycastle.asn1.DERSequence
import org.spongycastle.asn1.DERBitString
import org.spongycastle.jce.ECNamedCurveTable
import org.spongycastle.jce.provider.BouncyCastleProvider
import org.spongycastle.jce.spec.ECPublicKeySpec
import org.spongycastle.math.ec.ECPoint

import java.security.*
import java.security.spec.ECGenParameterSpec
import java.security.spec.PKCS8EncodedKeySpec
import javax.crypto.Cipher
import javax.crypto.KeyAgreement
import javax.crypto.SecretKey
import javax.crypto.spec.IvParameterSpec

import android.content.SharedPreferences


class MainActivity: FlutterFragmentActivity() {

    private val CHANNEL = "samples.flutter.dev/battery"
    private val algorithmECDH = "ECDH"
    private val primeCurve = "prime256v1"
    private val algorithmAES = "AES/CBC/PKCS7Padding"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      // Note: this method is invoked on the main thread.
      call, result ->
    if (call.method == "getPublicString") {
         result.success(generatePublicKey())
    }else if (call.method == "getPrivateString") {
        result.success(generatePrivateKey())
    }else if (call.method == "getSecretString") {
       
    }else if (call.method == "getCardDetail") {
       val message = call.argument<String>("detailMessage").toString()
       val publickey = call.argument<String>("serverPublicKey").toString()
       result.success(decryptData(publickey,message));
    }else {
        result.notImplemented()
      }
    }

  }

    // generates public key and converts and saves the private key in shared prefs
    private fun generatePublicKey(): String {
        Security.insertProviderAt(BouncyCastleProvider(), 1)
        val ecParamSpec = ECGenParameterSpec(primeCurve)
        val kpg = KeyPairGenerator.getInstance(algorithmECDH)
        kpg.initialize(ecParamSpec)
        val keyPair = kpg.generateKeyPair()
        keyPair?.private?.encoded?.let {
            PrefUtil(this).setStringPref("PRIVATE_KEY", encodeHexString(it))
        }
        val sequencePublic: ASN1Sequence = DERSequence.getInstance(keyPair?.public?.encoded)
        val subjectPublicKey: DERBitString = sequencePublic.getObjectAt(1) as DERBitString
        val subjectPublicKeyBytes: ByteArray = subjectPublicKey.bytes
        PrefUtil(this).setStringPref(
            "CLIENT_PUBLIC_KEY",
            encodeHexString(subjectPublicKeyBytes)
        )
        return encodeHexString(subjectPublicKeyBytes)
    }

     private fun generatePrivateKey():String {
      val privateKey:String
      privateKey = PrefUtil(this).getStringPref(
                    "PRIVATE_KEY",
                    ""
                ).toString();
      return privateKey.toString()
    }

    // creates the secret using the server hex string and shared pref private key
    fun decryptData(serverPublicKey: String, encrypted: String): String {
        val kf = KeyFactory.getInstance(algorithmECDH)
        val privateKey1 = kf.generatePrivate(
            PKCS8EncodedKeySpec(
                PrefUtil(this).getStringPref(
                    "PRIVATE_KEY",
                    ""
                )?.let {
                    decodeHexString(it)
                })
        )
        val ecSpec = ECNamedCurveTable.getParameterSpec(primeCurve)
        val point: ECPoint = ecSpec.curve.decodePoint(decodeHexString(serverPublicKey))
        val pubSpec = ECPublicKeySpec(point, ecSpec)
        val publicKey = kf.generatePublic(pubSpec)
        val keyAgreement = KeyAgreement.getInstance(algorithmECDH)
        keyAgreement.init(privateKey1)
        keyAgreement.doPhase(publicKey, true)
        val key: SecretKey = keyAgreement.generateSecret(algorithmECDH)
        return decrypt(encrypted, key)
    }

    // Decrypts the encrypted json string
    @Throws(java.lang.Exception::class)
    fun decrypt(encrypted: String, key: SecretKey): String {
        val iv = ByteArray(16)
        val ivSpec = IvParameterSpec(iv)
        val cipher = Cipher.getInstance(algorithmAES)
        cipher.init(Cipher.DECRYPT_MODE, key, ivSpec)
        return String(
            cipher.doFinal(
                android.util.Base64.decode(
                    encrypted,
                    android.util.Base64.DEFAULT
                )
            )
        )
    }

    //To convert byte array to hex string
    private fun encodeHexString(byteArray: ByteArray): String {
        val hexStringBuffer = StringBuffer()
        for (i in byteArray.indices) {
            hexStringBuffer.append(byteToHex(byteArray[i].toInt()))
        }
        return hexStringBuffer.toString()
    }

    // To convert hex string to byte array
    private fun decodeHexString(hexString: String): ByteArray {
        require(hexString.length % 2 != 1) { "Invalid hexadecimal String supplied." }
        val bytes = ByteArray(hexString.length / 2)
        var i = 0
        while (i < hexString.length) {
            bytes[i / 2] = hexToByte(hexString.substring(i, i + 2))
            i += 2
        }
        return bytes
    }

    // Byte to hex convertor
    private fun byteToHex(num: Int): String {
        val hexDigits = CharArray(2)
        hexDigits[0] = Character.forDigit(num shr 4 and 0xF, 16)
        hexDigits[1] = Character.forDigit(num and 0xF, 16)
        return String(hexDigits)
    }

    // Hex to byte convertor
    private fun hexToByte(hexString: String): Byte {
        val firstDigit = toDigit(hexString[0])
        val secondDigit = toDigit(hexString[1])
        return ((firstDigit shl 4) + secondDigit).toByte()
    }
    
    // Digit conversion
    private fun toDigit(hexChar: Char): Int {
        val digit = Character.digit(hexChar, 16)
        require(digit != -1) { "Invalid Hexadecimal Character: $hexChar" }
        return digit
    }
}

internal class PrefUtil(context: Context?) {
    private var settings: SharedPreferences? = null
    private var editor: SharedPreferences.Editor
    init {
        settings = context?.getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE)
        editor = settings!!.edit()
    }
    fun setStringPref(key: String, value: String) {
        editor.putString(key, value)
        editor.commit()
    }

    fun getStringPref(key: String, defValue: String): String? {
        return settings!!.getString(key, defValue)
    }
    companion object {
        val MyPREFERENCES = "com.m2p.carddetails.utils.PrefUtil"
    }
}
