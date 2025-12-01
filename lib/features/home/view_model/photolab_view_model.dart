import 'dart:io';

import 'dart:io';
import 'package:digitallab/features/home/data/models/image_data.dart';
import 'package:digitallab/utils/image_compression.dart';
import 'package:digitallab/utils/image_manipulation.dart';
import 'package:image/image.dart' as img;
import 'package:digitallab/utils/image_impl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class PhotolabViewModel extends ChangeNotifier {
  PhotolabViewModel()
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

  Future<Uint8List?> compressImageInPercentage(
    ImageData image,
    int percentage,
  ) async {
    _isLoading = true;

    Uint8List? result;

    try {
      final Uint8List imageByte = await image.file.readAsBytes();

      img.Image? decodedByteImage = img.decodeImage(imageByte);
      if (decodedByteImage != null) {
        result = compressImage(decodedByteImage, image.path, percentage);
      }
      print(convertToByteReadable(result!.length));
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      return null;
    }
  }

  static int calculate(int num) {
    return num;
  }

  changeImageQuality(double quality) {
    imageManipulation.imageQuality = quality;
    notifyListeners();
  }

  changeImageFileSize(String type) {
    imageManipulation.imageByteType = switch (type) {
      'kb' => ImageSizes.inKilobytes,
      'mb' => ImageSizes.inMegabytes,
      'gb' => ImageSizes.inGigabytes,
      _ => throw Exception("Invalid size type"),
    };
    notifyListeners();
  }

  changeReductionMode(ReductionMode mode) {
    imageManipulation.imageQuality = 0;
    imageManipulation.imageByteType = ImageSizes.inKilobytes;
    reductionMode = mode;
    notifyListeners();
  }

  Future<void> reduceImageSize({double? targetSize}) async {
    context!.loaderOverlay.show();
    _isLoading = true;
    notifyListeners();

    try {
      if (_originalImage == null) return;

      if (reductionMode == ReductionMode.percentage) {
        await handlePercentageReduction();
      }

      if (reductionMode == ReductionMode.sizes && targetSize != null) {
        print("image Size $targetSize");
        print("image Type ${imageManipulation.imageByteType}");
        await handleSizeReduction(targetSize);
      }
    } catch (e) {}

    _isLoading = false;
    notifyListeners();
    context!.loaderOverlay.hide();
  }

  Future<void> handlePercentageReduction() async {
    if (_originalImage == null) return;

    final fileName = path.basename(_originalImage!.file.path);
    final tempDir = await getTemporaryDirectory();

    final quality = (imageManipulation.imageQuality * 100).toInt();

    final compressedBytes = await compressImageInPercentage(
      _originalImage!,
      quality,
    );

    if (compressedBytes == null || compressedBytes.isEmpty) {
      _errorMessage = 'Compression failed: returned empty bytes';
      if (kDebugMode) print(_errorMessage);
      return;
    }
    final tempFilePath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final tempFile = File(tempFilePath);

    await tempFile.writeAsBytes(compressedBytes);

    final newFileSize = await tempFile.length();
    _currentImage = ImageData(
      file: tempFile,
      fileSize: newFileSize,
      path: tempFile.path,
    );

    imageManipulation = ImageManipulateData(
      imageByteType: convertToByteTypes(newFileSize),
      imageQuality: imageManipulation.imageQuality,
    );

    toastification.show(
      type: ToastificationType.success,
      title: const Text('Successfully compressed image'),
      autoCloseDuration: Duration(seconds: 2),
    );

    if (kDebugMode) {
      print('Image compressed: ${convertToByteReadable(newFileSize)}');
      print('Saved at: ${tempFile.path}');
      print(convertToByteReadable(_currentImage!.fileSize));
    }

    notifyListeners();
  }

  static Uint8List? _compressionWorker(CompressionParams paramSize) {
    try {
      final Uint8List originalBytes = paramSize.imageBytes;

      if (originalBytes.length <= paramSize.targetBytes) {
        return originalBytes;
      }

      img.Image? decoded = img.decodeImage(originalBytes);
      if (decoded == null) return null;

      img.Image currentImage = decoded;
      Uint8List? successfulResult;

      while (successfulResult == null) {
        print("working on the size");
        print('-------------------------------------------');
        print(
          'Resolution Attempt: ${currentImage.width}x${currentImage.height}',
        );
        print('-------------------------------------------');
        successfulResult = binarySearchQuality(
          currentImage,
          paramSize.imagePath,
          paramSize.targetBytes,
        );

        if (successfulResult == null) {
          if (currentImage.width < 50 || currentImage.height < 50) {
            break;
          }

          currentImage = img.copyResize(
            currentImage,
            width: (currentImage.width * 0.8).round(),
            height: (currentImage.height * 0.8).round(),
            interpolation: img.Interpolation.linear,
          );
        }
      }

      return successfulResult;
    } catch (_) {
      return null;
    }
  }

  Future<void> handleSizeReduction(double targetSize) async {
    try {
      if (_originalImage == null) return;

      final fileName = path.basename(_originalImage!.file.path);
      final tempDir = await getTemporaryDirectory();

      final int getImageSizeInByte = convertSizeToBytes(
        targetSize,
        imageManipulation.imageByteType,
      );

      final imageBytes = await _originalImage!.file.readAsBytes();

      final infoData = CompressionParams(
        imageBytes: imageBytes,
        imagePath: _originalImage!.file.path,
        targetBytes: getImageSizeInByte,
      );

      final compressedBytes = await compute(_compressionWorker, infoData);
      // print("compresseed new $compressedBytes");
      // print("here $fileName ${_originalImage!}");

      if (compressedBytes == null || compressedBytes.isEmpty) {
        return;
      }
      final tempFilePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final tempFile = File(tempFilePath);

      await tempFile.writeAsBytes(compressedBytes);

      final newFileSize = await tempFile.length();
      _currentImage = ImageData(
        file: tempFile,
        fileSize: newFileSize,
        path: tempFile.path,
      );

      // imageManipulation = ImageManipulateData(
      //   imageByteType: imageManipulation.imageByteType,
      //   imageQuality: imageManipulation.imageQuality,
      // );

      toastification.show(
        type: ToastificationType.success,
        title: const Text('Successfully compressed image'),
        autoCloseDuration: Duration(seconds: 2),
      );

      if (kDebugMode) {
        print('Image compressed: ${convertToByteReadable(newFileSize)}');
        print('Saved at: ${tempFile.path}');
        print(convertToByteReadable(_currentImage!.fileSize));
      }
    } catch (e) {
      print("$e image error");
    }

    notifyListeners();
  }

  downloadImage() async {}

  Future<void> saveImageAs() async {
    try {
      final defaultFileName = path.basename(_originalImage!.file.path);
      // Open save dialog
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Image As',
        fileName: defaultFileName,
        type: FileType.image,
      );

      if (outputPath != null) {
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
}
