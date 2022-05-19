import 'dart:io';

import 'package:flutter/material.dart';

class PreviewImageScreen extends StatelessWidget {
  const PreviewImageScreen({Key? key, this.file}) : super(key: key);

  final File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (file == null) {
            return const Center(
              child: Text('No File'),
            );
          }

          return Image.file(file!);
        },
      ),
    );
  }
}
