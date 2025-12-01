import 'package:digitallab/features/home/data/models/image_data.dart';

double bytesToKB(int bytes) {
  return double.parse((bytes / 1024).toStringAsFixed(2));
}

double bytesToMB(int bytes) {
  return double.parse((bytes / (1024 * 1024)).toStringAsFixed(2));
}

double bytesToGB(int bytes) {
  return double.parse((bytes / (1024 * 1024 * 1024)).toStringAsFixed(2));
}

String convertToByteReadable(int bytes) {
  const kb = 1024;
  const mb = kb * 1024;
  const gb = mb * 1024;

  if (bytes < mb) {
    return '${bytesToKB(bytes)} KB';
  } else if (bytes < gb) {
    return '${bytesToMB(bytes)} MB';
  } else {
    return '${bytesToGB(bytes)} GB';
  }
}

ImageSizes convertToByteTypes(int bytes) {
  const kb = 1024;
  const mb = kb * 1024;
  const gb = mb * 1024;

  if (bytes < mb) {
    return ImageSizes.inKilobytes;
  } else if (bytes < gb) {
    return ImageSizes.inMegabytes;
  } else {
    return ImageSizes.inGigabytes;
  }
}

int convertSizeToBytes(double size, ImageSizes type) {
  const int kb = 1024;
  const int mb = kb * 1024;
  const int gb = mb * 1024;

  switch (type) {
    case ImageSizes.inKilobytes:
      print("kb rounding");
      return (size * kb).round();
    case ImageSizes.inMegabytes:
      print("megabyte rounding");
      return (size * mb).round();
    case ImageSizes.inGigabytes:
      return (size * gb).round();
  }
}
