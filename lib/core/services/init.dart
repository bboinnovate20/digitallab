import 'package:python_ffi/python_ffi.dart';

class PythonImpl {
  PythonImpl();

  init() async {
    await PythonFfi.instance.initialize();
  }
}
