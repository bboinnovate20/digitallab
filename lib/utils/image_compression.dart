import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

Uint8List? binarySearchQuality(
  img.Image imgToCompress,
  String path,
  int targetBytes,
) {
  int minQ = 0;
  int maxQ = 100;
  Uint8List? bestBytes;

  while (minQ <= maxQ) {
    int currentQ = (minQ + maxQ) ~/ 2;

    Uint8List compressed = compressImage(imgToCompress, path, currentQ);

    if (compressed.length <= targetBytes) {
      bestBytes = compressed;
      minQ = currentQ + 1;
    } else {
      maxQ = currentQ - 1;
    }
  }

  return bestBytes;
}

Uint8List compressImage(img.Image image, String imagePath, int quality) {
  // Determine output format based on original file extension
  String extension = path.extension(imagePath).toLowerCase();

  if (extension == '.png') {
    return Uint8List.fromList(
      img.encodePng(image, level: _qualityToPngLevel(quality)),
    );
  } else {
    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }
}

int _qualityToPngLevel(int quality) {
  return ((100 - quality) / 11).round().clamp(0, 9);
}
