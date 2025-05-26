import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_storage_supabase/gallery_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:io' if (dart.library.html) 'dart:html' as html; // Web support

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Uint8List? _imageBytes;
  String? _imageName;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageName = pickedFile.name;
      });
    }
  }

  Future<void> uploadImage() async {
    if (_imageBytes == null) return;

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${_imageName ?? 'image.png'}';
    final path = 'uploads/$fileName';

    try {
      await Supabase.instance.client.storage
          .from('images')
          .uploadBinary(path, _imageBytes!);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Image upload successful!")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Page")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageBytes != null
                  ? Image.memory(
                      _imageBytes!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : const Text("No image selected.."),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Pick Image"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: uploadImage,
                child: const Text("Upload"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryPage()),
                ),
                child: const Text("View Gallery"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
