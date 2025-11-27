import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class CameraDelegate extends ImagePickerCameraDelegate {
  CameraDelegate(this.pickFunc);

  Function(CameraDevice) pickFunc;

  @override
  Future<XFile?> takePhoto({
    ImagePickerCameraDelegateOptions options =
        const ImagePickerCameraDelegateOptions(),
  }) async {
    return pickFunc(options.preferredCameraDevice);
  }

  @override
  Future<XFile?> takeVideo({
    ImagePickerCameraDelegateOptions options =
        const ImagePickerCameraDelegateOptions(),
  }) {
    // TODO: implement takeVideo
    throw UnimplementedError();
  }
}
