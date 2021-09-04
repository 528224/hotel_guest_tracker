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
  final allottedRoomController = TextEditingController();
  final nameAndAddressController = TextEditingController();

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
    allottedRoomController.dispose();
    nameAndAddressController.dispose();
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

            var width = page.size.width;
            var height = page.size.height;

            var image0Data = await _readImageData('bhoomika_card.jpeg');
            page.graphics.drawImage(
                PdfBitmap(image0Data), Rect.fromLTWH(110, 0, 300, 160));

            var dateTime = DateTime.now();

            page.graphics.drawString('Date&Time: ${dateTime.toString()}',
                PdfStandardFont(PdfFontFamily.helvetica, 12),
                bounds: Rect.fromLTWH(width - 250, 180, 250, 30));

            page.graphics.drawString(
                'Allotted Room: ${allottedRoomController.value.text} \nName & Address: ${nameAndAddressController.value.text}',
                PdfStandardFont(PdfFontFamily.helvetica, 12),
                bounds: Rect.fromLTWH(0, 225, width, 150));

            page.graphics.drawString(
                'ID Proof Front:', PdfStandardFont(PdfFontFamily.helvetica, 12),
                bounds: Rect.fromLTWH(0, 325, 200, 25));
            var image1Data = await image1.value.readAsBytes();
            page.graphics.drawImage(
                PdfBitmap(image1Data), Rect.fromLTWH(0, 350, 250, 250));

            page.graphics.drawString(
                'ID Proof Back:', PdfStandardFont(PdfFontFamily.helvetica, 12),
                bounds: Rect.fromLTWH(300, 325, 200, 25));
            var image2Data = await image2.value.readAsBytes();
            page.graphics.drawImage(
                PdfBitmap(image2Data), Rect.fromLTWH(300, 350, 250, 250));

            page.graphics.drawString(
                'Sign: ___', PdfStandardFont(PdfFontFamily.helvetica, 12),
                bounds: Rect.fromLTWH(16, height - 150, 350, 50));

            page.graphics.drawString(
                'Date: ___', PdfStandardFont(PdfFontFamily.helvetica, 12),
                bounds: Rect.fromLTWH(width - 200, height - 150, 200, 50));

            List<int> bytes = document.save();
            document.dispose();

            saveAndLaunchFile(bytes, '${dateTime.toString()}.pdf');
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
