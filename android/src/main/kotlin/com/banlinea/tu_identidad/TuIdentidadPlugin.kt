package com.banlinea.tu_identidad

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** TuIdentidadPlugin */
public class TuIdentidadPlugin: FlutterPlugin, ActivityAware {

  lateinit var handlerImpl: MethodCallHandlerImpl
  lateinit var methodChannel : MethodChannel
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "tu_identidad")
    handlerImpl = MethodCallHandlerImpl()
    methodChannel.setMethodCallHandler(handlerImpl)
  }


  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "tu_identidad")
      val handler = MethodCallHandlerImpl()
      channel.setMethodCallHandler(handler)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    handlerImpl.setActivityPluginBinding(binding)

  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    handlerImpl.setActivityPluginBinding(binding)

  }

  override fun onDetachedFromActivityForConfigChanges() {
  }
}
