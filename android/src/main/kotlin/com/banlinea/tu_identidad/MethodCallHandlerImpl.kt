package com.banlinea.tu_identidad

import android.app.Activity.RESULT_OK
import android.app.Application
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.provider.MediaStore
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import com.tuid.idval.Models.method
import com.tuid.idval.TuID.*
import com.tuidentidad.address_sdk.AddressDocumentActivity
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import java.util.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import android.content.Context;

import android.app.Activity
import android.provider.ContactsContract

import io.flutter.embedding.engine.plugins.FlutterPlugin

import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

const val MY_SCAN_REQUEST_CODE = 100

class MethodCallHandlerImpl: MethodChannel.MethodCallHandler, ActivityAware , ActivityResultListener{

    var act: Activity? = null




    private lateinit var mActivityPluginBinding : ActivityPluginBinding
    var mResult : MethodChannel.Result? = null

    fun setActivityPluginBinding(@Nullable activityPluginBinding: ActivityPluginBinding) {
        this.mActivityPluginBinding = activityPluginBinding
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        act = null;
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        act = null;
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "ine" -> handleIne(call, result)
            "address" -> handleAddress(call, result)
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleIne(call: MethodCall, result: MethodChannel.Result) {
        mResult = result
        mActivityPluginBinding.addActivityResultListener(this)


        var showTutorial = false
        if (call.hasArgument("showTutorial")) {
            showTutorial = call.argument("showTutorial")?:false
        }
        var showResults = false
        if (call.hasArgument("showResults")) {
            showResults = call.argument("showResults")?:false
        }
        var apiKey = ""
        if (call.hasArgument("apiKey")) {
            apiKey = call.argument("apiKey")?:""
        }

        var INEMethod = method.INE
        if (call.hasArgument("method")) {
            INEMethod = when(call.argument("method")?:""){
                "INE" -> method.INE
                "IDVAL" -> method.IDVAL
                "ONLYOCR" -> method.ONLYOCR
                else -> method.INE
            }
        }

        var INEValidationInfo = true
        if (call.hasArgument("INEValidationInfo")) {
            INEValidationInfo = call.argument("INEValidationInfo")?:true
        }

        var INEValidationQuality = true
        if (call.hasArgument("INEValidationQuality")) {
            INEValidationQuality = call.argument("INEValidationQuality")?:true
        }

        var INEValidationPatterns = true
        if (call.hasArgument("INEValidationPatterns")) {
            INEValidationPatterns = call.argument("INEValidationPatterns")?:true
        }

        var INEValidationCurp = true
        if (call.hasArgument("INEValidationCurp")) {
            INEValidationCurp = call.argument("INEValidationCurp")?:true
        }

        init(mActivityPluginBinding.activity, showTutorial, showResults, apiKey, INEMethod, INEValidation(INEValidationInfo, INEValidationQuality, INEValidationPatterns, INEValidationCurp))
    }

    private fun handleAddress(call: MethodCall, result: MethodChannel.Result) {
        mResult = result
        mActivityPluginBinding.addActivityResultListener(this)

        var apiKey = ""
        if (call.hasArgument("apiKey")) {
            apiKey = call.argument("apiKey")?:""
        }
        val scanIntent = Intent(mActivityPluginBinding.activity, AddressDocumentActivity::class.java)


        scanIntent.putExtra("ApiKey", apiKey)
        mActivityPluginBinding.activity.startActivityForResult(scanIntent,MY_SCAN_REQUEST_CODE);

    }

    fun convert(bitmap: Bitmap): String? {
        val outputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
        return Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {


        if (requestCode == AUTHID_ACTIVITY_RESULT) {

            return if (resultCode == RESULT_OK) {

                val result: MutableMap<String, Any?> = HashMap()
                val extras = data!!.extras!!




                result["status"] = extras.getBoolean("status")
                result["response"] = extras.getString("response")
                result["error"] = extras.getString("error")
                result["inefPath"] = (extras.getParcelable("inefPath") as Uri).toString()
                result["inebPath"] = (extras.getParcelable("inebPath") as Uri).toString()
                val context: Context = mActivityPluginBinding.activity.getApplicationContext()



               val bitmap: Bitmap = MediaStore.Images.Media.getBitmap( context!!.contentResolver,(extras.getParcelable("inebPath") as Uri))
                val base64String: String = ImageUtil.convert(bitmap)

                // val bitmap = BitmapFactory.decodeStream(contentResolver.openInputStream((extras.getParcelable("inebPath") as Uri)))
             //   val bitmap: Bitmap = MediaStore.Images.Media.getBitmap(c.getContentResolver(), Uri.parse(paths))


                result["inebPatdfsfsdh"] = base64String

                mResult!!.success(result)
                true
            }else{

                mResult!!.success(null)
                false
            }
        } else if(requestCode == MY_SCAN_REQUEST_CODE) {
            return if (resultCode == RESULT_OK) {
                val result: MutableMap<String, Any?> = HashMap()
                val extras = data!!.extras!!
                result["status"] = extras.getBoolean("status")
                result["response"] = extras.getString("response")
                result["error"] = extras.getString("errorData")
                result["frontCFEPath"] = (extras.getParcelable("cfeimgPath") as Uri).toString()

                mResult!!.success(result)
                true
            } else {
                mResult!!.success(null)
                false
            }
        }
        return false
    }
}
