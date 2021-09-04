import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'commonWidgets.dart';
import 'createPdfControlller.dart';

class CreatePDFWidget extends StatelessWidget {
  CreatePDFWidget({Key? key}) : super(key: key);
  CreatePDFController controller = Get.put(CreatePDFController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate PDF')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.requestFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: controller.validator,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 100,
                ),
                TextFormField(
                  controller: controller.addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: controller.validator,
                  minLines: 1,
                  maxLines: 10,
                  maxLength: 500,
                ),
                _getAddAndPreviewImage1Widget(),
                _getAddAndPreviewImage2Widget(),
                getCommonSaveAndCancelButtons(
                  "Create PDF",
                  controller.generatePdfAction,
                  controller.clearAction,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getAddAndPreviewImage1Widget() {
    return Obx(() {
      return getCommonAddAndPreviewImageWidget(controller.image1);
    });
  }

  _getAddAndPreviewImage2Widget() {
    return Obx(() {
      return getCommonAddAndPreviewImageWidget(controller.image2);
    });
  }
}
