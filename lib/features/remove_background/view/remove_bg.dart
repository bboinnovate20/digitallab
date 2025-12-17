import 'dart:io';

import 'package:digitallab/core/ui/custom_button.dart';
import 'package:digitallab/core/ui/primary_btn.dart';

import 'package:digitallab/features/home/data/models/image_data.dart';

import 'package:digitallab/features/remove_background/view_model/remove_bg_view_model.dart';
import 'package:digitallab/utils/image_manipulation.dart';
import 'package:flutter/material.dart';
import 'package:image_background_remover/image_background_remover.dart';

class RemoveBackground extends StatefulWidget {
  const RemoveBackground({super.key});

  @override
  State<RemoveBackground> createState() => _PassportLabState();
}

class _PassportLabState extends State<RemoveBackground> {
  final RemoveBackgroundViewModel _photolabModel = RemoveBackgroundViewModel();
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
      appBar: AppBar(title: const Text('Image Background Remover')),
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
                                    ? 'Upload Image'
                                    : 'Replace Image',
                                onPressed: _photolabModel.isLoading
                                    ? null
                                    : _photolabModel.pickImage,
                                leading: const Icon(Icons.upload_file),
                                loading: _photolabModel.isLoading,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 50),
                        if (_photolabModel.currentImage != null) ...[
                          PrimaryButton(
                            label: "Remove Image Background",
                            onPressed: () =>
                                _photolabModel.removeImageBackground(),
                          ),
                          SizedBox(height: 50),
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
