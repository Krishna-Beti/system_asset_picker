# system_asset_picker Example

This example demonstrates how to use the `system_asset_picker` plugin to pick images and videos using Android's native Photo Picker UI.

## Features Demonstrated

- ✅ Check Photo Picker availability
- ✅ Pick single image from gallery
- ✅ Pick multiple images with max limit
- ✅ Pick single video from gallery
- ✅ Pick multiple videos with size limits
- ✅ Display selected media in a grid
- ✅ Show media details (size, path)
- ✅ Clear selection
- ✅ Error handling

## Running the Example

1. Navigate to the example directory:
```bash
cd example
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run on an Android device or emulator:
```bash
flutter run
```

## Requirements

- Android device or emulator running Android 11+ (API 30+) for full Photo Picker experience
- Flutter SDK 2.5.0 or higher

## Code Overview

The example app (`lib/main.dart`) includes:

### Main Features

1. **Picker Availability Check**
    - Displays whether Photo Picker is available on the device
    - Shows visual indicator (green checkmark or orange warning)

2. **Single Image Selection**
    - Button to pick a single image
    - Immediate display of selected image

3. **Multiple Image Selection**
    - Pick up to 10 images at once
    - Enforces maximum item limit

4. **Single Video Selection**
    - Pick a single video from gallery
    - Display video thumbnail with play icon overlay

5. **Multiple Video Selection**
    - Pick up to 5 videos
    - Enforces 100MB size limit per video
    - Shows toast notification for oversized videos

6. **Grid Display**
    - 3-column grid layout
    - Tap any item to view details
    - Video indicator overlay

7. **Media Details Dialog**
    - Shows file name and size
    - Displays preview image
    - Easy-to-read format (MB)

## Key Code Snippets

### Picking Multiple Images
```dart
ElevatedButton(
  onPressed: () async {
    var data = await SystemAssetPicker.pickMultipleImages(
      maxItems: 10
    );
    _selectedPaths = data;
    setState(() {});
  },
  child: const Text('Pick Multiple Images'),
)
```

### Picking Videos with Size Limit
```dart
ElevatedButton(
  onPressed: () async {
    var data = await SystemAssetPicker.pickMultipleVideos(
      maxItems: 5,
      maxVideoSizeMB: 100
    );
    _selectedPaths = data;
    setState(() {});
  },
  child: const Text('Pick Multiple Videos'),
)
```

### Displaying Media Grid
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemCount: _selectedPaths.length,
  itemBuilder: (context, index) {
    final path = _selectedPaths[index];
    return Image.file(File(path), fit: BoxFit.cover);
  },
)
```

## Customization

You can easily modify the example to:
- Change maximum item limits
- Adjust video size restrictions
- Customize the grid layout
- Add image compression
- Implement upload functionality
- Add more detailed media information

## Screenshots

The example app demonstrates:
- Clean, modern Material Design UI
- Native Photo Picker integration
- Responsive grid layout
- Clear visual feedback
- Professional error handling

## Learn More

For complete API documentation, visit:
- [Package Documentation](https://pub.dev/packages/system_asset_picker)
- [GitHub Repository](https://github.com/yourusername/system_asset_picker)

## Troubleshooting

**Photo Picker not showing?**
- Ensure your test device is Android 11+ (API 30+)
- Check the availability indicator in the app

**Videos not being selected?**
- Check if videos exceed the 100MB size limit
- Look for toast notifications indicating size issues

**Images not displaying?**
- Verify storage access on the device
- Check logcat for error messages

## Contributing

Found a bug or want to improve the example? Contributions are welcome!

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request