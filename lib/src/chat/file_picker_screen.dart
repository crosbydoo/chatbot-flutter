import 'package:flutter/material.dart';

class FilePickerBottomSheet extends StatelessWidget {
  final void Function() onPickImage;
  final void Function() onPickFile;

  const FilePickerBottomSheet({
    super.key,
    required this.onPickImage,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: 300,
          width: constraints.maxWidth,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onPickImage();
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, size: 40),
                      SizedBox(height: 8),
                      Center(child: Text('Photos')),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onPickFile();
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.file_open_outlined, size: 40),
                      SizedBox(height: 8),
                      Center(child: Text('Document')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
