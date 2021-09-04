import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';

import 'constants.dart';

Widget getCommonErrorWidget() {
  return Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: Text(commonErrorMessage)));
}

Widget getCommonProgressWidget() {
  return Center(child: CircularProgressIndicator());
}

Widget getCommonAddAndPreviewImageWidget(Rx<XFile> imageFileRx) {
  var imagePath = imageFileRx.value.path;
  if (imagePath.isEmpty) {
    return _getImageSelectButton(imageFileRx);
  } else {
    return _getImagePreviewSection(imageFileRx);
  }
}

_getImageSelectButton(Rx<XFile> imageFileRx) {
  return TextButton(
      onPressed: () {
        _selectImage(imageFileRx);
      },
      child: Text('Tap to add image'));
}

_getImagePreviewSection(Rx<XFile> imageFileRx) {
  var imagePath = imageFileRx.value.path;
  return ListTile(
    leading: Hero(
      tag: 'hero-image',
      child: Image.file(File(imagePath)),
    ),
    onTap: () {
      Get.to(() => ImageFullScreenWidget(imagePath));
    },
    trailing: _getImageCloseButton(imageFileRx),
  );
}

_getImageCloseButton(Rx<XFile> imageFileRx) {
  return IconButton(
    icon: Icon(Icons.close, color: Colors.black),
    onPressed: () {
      imageFileRx.value = XFile("");
    },
  );
}

_selectImage(Rx<XFile> imageFileRx) async {
  final ImagePicker _picker = ImagePicker();
  // // Pick an image
  XFile? selectedImage = await _picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 500,
    maxHeight: 1000,
    imageQuality: 70,
  );
  if (selectedImage != null) {
    imageFileRx.value = selectedImage;
  }
  // // Capture a photo
  // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  // Pick multiple images
  // final List<XFile>? images = await _picker.pickMultiImage();
}

class ImageFullScreenWidget extends StatelessWidget {
  ImageFullScreenWidget(this.imagePath);

  String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Fullscreen'),
      ),
      body: Center(
        child: Hero(
          tag: 'hero-image',
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}

Widget getCommonExpandedButton(String title, VoidCallback onPressed) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        child: ElevatedButton(
          child: Text(title),
          onPressed: onPressed,
        ),
      ),
    ],
  );
}

Widget getCommonSaveAndCancelButtons(
  String saveTitle,
  VoidCallback saveAction,
  VoidCallback cancelAction,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        child: ElevatedButton(
          child: Text(saveTitle),
          onPressed: saveAction,
        ),
      ),
      Expanded(
        child: ElevatedButton(
          child: Text("Cancel"),
          onPressed: cancelAction,
        ),
      ),
    ],
  );
}
