import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'commonWidgets.dart';
import 'mobile.dart';

class CreatePDFController extends GetxController {
  final requestFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();

  var isLoading = false;

  var image1 = XFile("").obs;
  var image2 = XFile("").obs;

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    // titleController.text = 'title';
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    image1.close();
    image2.close();
    super.onClose();
  }

  String? validator(String? value) {
    bool isNullOrBlank = value?.isBlank ?? true;
    if (isNullOrBlank) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void clearAction() {
//TODO
  }

  Future<void> generatePdfAction() async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          if (requestFormKey.currentState!.validate()) {
            var image1Path = image1.value.path;
            var image2Path = image2.value.path;
            if (image1Path.isEmpty || image2Path.isEmpty) {
              Get.snackbar('Add Image', 'Please add both images');
              return;
            }

            PdfDocument document = PdfDocument();
            final page = document.pages.add();

            page.graphics.drawString(
                'Name: ${nameController.value.text} \nAddress: ${addressController.value.text}',
                PdfStandardFont(PdfFontFamily.helvetica, 30));

            var image1Data = await image1.value.readAsBytes();
            page.graphics.drawImage(
                PdfBitmap(image1Data), Rect.fromLTWH(0, 150, 250, 250));

            // var image2Data = await _readImageData(image2.value.path);
            var image2Data = await image2.value.readAsBytes();
            page.graphics.drawImage(
                PdfBitmap(image2Data), Rect.fromLTWH(0, 410, 300, 300));

            List<int> bytes = document.save();
            document.dispose();

            saveAndLaunchFile(bytes, '${nameController.value.text}.pdf');
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }

  _createPDF() {}

  Future<Uint8List> _readImageData(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
