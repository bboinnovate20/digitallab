import 'dart:io';

import 'package:digitallab/core/ui/custom_button.dart';
import 'package:digitallab/core/ui/primary_btn.dart';
import 'package:digitallab/core/ui/text_field.dart';
import 'package:digitallab/features/home/data/models/image_data.dart';
import 'package:digitallab/features/home/view_model/photolab_view_model.dart';
import 'package:digitallab/utils/image_manipulation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

class ImageOptimizer extends StatefulWidget {
  const ImageOptimizer({super.key});

  @override
  State<ImageOptimizer> createState() => _PassportLabState();
}

class _PassportLabState extends State<ImageOptimizer> {
  final PhotolabViewModel _photolabModel = PhotolabViewModel();
  final TextEditingController sizeInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _photolabModel.init(context);
  }

  @override
  void dispose() {
    _photolabModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Optimizer')),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _photolabModel,
                builder: (context, child) {
                  final file = _photolabModel.currentImage?.file;
                  if (file == null) return const SizedBox.shrink();

                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Text("Image Details"),
                        Text(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          "File Size ${convertToByteReadable(_photolabModel.currentImage!.fileSize)}",
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Image.file(
                            file,
                            // width: 260,
                            height: 400,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            AnimatedBuilder(
              animation: _photolabModel,
              builder: (context, child) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 3,
                  color: Colors.grey.shade200,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: AnimatedBuilder(
                            animation: _photolabModel,
                            builder: (context, child) {
                              return CustomButton(
                                color: Colors.black,
                                label: _photolabModel.currentImage == null
                                    ? 'Upload Passport'
                                    : 'Replace Passport',
                                onPressed: _photolabModel.isLoading
                                    ? null
                                    : _photolabModel.pickImage,
                                leading: const Icon(Icons.upload_file),
                                loading: _photolabModel.isLoading,
                              );
                            },
                          ),
                        ),

                        if (_photolabModel.currentImage != null) ...[
                          PrimaryButton(
                            label: "Reduce in Percentage",
                            onPressed: () => _photolabModel.changeReductionMode(
                              ReductionMode.percentage,
                            ),
                          ),

                          PrimaryButton(
                            label: "Reduce in Size",
                            onPressed: () => _photolabModel.changeReductionMode(
                              ReductionMode.sizes,
                            ),
                          ),
                        ],
                        if (_photolabModel.reductionMode ==
                            ReductionMode.percentage)
                          ListenableBuilder(
                            listenable: _photolabModel,
                            builder: (context, child) => Column(
                              children: [
                                Slider(
                                  value: _photolabModel
                                      .imageManipulation
                                      .imageQuality,
                                  onChanged: (v) {
                                    _photolabModel.changeImageQuality(v);
                                  },
                                ),
                                Text(
                                  (_photolabModel
                                              .imageManipulation
                                              .imageQuality *
                                          100)
                                      .toStringAsFixed(0),
                                ),
                              ],
                            ),
                          ),

                        if (_photolabModel.reductionMode == ReductionMode.sizes)
                          ListenableBuilder(
                            listenable: _photolabModel,
                            builder: (context, child) => SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  Text("Select File Size"),

                                  DropdownButtonFormField(
                                    initialValue: 'kb',
                                    items: _photolabModel.imageSizeTypesDropdown
                                        .map((sizeType) {
                                          return DropdownMenuItem(
                                            value: sizeType.value,
                                            child: Text(sizeType.label),
                                          );
                                        })
                                        .toList(),
                                    onChanged: (type) => {
                                      _photolabModel.changeImageFileSize(type!),
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  CustomTextInput(
                                    keyboardType: TextInputType.number,
                                    label: 'Input your Size',
                                    controller: sizeInputController,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        SizedBox(height: 100),
                        if (_photolabModel.reductionMode !=
                            ReductionMode.defaultMode) ...[
                          CustomButton(
                            color: Colors.blue,
                            label: "Reduce Image",
                            onPressed: () {
                              print(sizeInputController.text);
                              try {
                                _photolabModel.reduceImageSize();
                              } catch (e) {
                                print(e);
                                toastification.show(
                                  type: ToastificationType.error,
                                  title: const Text(
                                    'Select a valid number type',
                                  ),
                                  autoCloseDuration: Duration(seconds: 2),
                                );
                              }
                            },
                          ),
                          Container(height: 20),
                          CustomButton(
                            color: Colors.blue,
                            label: "Download Image",
                            onPressed: () => _photolabModel.saveImageAs(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
