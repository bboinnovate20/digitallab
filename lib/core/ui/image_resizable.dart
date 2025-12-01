import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ResizableImageWidget extends StatefulWidget {
  final File file;
  final double maxWidth;
  final double maxHeight;

  const ResizableImageWidget({
    required this.file,
    this.maxWidth = 260,
    this.maxHeight = 400,
    super.key,
  });

  @override
  State<ResizableImageWidget> createState() => _ResizableImageWidgetState();
}

class _ResizableImageWidgetState extends State<ResizableImageWidget> {
  double? imageWidth;
  double? imageHeight;

  @override
  void initState() {
    super.initState();
    _getImageDimensions();
  }

  void _getImageDimensions() async {
    final data = await widget.file.readAsBytes();
    final decoded = await decodeImageFromList(data);

    // Calculate scaling factor to fit within maxWidth/maxHeight
    double scale = 1.0;
    if (decoded.width > widget.maxWidth || decoded.height > widget.maxHeight) {
      scale = (widget.maxWidth / decoded.width)
          .clamp(0.0, 1.0)
          .min(widget.maxHeight / decoded.height);
    }

    setState(() {
      imageWidth = decoded.width * scale;
      imageHeight = decoded.height * scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: imageWidth != null && imageHeight != null
          ? Image.file(
              widget.file,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.fill, // scales to the calculated width/height
            )
          : const SizedBox(
              width: 100,
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
