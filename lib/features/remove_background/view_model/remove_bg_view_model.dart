import 'dart:io';

import 'dart:io';
import 'dart:ui' as ui;
import 'package:digitallab/features/home/data/models/image_data.dart';
import 'package:digitallab/utils/image_compression.dart';
import 'package:digitallab/utils/image_manipulation.dart';
import 'package:image/image.dart' as img;
import 'package:digitallab/utils/image_impl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_background_remover/image_background_remover.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';

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

// enum ImageSizes { inKilobytes, inMegabytes, inGigabytes }

class RemoveBackgroundViewModel extends ChangeNotifier {
  RemoveBackgroundViewModel()
    : imageManipulation = ImageManipulateData(
        imageByteType: ImageSizes.inKilobytes,
        imageSizeInByte: 0,
      );

  ImageManipulateData imageManipulation;
  BuildContext? context;
  ImageData? _currentImage;
  ImageData? _originalImage;
  int imageInPercentage = 0;

  final imageSizeTypesDropdown = [
    SizeType('kb', 'Kilobyte (KB)'),
    SizeType('mb', 'Megabyte (MB)'),
    SizeType('gb', 'Gigabyte (GB)'),
  ];

  final currentImageSizeType = [SizeType('kb', 'Kilobyte')];

  init(BuildContext newContext) {
    context = newContext;
    BackgroundRemover.instance.initializeOrt();
  }

  ReductionMode reductionMode = ReductionMode.defaultMode;

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  ImageData? get currentImage => _currentImage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> pickImage() async {
    reductionMode = ReductionMode.defaultMode;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;
        final path = platformFile.path;

        if (path != null && path.isNotEmpty) {
          final imageFile = File(path);
          final imageLength = await imageFile.length();

          _currentImage = ImageData(
            file: imageFile,
            fileSize: imageLength,
            path: path,
          );

          _originalImage = _currentImage;

          imageManipulation = ImageManipulateData(
            imageByteType: convertToByteTypes(imageLength),
          );
          if (kDebugMode) print("Image selected: $_currentImage");
        } else {
          _errorMessage = 'Picked file has no path (unsupported platform)';
          if (kDebugMode) print(_errorMessage);
        }
      }
    } catch (e) {
      _errorMessage = "Error picking image: $e";
      if (kDebugMode) print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear the currently selected image.
  void clearImage() {
    _currentImage = null;
    notifyListeners();
  }

  downloadImage() async {}

  Future<void> saveImageAs() async {
    try {
      final defaultFileName = path.basename(_originalImage!.file.path);
      final pngFileName =
          '${path.basenameWithoutExtension(defaultFileName)}.png';

      print(pngFileName);
      // Open save dialog
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Image As',
        fileName: pngFileName,
        type: FileType.custom,
        allowedExtensions: ['png'],
      );

      if (outputPath != null) {
        if (!outputPath.toLowerCase().endsWith('.png')) {
          outputPath = '$outputPath.png';
        }
        await _currentImage!.file.copy(outputPath);
        toastification.show(
          type: ToastificationType.success,
          title: Text('Successfully Saved Image'),
          autoCloseDuration: const Duration(seconds: 2),
        );

        return;
      } else {
        toastification.show(
          type: ToastificationType.success,
          title: Text('Unable to save image'),
          autoCloseDuration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print(e);
      toastification.show(
        type: ToastificationType.success,
        title: Text('$e'),
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }

  removeImageBackground() async {
    context!.loaderOverlay.show();
    _isLoading = true;
    notifyListeners();

    try {
      if (_originalImage == null) return;

      final fileName = path.basename(_originalImage!.file.path);
      final tempDir = await getTemporaryDirectory();

      final Uint8List imageByte = await _originalImage!.file.readAsBytes();

      ui.Image resultImage = await BackgroundRemover.instance.removeBg(
        imageByte,
      );
      final ByteData? byteData = await resultImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List imageBytes = byteData!.buffer.asUint8List();

      final tempFilePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final tempFile = File(tempFilePath);

      await tempFile.writeAsBytes(imageBytes);

      final newFileSize = await tempFile.length();
      _currentImage = ImageData(
        file: tempFile,
        fileSize: newFileSize,
        path: tempFile.path,
      );

      imageManipulation = ImageManipulateData(
        imageByteType: convertToByteTypes(newFileSize),
      );

      toastification.show(
        type: ToastificationType.success,
        title: const Text('Background Remove Successfully'),
        autoCloseDuration: Duration(seconds: 2),
      );

      if (kDebugMode) {
        print('Image removed: ${convertToByteReadable(newFileSize)}');
        print('Saved at: ${tempFile.path}');
      }
    } catch (e) {
      toastification.show(
        type: ToastificationType.error,
        title: const Text('Unable to remove background'),
        autoCloseDuration: Duration(seconds: 2),
      );
    } finally {
      print('done');
      _isLoading = false;
      context!.loaderOverlay.hide();
      notifyListeners();
    }
  }
}
