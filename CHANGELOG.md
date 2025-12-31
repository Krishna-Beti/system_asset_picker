# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.0.2] - 2025-12-30

### Changed
- Cleaned up example code by removing unnecessary comments for better readability
- Improved code documentation and examples

## [0.0.1] - 2025-12-29

### 🎉 Initial Release

This is the first release of system_asset_picker, bringing modern, permission-free media selection to Flutter apps on Android.

### ✨ Added

#### Core Functionality
- Single image picker with gallery and camera source support
- Single video picker with gallery and camera source support
- Multiple image picker with customizable item limit
- Multiple video picker with size limit control (MB)
- Combined images and videos picker with mixed media support
- Photo Picker availability checker for runtime detection

#### Platform Features
- Native Android Photo Picker UI integration (Android 13+)
- Fallback to ACTION_GET_CONTENT for Android 11-12
- MIME type filtering for older Android versions (5-10)
- Automatic file caching for selected media
- Persistent URI permissions handling
- Video file size validation with user notifications

#### Developer Experience
- Zero storage permissions required
- Play Store compliant implementation
- Comprehensive error handling
- Detailed logging for debugging
- Type-safe API with clear method signatures

#### User Experience
- System-native gallery UI
- Smooth multiple selection flow
- Toast notifications for size limit violations
- Automatic video size filtering
- Support for common image and video formats

### 📱 Platform Support

- **Android**: Minimum SDK 21 (Android 5.0 Lollipop)
- **Android Photo Picker**: Full support on Android 11+ (API 30+)
- **Target SDK**: 34 (Android 14)

### 🔒 Privacy & Security

- No `READ_EXTERNAL_STORAGE` permission needed
- No `READ_MEDIA_IMAGES` permission needed
- No `READ_MEDIA_VIDEO` permission needed
- Scoped storage implementation
- User-controlled file access only

### 📦 Dependencies

- `flutter`: SDK 2.5.0 or higher
- `image_picker`: ^1.1.2 (for camera functionality)
- `plugin_platform_interface`: ^2.1.8

### 🎯 Use Cases

Perfect for apps that need to:
- Select user photos and videos without broad permissions
- Comply with Google Play Store permission policies
- Provide a modern, native gallery experience
- Control video file sizes for uploads
- Support both single and multiple media selection

### 📝 Known Limitations

- Photo Picker UI requires Android 11+ (API 30+)
- Camera functionality requires device camera hardware
- Video size limits apply per-file, not total selection
- iOS support planned for future releases

### 🔮 Coming Soon

- iOS support using PHPicker
- Image compression options
- Custom video quality settings
- Batch file processing utilities
- Preview screens for selected media

---

## How to Upgrade

To upgrade to this version, update your `pubspec.yaml`:

```yaml
dependencies:
  system_asset_picker: ^0.0.1
```

Then run:
```bash
flutter pub upgrade system_asset_picker
```

## Feedback

We'd love to hear your feedback! If you encounter any issues or have suggestions:
- 🐛 [Report bugs](https://github.com/krishna-beti/system_asset_picker/issues)
- 💡 [Request features](https://github.com/krishna-beti/system_asset_picker/issues)
- ⭐ [Star us on GitHub](https://github.com/krishna-beti/system_asset_picker)

---

**Thank you for using system_asset_picker!** 🎉