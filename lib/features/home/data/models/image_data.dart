import 'dart:io';
import 'dart:typed_data';

enum ImageSizes { inKilobytes, inMegabytes, inGigabytes }

enum ReductionMode { percentage, sizes, defaultMode }

class CompressionParams {
  final Uint8List imageBytes; // Changed from ImageData
  final String imagePath; // Keep path as reference
  final int targetBytes;

  CompressionParams({
    required this.imageBytes,
    required this.imagePath,
    required this.targetBytes,
  });
}

class ImageData {
  File file;
  int fileSize;
  String path;
  ImageData({required this.file, required this.fileSize, this.path = ""});
}

class ImageManipulateData {
  ImageSizes imageByteType;
  int? imageSizeInByte;
  double imageQuality;
  ImageManipulateData({
    required this.imageByteType,
    this.imageSizeInByte,
    this.imageQuality = 1,
  });
}

class SizeType {
  final String value;
  final String label;

  SizeType(this.value, this.label);
}
