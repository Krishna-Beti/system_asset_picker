import 'package:flutter/material.dart';
import 'dart:io';
import 'package:system_asset_picker/system_asset_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Media Picker Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _selectedPaths = [];
  bool _isPickerAvailable = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkPickerAvailability();
  }

  Future<void> _checkPickerAvailability() async {
    final isAvailable = await SystemAssetPicker.isPhotoPickerAvailable();
    setState(() {
      _isPickerAvailable = isAvailable;
    });
  }

  /*Future<void> _pickMedia(int maxItems) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final paths = await SystemAssetPicker.pickImagesAndVideos(maxItems: maxItems, maxVideoSizeMB: 50);
      setState(() {
        _selectedPaths = paths;
        _isLoading = false;
      });

      if (paths.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected ${paths.length} item(s)'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }*/

  void _clearSelection() {
    setState(() {
      _selectedPaths = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('System Asset Picker Demo'),
        actions: [
          if (_selectedPaths.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSelection,
              tooltip: 'Clear selection',
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: _isPickerAvailable ? Colors.green[100] : Colors.orange[100],
            child: Row(
              children: [
                Icon(
                  _isPickerAvailable ? Icons.check_circle : Icons.warning,
                  color: _isPickerAvailable ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isPickerAvailable
                        ? 'Photo Picker is available on this device'
                        : 'Photo Picker not available (requires Android 11+)',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select Maximum Items:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        var data = await SystemAssetPicker.pickImage();
                        if(data != null) {
                          _selectedPaths = [data.path];
                        }
                        setState(() {});
                      },
                      child: const Text('Pick Single Image'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var data = await SystemAssetPicker.pickMultipleImages(maxItems: 10);
                        _selectedPaths = data;
                        setState(() {});
                      },
                      child: const Text('Pick Multiple Images with max limit'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var data = await SystemAssetPicker.pickVideo();
                        if(data != null) {
                          _selectedPaths = [data.path];
                        }
                        setState(() {});
                      },
                      child: const Text('Pick single Video'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var data = await SystemAssetPicker.pickMultipleVideos(maxItems: 5, maxVideoSizeMB: 100);
                        _selectedPaths = data;
                        setState(() {});
                      },
                      child: const Text('Pick multiple Videos with max limit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              _selectedPaths.isEmpty
                  ? 'No items selected'
                  : 'Selected ${_selectedPaths.length} item(s)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedPaths.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Tap a button above to select media',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _selectedPaths.length,
              itemBuilder: (context, index) {
                final path = _selectedPaths[index];
                final isVideo = path.toLowerCase().endsWith('.mp4') ||
                    path.toLowerCase().endsWith('.mov') ||
                    path.toLowerCase().endsWith('.avi');

                return GestureDetector(
                  onTap: () => _showMediaDetails(path),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(path),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      if (isVideo)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildPickButton(String label, int maxItems) {
    return ElevatedButton(
      onPressed: _isPickerAvailable ? () {
        _pickMedia(maxItems);
      } : () {
        print('Photo Picker not available on this device');
      },
      child: Text(label),
    );
  }*/

  void _showMediaDetails(String path) {
    final file = File(path);
    final size = file.lengthSync();
    final sizeMB = size / (1024 * 1024);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Media Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Path: ${path.split('/').last}'),
            const SizedBox(height: 8),
            Text('Size: ${sizeMB.toStringAsFixed(2)} MB'),
            const SizedBox(height: 16),
            Image.file(
              file,
              height: 200,
              fit: BoxFit.contain,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}