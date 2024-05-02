import 'dart:io';

import 'package:e_kantin/size_config.dart';
import 'package:e_kantin/view/components/rounded_button.dart';
import 'package:flutter/material.dart';

// Widget untuk mengunggah gambar dengan Card
class ImageUploadWidget extends StatelessWidget {
  final Function() onPickImage;
  final File? uploadedImage;

  const ImageUploadWidget({
    super.key,
    required this.onPickImage,
    required this.uploadedImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (uploadedImage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.file(
                uploadedImage!,
                width: getProportionateScreenWidth(200),
                height: getProportionateScreenWidth(200),
              ),
            ),
          RoundedButton(
            text: "Upload Payment Proof",
            press: onPickImage,
            width: SizeConfig.screenWidth * 0.9,
            border: 10,
            margin: 0,
          ),
        ],
      ),
    );
  }
}
