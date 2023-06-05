import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:staff/screen/home/controller/add_new_item_controller.dart';
import 'package:staff/screen/home/controller/add_new_party_controller.dart';

import '../../constants/app_color.dart';
import '../../custom_textfield.dart';
import 'controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await showDialog(
        context: context,
        builder: (c) => AlertDialog(
          key: key,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share 2 file before closing',
                style: kBodyText3Style().copyWith(color: blackColor),
              ),
              const SizedBox(height: 14.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: purpleColor),
                  onPressed: () async {
                    Directory appDocumentsDirectory =
                        (await getExternalStorageDirectory())!;
                    Get.find<AddNewpartyController>()
                        .share('${appDocumentsDirectory.path}/newParty.xlsx');
                  },
                  child: const Text('Export Account'),
                ),
              ),
              const SizedBox(height: 4.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: purpleColor),
                  onPressed: () async {
                    Directory appDocumentsDirectory =
                        (await getExternalStorageDirectory())!;
                    Get.find<AddNewItemCOntroller>()
                        .share('${appDocumentsDirectory.path}/newItem.xlsx');
                  },
                  child: const Text('Export Item'),
                ),
              ),
              const SizedBox(height: 14.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteColor,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () async {
                    Directory appDocumentsDirectory =
                        (await getExternalStorageDirectory())!;
                    Get.find<AddNewItemCOntroller>().deleteExcelFile(
                        '${appDocumentsDirectory.path}/newItem.xlsx');
                    Get.find<AddNewpartyController>().deleteExcelFile(
                        '${appDocumentsDirectory.path}/newParty.xlsx');
                    SystemNavigator.pop();
                  },
                  child: const Text(
                    'Shared All ??',
                    style: TextStyle(color: blackColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: () {
                  controller.share();
                  // Get.to(() => const NewPartyScreen());
                },
                icon: const Icon(
                  Icons.share,
                  color: purpleColor,
                ),
              ),
            ),
          ],
          elevation: 0,
          backgroundColor: whiteColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Staff',
              style: kTitleTextStyle(18, FontWeight.w700)
                  .copyWith(color: purpleColor)),
        ),
        body: Obx(
          () => controller.isFetching.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Obx(
                          () => Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: purpleColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () => controller
                                      .selectDate(context)
                                      .then((value) {
                                    if (value != null) {
                                      staffPrint(value);
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(value);
                                      controller.billIssueDetails.value =
                                          formattedDate;
                                    }
                                  }),
                                  child: Text(
                                    controller.billIssueDetails.value
                                        .toString(),
                                    style: kTitleTextStyle(14, FontWeight.bold)
                                        .copyWith(color: whiteColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: controller.height),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SearchField(
                                suggestionStyle:
                                    kTitleTextStyle(12, FontWeight.w600)
                                        .copyWith(color: purpleColor),
                                searchInputDecoration: InputDecoration(
                                  hintStyle: kBodyText3Style()
                                      .copyWith(color: purpleColor),
                                  labelStyle: kElevatedButtonTextStyle()
                                      .copyWith(color: purpleColor),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                    borderSide: BorderSide(color: purpleColor),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                    borderSide: BorderSide(color: purpleColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                    borderSide: BorderSide(
                                      color: purpleColor,
                                    ),
                                  ),
                                ),
                                focusNode: FocusNode(),
                                suggestions: controller.partyNameList
                                    .map((name) =>
                                        SearchFieldListItem(name, item: name))
                                    .toList(),
                                // hasOverlay: true,
                                controller: controller.partyName,
                                hint: 'Type Party Name.',
                                searchStyle: kBodyText4Style()
                                    .copyWith(color: purpleColor, fontSize: 15),
                                maxSuggestionsInViewPort: 4,
                                itemHeight: 45,
                                inputType: TextInputType.text,
                                onSuggestionTap: (p0) {
                                  // controller.changeItemNameValue(p0.item);
                                  controller.isEnabled.value = true;
                                  staffPrint(p0);
                                },
                              ),
                              const SizedBox(height: 15),
                              StaffFormField(
                                labelText: 'Invoice No.',
                                hintText: 'e.g ABC1245',
                                borderColor: Colors.purple,
                                cursorColor: Colors.lightBlueAccent,
                                hintColor: greyColor,
                                isObscureText: false,
                                controller: controller.invoiceNo,
                              ),
                              SizedBox(height: controller.height),
                              Obx(
                                () => Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: purpleColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: GestureDetector(
                                        onTap: () => controller
                                            .selectDate(context)
                                            .then((value) {
                                          if (value != null) {
                                            staffPrint(value);
                                            String formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(value);
                                            controller.changeInvoiceText(
                                                formattedDate);
                                          }
                                        }),
                                        child: Text(
                                          controller.invoiceDate.value
                                              .toString(),
                                          style: kTitleTextStyle(
                                                  14, FontWeight.bold)
                                              .copyWith(color: whiteColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: controller.height),
                              SearchField(
                                suggestionStyle:
                                    kTitleTextStyle(12, FontWeight.w600)
                                        .copyWith(color: purpleColor),
                                searchInputDecoration: InputDecoration(
                                  hintStyle: kBodyText3Style()
                                      .copyWith(color: purpleColor),
                                  labelStyle: kElevatedButtonTextStyle()
                                      .copyWith(color: purpleColor),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                    borderSide: BorderSide(color: purpleColor),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                    borderSide: BorderSide(color: purpleColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                    borderSide: BorderSide(
                                      color: purpleColor,
                                    ),
                                  ),
                                ),
                                focusNode: FocusNode(),
                                suggestions: controller.partNumberList
                                    .map((partyNum) => SearchFieldListItem(
                                        partyNum,
                                        item: partyNum))
                                    .toList(),
                                suggestionState: Suggestion.hidden,
                                //hasOverlay: true,
                                controller: controller.partNo,
                                hint: 'Type Part No.',
                                searchStyle: kBodyText4Style()
                                    .copyWith(color: purpleColor, fontSize: 15),
                                maxSuggestionsInViewPort: 4,
                                itemHeight: 45,
                                inputType: TextInputType.text,
                                onSuggestionTap: (p0) {
                                  staffPrint(p0);
                                },
                              ),
                              SizedBox(height: controller.height),
                              // Obx(
                              //   () => StaffFormField(
                              //     enabled: !controller.isEnabled.value,
                              //     contentColor: purpleColor,
                              //     labelText: 'Item name',
                              //     hintText: 'Ex: tyre',
                              //     borderColor: Colors.purple,
                              //     cursorColor: Colors.lightBlueAccent,
                              //     hintColor: greyColor,
                              //     isObscureText: false,
                              //     controller: controller.itemName,
                              //   ),
                              // ),
                              StaffFormField(
                                type: TextInputType.number,
                                labelText: 'Freight Charge',
                                hintText: 'Ex: tyre',
                                borderColor: Colors.purple,
                                cursorColor: Colors.lightBlueAccent,
                                hintColor: greyColor,
                                isObscureText: false,
                                controller: controller.freightCharge,
                              ),
                              SizedBox(height: controller.height),
                              Row(
                                children: [
                                  Expanded(
                                    child: StaffFormField(
                                      type: TextInputType.number,
                                      labelText: 'MRP',
                                      hintText: 'Ex: 50',
                                      borderColor: Colors.purple,
                                      cursorColor: Colors.lightBlueAccent,
                                      hintColor: greyColor,
                                      isObscureText: false,
                                      controller: controller.mrp,
                                    ),
                                  ),
                                  SizedBox(width: controller.height),
                                  Expanded(
                                    child: StaffFormField(
                                      type: TextInputType.number,
                                      labelText: 'Qty',
                                      hintText: 'Ex: 52',
                                      borderColor: Colors.purple,
                                      cursorColor: Colors.lightBlueAccent,
                                      hintColor: greyColor,
                                      isObscureText: false,
                                      controller: controller.qty,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: controller.height),
                              Row(
                                children: [
                                  Expanded(
                                    child: StaffFormField(
                                      type: TextInputType.number,
                                      labelText: 'Total Amount',
                                      hintText: 'Ex: 580',
                                      borderColor: Colors.purple,
                                      cursorColor: Colors.lightBlueAccent,
                                      hintColor: greyColor,
                                      isObscureText: false,
                                      controller: controller.totalAmount,
                                    ),
                                  ),
                                  SizedBox(width: controller.height),
                                  Obx(
                                    () => Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            border:
                                                Border.all(color: purpleColor)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            iconEnabledColor: purpleColor,
                                            isExpanded: true,
                                            // Step 3.
                                            value: controller.gstTypeText.value,
                                            // Step 4.
                                            items: controller.gstTypeRate
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 8),
                                                  child: Text(
                                                    value,
                                                    style: kBodyText3Style()
                                                        .copyWith(
                                                            color: purpleColor),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            // Step 5.
                                            onChanged: (newValue) {
                                              controller
                                                  .changeGstTypeText(newValue);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: controller.height),
                              Row(
                                children: [
                                  Obx(
                                    () => Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            border:
                                                Border.all(color: purpleColor)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            iconEnabledColor: purpleColor,
                                            isExpanded: true,
                                            // Step 3.
                                            value:
                                                controller.gstSelectrate.value,
                                            // Step 4.
                                            items: controller.gstRate
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 8),
                                                  child: Text(
                                                    "$value %",
                                                    style: kBodyText3Style()
                                                        .copyWith(
                                                            color: purpleColor),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            // Step 5.
                                            onChanged: controller
                                                        .gstTypeText.value ==
                                                    "Exempt"
                                                ? null
                                                : (newValue) {
                                                    controller.changeGstText(
                                                        newValue);
                                                  },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      backgroundColor: purpleColor),
                                  onPressed: () {
                                    controller.calculateDiscount();
                                    //Get.to(() => const NewPartyScreen());
                                    //Get.forceAppUpdate();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      'Get Discount',
                                      style:
                                          kTitleTextStyle(14, FontWeight.bold)
                                              .copyWith(color: whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
