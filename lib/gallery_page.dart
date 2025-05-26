import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<FileObject> _files = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchFiles();
  }

  Future<void> fetchFiles() async {
    try {
      final response = await Supabase.instance.client.storage
          .from('images')
          .list(
            path: 'uploads/',
            searchOptions: const SearchOptions(limit: 100),
          );

      setState(() {
        _files = response;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching images: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
          ? const Center(child: Text("No images found"))
          : ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                final publicUrl = Supabase.instance.client.storage
                    .from('images')
                    .getPublicUrl('uploads/${file.name}');

                return ListTile(
                  leading: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      publicUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(file.name),
                );
              },
            ),
    );
  }
}
