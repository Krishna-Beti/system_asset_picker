package com.example.system_asset_picker

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.provider.OpenableColumns
import android.widget.Toast
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.io.FileOutputStream

class SystemAssetPickerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
  PluginRegistry.ActivityResultListener {

  private lateinit var channel: MethodChannel
  private var activity: Activity? = null
  private var pendingResult: Result? = null
  private var activityBinding: ActivityPluginBinding? = null
  private var maxItemsLimit: Int = 10
  private var maxVideoSizeMB: Long = 100L
  private var maxVideoSizeBytes: Long = 100L * 1024 * 1024

  // Track what type of media is being picked
  private var currentMediaType: MediaType = MediaType.IMAGES_AND_VIDEOS

  private val PICK_MEDIA_REQUEST_CODE = 1001

  // Enum to track media selection type
  enum class MediaType {
    IMAGES_ONLY,
    VIDEOS_ONLY,
    IMAGES_AND_VIDEOS
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(
      flutterPluginBinding.binaryMessenger,
      "com.example.system_asset_picker/photo_picker"
    )
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "pickImagesAndVideos" -> {
        val maxItems = call.argument<Int>("maxItems") ?: 10
        val maxVideoSizeMB = call.argument<Int>("maxVideoSizeMB") ?: 100
        pickMedia(maxItems, maxVideoSizeMB, MediaType.IMAGES_AND_VIDEOS, result)
      }
      "pickImages" -> {
        val maxItems = call.argument<Int>("maxItems") ?: 10
        pickMedia(maxItems, 0, MediaType.IMAGES_ONLY, result)
      }
      "pickVideos" -> {
        val maxItems = call.argument<Int>("maxItems") ?: 10
        val maxVideoSizeMB = call.argument<Int>("maxVideoSizeMB") ?: 100
        pickMedia(maxItems, maxVideoSizeMB, MediaType.VIDEOS_ONLY, result)
      }
      "isPhotoPickerAvailable" -> {
        result.success(isPhotoPickerAvailable())
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityBinding = binding
    activity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityBinding?.removeActivityResultListener(this)
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityBinding = binding
    activity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivity() {
    activityBinding?.removeActivityResultListener(this)
    activity = null
    activityBinding = null
  }

  private fun pickMedia(maxItems: Int, maxVideoSizeMB: Int, mediaType: MediaType, result: Result) {
    if (activity == null) {
      result.error("NO_ACTIVITY", "Activity is not available", null)
      return
    }

    pendingResult = result
    maxItemsLimit = maxItems
    currentMediaType = mediaType
    this.maxVideoSizeMB = maxVideoSizeMB.toLong()
    this.maxVideoSizeBytes = this.maxVideoSizeMB * 1024 * 1024

    try {
      val intent = createPickerIntent(maxItems, mediaType)
      activity?.startActivityForResult(intent, PICK_MEDIA_REQUEST_CODE)
    } catch (e: Exception) {
      android.util.Log.e("SystemAssetPicker", "Error launching picker", e)
      pendingResult?.error("PICKER_ERROR", e.message, null)
      pendingResult = null
    }
  }

  private fun createPickerIntent(maxItems: Int, mediaType: MediaType): Intent {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      // Android 13+ - Use Photo Picker with specific media type
      Intent(MediaStore.ACTION_PICK_IMAGES).apply {
        putExtra(MediaStore.EXTRA_PICK_IMAGES_MAX, maxItems)

        // Set media type filter for Android 13+
        when (mediaType) {
          MediaType.IMAGES_ONLY -> {
            type = "image/*"
          }
          MediaType.VIDEOS_ONLY -> {
            type = "video/*"
          }
          MediaType.IMAGES_AND_VIDEOS -> {
            // Default behavior - shows both
          }
        }

        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
      }
    } else {
      // Android 12 and below - use GET_CONTENT with specific MIME types
      createGetContentIntent(mediaType)
    }
  }

  private fun createGetContentIntent(mediaType: MediaType): Intent {
    return Intent(Intent.ACTION_GET_CONTENT).apply {
      when (mediaType) {
        MediaType.IMAGES_ONLY -> {
          // Only show images
          type = "image/*"
          android.util.Log.d("SystemAssetPicker", "Picker set to IMAGES_ONLY")
        }
        MediaType.VIDEOS_ONLY -> {
          // Only show videos
          type = "video/*"
          android.util.Log.d("SystemAssetPicker", "Picker set to VIDEOS_ONLY")
        }
        MediaType.IMAGES_AND_VIDEOS -> {
          // Show both images and videos
          type = "*/*"
          val mimeTypes = arrayOf("image/*", "video/*")
          putExtra(Intent.EXTRA_MIME_TYPES, mimeTypes)
          android.util.Log.d("SystemAssetPicker", "Picker set to IMAGES_AND_VIDEOS")
        }
      }

      putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
      addCategory(Intent.CATEGORY_OPENABLE)
      addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
    }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode == PICK_MEDIA_REQUEST_CODE) {
      if (resultCode == Activity.RESULT_OK && data != null) {
        handlePickedMedia(data)
      } else {
        // User cancelled
        pendingResult?.success(emptyList<String>())
        pendingResult = null
      }
      return true
    }
    return false
  }

  private fun handlePickedMedia(data: Intent) {
    val currentActivity = activity ?: run {
      pendingResult?.error("NO_ACTIVITY", "Activity is not available", null)
      pendingResult = null
      return
    }

    val uris = mutableListOf<Uri>()

    // Handle multiple selection
    if (data.clipData != null) {
      val clipData = data.clipData!!
      android.util.Log.d("SystemAssetPicker", "ClipData found with ${clipData.itemCount} items")
      for (i in 0 until clipData.itemCount) {
        val uri = clipData.getItemAt(i).uri
        uris.add(uri)
        if (uris.size >= maxItemsLimit) break
      }
    }
    // Handle single selection
    else if (data.data != null) {
      android.util.Log.d("SystemAssetPicker", "Single URI found")
      uris.add(data.data!!)
    }

    android.util.Log.d("SystemAssetPicker", "Total URIs received: ${uris.size}")

    // Take persistent permission for each URI
    uris.forEach { uri ->
      try {
        currentActivity.contentResolver.takePersistableUriPermission(
          uri,
          Intent.FLAG_GRANT_READ_URI_PERMISSION
        )
      } catch (e: Exception) {
        android.util.Log.w("SystemAssetPicker", "Could not take persistable permission for $uri", e)
        // Continue anyway - the URI might still work
      }
    }

    val validPaths = mutableListOf<String>()
    var hasOversizedVideo = false

    uris.forEach { uri ->
      val mimeType = currentActivity.contentResolver.getType(uri)
      val isVideo = mimeType?.startsWith("video/") == true
      val isImage = mimeType?.startsWith("image/") == true

      android.util.Log.d("SystemAssetPicker", "Processing URI: $uri")
      android.util.Log.d("SystemAssetPicker", "MIME type: $mimeType")
      android.util.Log.d("SystemAssetPicker", "Is video: $isVideo, Is image: $isImage")

      // Filter based on current media type selection
      val shouldProcess = when (currentMediaType) {
        MediaType.IMAGES_ONLY -> isImage
        MediaType.VIDEOS_ONLY -> isVideo
        MediaType.IMAGES_AND_VIDEOS -> isImage || isVideo
      }

      if (!shouldProcess) {
        android.util.Log.d("SystemAssetPicker", "Skipping - doesn't match media type filter")
        return@forEach
      }

      if (isVideo) {
        val fileSize = getFileSize(uri, currentActivity)
        val fileSizeMB = fileSize / (1024.0 * 1024.0)

        android.util.Log.d(
          "SystemAssetPicker",
          "Video size: $fileSize bytes (${String.format("%.2f", fileSizeMB)} MB)"
        )
        android.util.Log.d("SystemAssetPicker", "Max allowed: $maxVideoSizeMB MB")

        if (fileSize > 0 && fileSize <= maxVideoSizeBytes) {
          android.util.Log.d("SystemAssetPicker", "Video accepted")
          copyUriToCache(uri, currentActivity)?.let { validPaths.add(it) }
        } else if (fileSize > maxVideoSizeBytes) {
          android.util.Log.d("SystemAssetPicker", "Video REJECTED: exceeds size limit")
          hasOversizedVideo = true
        } else {
          android.util.Log.d("SystemAssetPicker", "Video size could not be determined, skipping")
        }
      } else if (isImage) {
        android.util.Log.d("SystemAssetPicker", "Adding image")
        copyUriToCache(uri, currentActivity)?.let { validPaths.add(it) }
      }
    }

    if (hasOversizedVideo) {
      currentActivity.runOnUiThread {
        Toast.makeText(
          currentActivity,
          "You can't select videos over $maxVideoSizeMB MB in size.",
          Toast.LENGTH_LONG
        ).show()
      }
    }

    android.util.Log.d("SystemAssetPicker", "Total valid paths: ${validPaths.size}")
    pendingResult?.success(validPaths)
    pendingResult = null
  }

  private fun getFileSize(uri: Uri, activity: Activity): Long {
    return try {
      // Method 1: Using ContentResolver query with OpenableColumns
      activity.contentResolver.query(uri, null, null, null, null)?.use { cursor ->
        if (cursor.moveToFirst()) {
          val sizeIndex = cursor.getColumnIndex(OpenableColumns.SIZE)
          if (sizeIndex != -1) {
            val size = cursor.getLong(sizeIndex)
            android.util.Log.d("SystemAssetPicker", "Size from OpenableColumns: $size")
            return size
          }
        }
      }

      // Method 2: Using AssetFileDescriptor
      activity.contentResolver.openAssetFileDescriptor(uri, "r")?.use { descriptor ->
        val size = descriptor.length
        android.util.Log.d("SystemAssetPicker", "Size from AssetFileDescriptor: $size")
        return size
      }

      android.util.Log.d("SystemAssetPicker", "Could not determine file size")
      0L
    } catch (e: Exception) {
      android.util.Log.e("SystemAssetPicker", "Error getting file size: ${e.message}", e)
      0L
    }
  }

  private fun isPhotoPickerAvailable(): Boolean {
    // On Android 11+, we can use either Photo Picker or GET_CONTENT
    // Both support multiple selection
    return Build.VERSION.SDK_INT >= Build.VERSION_CODES.R
  }

  private fun copyUriToCache(uri: Uri, activity: Activity): String? {
    try {
      val inputStream = activity.contentResolver.openInputStream(uri) ?: return null

      val mimeType = activity.contentResolver.getType(uri)
      val extension = when {
        mimeType?.startsWith("image/") == true -> {
          mimeType.substringAfter("image/")
        }
        mimeType?.startsWith("video/") == true -> {
          mimeType.substringAfter("video/")
        }
        else -> "tmp"
      }

      val fileName = "media_${System.currentTimeMillis()}.$extension"
      val file = File(activity.cacheDir, fileName)

      val outputStream = FileOutputStream(file)
      inputStream.copyTo(outputStream)

      inputStream.close()
      outputStream.close()

      android.util.Log.d("SystemAssetPicker", "File copied to: ${file.absolutePath}")
      return file.absolutePath
    } catch (e: Exception) {
      android.util.Log.e("SystemAssetPicker", "Error copying file", e)
      e.printStackTrace()
      return null
    }
  }
}