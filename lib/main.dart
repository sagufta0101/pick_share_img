import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePickerGridView(),
    );
  }
}

class ImagePickerGridView extends StatefulWidget {
  @override
  _ImagePickerGridViewState createState() => _ImagePickerGridViewState();
}

class _ImagePickerGridViewState extends State<ImagePickerGridView> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFileList!.addAll(pickedFiles);
      });
    }
  }

  Future<void> _shareImages() async {
    if (_imageFileList != null && _imageFileList!.isNotEmpty) {
      List<String> imagePaths =
          _imageFileList!.map((file) => file.path).toList();
      await Share.shareFiles(imagePaths, text: 'Check out these images!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker GridView'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareImages,
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImages,
            child: Text('Pick Images'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _imageFileList!.length,
              itemBuilder: (context, index) {
                return Image.file(
                  File(_imageFileList![index].path),
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
