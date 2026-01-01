# system_asset_picker

A modern Flutter plugin that leverages Android's native Photo Picker UI to select images and videos
without requiring storage permissions. This plugin provides a clean, system-native experience that
complies with Play Store guidelines while offering powerful media selection capabilities.

## 🎬 Demo

![App Demo]([https://github.com/Krishna-Beti/system_asset_picker/blob/main/assets/gifs/demo_gif.gif])

## 🌟 Features

- ✅ **No Storage Permissions Required** - Uses Android's built-in Photo Picker (Android 11+) and
  scoped storage
- 🎨 **Native Photo Picker UI** - Beautiful, system-native gallery interface
- 📸 **Single & Multiple Image Selection** - Pick one or many images with customizable limits
- 🎥 **Video Selection with Size Limits** - Pick videos with configurable size restrictions
- 🔄 **Combined Media Selection** - Select both images and videos together
- 📷 **Camera Support** - Direct camera access for capturing new photos/videos
- 🚀 **Play Store Compliant** - No broad storage permissions needed
- ⚡ **Performant** - Efficient handling of large media files

## 🎯 Why This Package?

Popular packages like `image_picker`, `file_picker` and some other packages have limitations:

- They often require `READ_MEDIA_IMAGES` and `READ_MEDIA_VIDEO` permissions
- Play Store may reject apps using these permissions without "broad usage" justification
- They don't provide the modern, native Photo Picker UI
- Limited control over video size restrictions

**system_asset_picker** solves all these issues while providing a superior user experience.

## 📋 Requirements

- **Minimum SDK**: Android API 21 (Android 5.0)
- **Recommended**: Android API 30+ (Android 11+) for full Photo Picker support
- **Flutter**: 2.5.0 or higher

## 🚀 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  system_asset_picker: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 📱 Platform Setup

### Android

Update your `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34 // or higher
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

**No permissions required in AndroidManifest.xml!** 🎉

The plugin automatically handles scoped storage and Photo Picker access.

## 💻 Usage

### Import the Package

```dart
import 'package:system_asset_picker/system_asset_picker.dart';
```

### Check Photo Picker Availability

```dart

bool isAvailable = await
SystemAssetPicker.isPhotoPickerAvailable
();if
(
isAvailable) {
print('Photo Picker is available on this device');
}
```

### Pick a Single Image

```dart
// From gallery
XFile? image = await
SystemAssetPicker.pickImage
();

// From camera
XFile? image = await
SystemAssetPicker.pickImage
(
source: ImageSource.camera
);

if (image != null) {
print('Selected image: ${image.path}');
}
```

### Pick Multiple Images

```dart

List<String> imagePaths = await
SystemAssetPicker.pickMultipleImages
(
maxItems: 10, // Maximum number of images
);

print('Selected ${imagePaths
.
length
}
 images
'
);
```

### Pick a Single Video

```dart
// From gallery
XFile? video = await
SystemAssetPicker.pickVideo
();

// From camera
XFile? video = await
SystemAssetPicker.pickVideo
(
source: ImageSource.camera
);

if (video != null) {
print('Selected video: ${video.path}');
}
```

### Pick Multiple Videos with Size Limit

```dart

List<String> videoPaths = await
SystemAssetPicker.pickMultipleVideos
(
maxItems: 5, // Maximum number of videos
maxVideoSizeMB: 50, // Maximum size per video in MB
);

print('Selected ${videoPaths.length} videos');
```

### Pick Images and Videos Together

```dart

List<String> mediaPaths = await
SystemAssetPicker.pickImagesAndVideos
(
maxItems: 10, // Maximum total items
maxVideoSizeMB: 100, // Maximum size per video in MB
);

// Process mixed media
for (String path in mediaPaths) {
if (path.toLowerCase().endsWith('.mp4') ||
path.toLowerCase().endsWith('.mov')) {
print('Video: $path');
} else {
print('Image: $path');
}
}
```

## 📖 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:system_asset_picker/system_asset_picker.dart';
import 'dart:io';

class MediaPickerScreen extends StatefulWidget {
  @override
  _MediaPickerScreenState createState() => _MediaPickerScreenState();
}

class _MediaPickerScreenState extends State<MediaPickerScreen> {
  List<String> _selectedMedia = [];

  Future<void> _pickMedia() async {
    try {
      final paths = await SystemAssetPicker.pickImagesAndVideos(
        maxItems: 10,
        maxVideoSizeMB: 50,
      );

      setState(() {
        _selectedMedia = paths;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected ${paths.length} items')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Media Picker')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickMedia,
            child: Text('Pick Images & Videos'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _selectedMedia.length,
              itemBuilder: (context, index) {
                return Image.file(
                  File(_selectedMedia[index]),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🎨 API Reference

### SystemAssetPicker

| Method                     | Parameters                   | Return Type            | Description                                |
|----------------------------|------------------------------|------------------------|--------------------------------------------|
| `pickImage()`              | `source` (optional)          | `Future<XFile?>`       | Pick a single image from gallery or camera |
| `pickVideo()`              | `source` (optional)          | `Future<XFile?>`       | Pick a single video from gallery or camera |
| `pickMultipleImages()`     | `maxItems` (required)        | `Future<List<String>>` | Pick multiple images with limit            |
| `pickMultipleVideos()`     | `maxItems`, `maxVideoSizeMB` | `Future<List<String>>` | Pick multiple videos with size limit       |
| `pickImagesAndVideos()`    | `maxItems`, `maxVideoSizeMB` | `Future<List<String>>` | Pick mixed media with limits               |
| `isPhotoPickerAvailable()` | None                         | `Future<bool>`         | Check if Photo Picker is available         |

### Parameters

- **maxItems**: Maximum number of items that can be selected
- **maxVideoSizeMB**: Maximum size per video in megabytes (default: 100MB)
- **source**: `ImageSource.gallery` or `ImageSource.camera` (default: gallery)

## 🔒 Privacy & Permissions

This plugin is designed with privacy in mind:

- ✅ No `READ_EXTERNAL_STORAGE` permission needed
- ✅ No `READ_MEDIA_IMAGES` permission needed
- ✅ No `READ_MEDIA_VIDEO` permission needed
- ✅ Uses Android's scoped storage and Photo Picker APIs
- ✅ Fully compliant with Google Play Store policies

The plugin only accesses files that the user explicitly selects through the system UI.

## 📊 Supported Android Versions

| Android Version | API Level | Photo Picker | Functionality                                  |
|-----------------|-----------|--------------|------------------------------------------------|
| Android 13+     | 33+       | Native       | Full native Photo Picker with all features     |
| Android 11-12   | 30-32     | Fallback     | Uses ACTION_GET_CONTENT with file type filters |
| Android 5-10    | 21-29     | Fallback     | Basic file picker with MIME type filtering     |

## ⚠️ Limitations

- Photo Picker UI is only available on Android 11+ (API 30+)
- On older Android versions, a basic file picker is used
- Videos exceeding the size limit will be filtered out with a toast notification
- Camera functionality requires camera hardware on the device

## 🐛 Troubleshooting

### Photo Picker Not Showing

**Problem**: Photo Picker doesn't appear on device

**Solution**: Ensure your device is running Android 11+ (API 30+). Check availability:

```dart

bool available = await
SystemAssetPicker.isPhotoPickerAvailable
();
```

### Video Size Limit Not Working

**Problem**: Large videos are not being filtered

**Solution**: Ensure you're passing `maxVideoSizeMB` parameter:

```dart
await
SystemAssetPicker.pickMultipleVideos
(
maxItems
:
5
,
maxVideoSizeMB
:
50
, // Add this parameter
);
```

### Images Not Displaying

**Problem**: Selected images show error icon

**Solution**: Verify file paths are accessible and files exist:

```dart
for (String path in paths) {
final file = File(path);
if (await file.exists()) {
print('File exists: $path');
}
}
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open
an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 💬 Support

If you find this package helpful, please:

- ⭐ Star the repository
- 🐛 Report issues on GitHub
- 💡 Suggest new features
- 📢 Share with other developers

## 🔗 Links

- [Package on pub.dev](https://pub.dev/packages/system_asset_picker)
- [GitHub Repository](https://github.com/krishna-beti/system_asset_picker)
- [Issue Tracker](https://github.com/krishna-beti/system_asset_picker/issues)
- [Changelog](CHANGELOG.md)

## 👨‍💻 Author

Created and maintained by [Your Name]

---

**Made with ❤️ for the Flutter community**
