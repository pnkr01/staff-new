import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart'
    show ByteData, SystemChannels, SystemNavigator, rootBundle;
import 'package:staff/screen/home/controller/add_new_item_controller.dart';
import 'package:staff/screen/home/controller/add_new_party_controller.dart';

import '../../../constants/app_color.dart';
import '../../../utils/errordialog.dart';
import '../../newItem/new_item.dart';
import '../../newParty/new_party.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    loadAssetFromDevice();
    super.onInit();
  }

  final DateTime _selectedDate = DateTime.now();

  late double completeResult;
  late HashMap<String, List<String>> map = HashMap();
  RxString itemNameText = 'Item Name'.obs;
  //late Excel excel;
  late Excel excel1;
  late Excel excel2;
  int i = 0;
  RxBool isFetching = true.obs;

  late Directory output;
  late Directory outputParty;
  late Directory resultParty;
  File? assetFile;
  File? myFile;
  File? myPartyFile;
  File? myPartyAssetFile;
  var partyNameList = [].obs;

  //------------------Helper func--------------------//

  String get getBillSeries => gstTypeText.value == 'Exempt' ? 'MAIN' : 'GST';
  String get getBillDate => invoiceDate.value;
  String get getPurcType =>
      gstTypeText.value == 'Exempt' ? 'Exempt' : 'GST(INCL)';
  String get getPartyName => partyName.text;
  String get getITCEligibility =>
      gstTypeText.value == 'Exempt' ? 'None' : 'Goods/Services';
  String get getNarrationText => invoiceNo.text;
  String get getItemName => partNo.text;
  num get getQty => num.tryParse(qty.text) ?? 0;
  String get getUnit => map[partNo.text]?[1] ?? "Pcs";
  num get getPrice => num.tryParse(mrp.text) ?? 0;
  num get getDisc => num.tryParse(completeResult.toStringAsFixed(2)) ?? 0;
  num get getAmount => ((getPrice -
          ((getPrice * num.tryParse(completeResult.toString())!) / 100)) *
      getQty);
  //------------End----------------------------------
  RegExp regExp = RegExp(r'[^\w\s]', multiLine: true, caseSensitive: false);

  Future<File> copyAsset(String assetName) async {
    // Get the device's local storage directory
    output = (await getExternalStorageDirectory())!;

    // Get a handle to the asset file
    ByteData data = await rootBundle.load("assets/csv/$assetName");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write the asset file to the device's local storage
    String filePath = '${output.path}/$assetName';
    if (!await output.exists()) {
      staffPrint('creating dire');
      await output.create(recursive: true);
    }
    // ignore: prefer_typing_uninitialized_variables
    var file;
    staffPrint(await output.exists());
    if (await output.exists()) {
      file = await File(filePath).writeAsBytes(bytes);
    }
    return file;
  }

  Future<bool> checkFileExists() async {
    output = (await getExternalStorageDirectory())!;
    var filePath = '${output.path}/sample.xlsx';
    myFile = File(filePath);
    if (myFile!.existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkPartyExcelFileExists() async {
    output = (await getExternalStorageDirectory())!;
    var filePath =
        '${output.path}/${partyName.text.replaceAll(regExp, '')}.xlsx';
    myFile = File(filePath);
    if (myFile!.existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  Future loadAssetFromDevice() async {
    staffPrint('loading');
    // ignore: unnecessary_null_comparison
    if (await requestStoragePermission()) {
      staffPrint('inside permission');
      if (!await checkFileExists()) {
        staffPrint('saving to device');
        assetFile = await copyAsset('sample.xlsx');
        staffPrint(assetFile!.path.toString());
        var bytes = assetFile?.readAsBytesSync();
        excel1 = Excel.decodeBytes(bytes!);
        await saveToSearchField();
      } else if (assetFile?.path == null) {
        staffPrint('asset is null using myfile');
        var bytes = myFile?.readAsBytesSync();
        excel1 = Excel.decodeBytes(bytes!);
        await saveToSearchField();
      }
    } else {
      loadAssetFromDevice();
    }
  }

  Future<bool> checkPartynameFileExists() async {
    outputParty = (await getExternalStorageDirectory())!;
    var filePath = '${outputParty.path}/accounts.xlsx';
    myPartyFile = File(filePath);
    if (myPartyFile!.existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  Future<File> copyPartyAsset(String assetName) async {
    // Get the device's local storage directory
    output = (await getExternalStorageDirectory())!;

    // Get a handle to the asset file
    ByteData data = await rootBundle.load("assets/csv/$assetName");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write the asset file to the device's local storage
    String filePath = '${outputParty.path}/$assetName';
    if (!await output.exists()) {
      staffPrint('creating dire');
      await output.create(recursive: true);
    }
    // ignore: prefer_typing_uninitialized_variables
    var file;
    staffPrint(await output.exists());
    if (await output.exists()) {
      file = await File(filePath).writeAsBytes(bytes);
    }
    return file;
  }

  loadPartyNameAsset() async {
    if (await requestStoragePermission()) {
      staffPrint('inside permission');
      if (!await checkPartynameFileExists()) {
        staffPrint('saving to device');
        myPartyAssetFile = await copyPartyAsset('accounts.xlsx');
        staffPrint(myPartyAssetFile!.path.toString());
        var bytes = myPartyAssetFile?.readAsBytesSync();
        excel2 = Excel.decodeBytes(bytes!);
        await savePartyNameToSearchField();
      } else if (assetFile?.path == null) {
        staffPrint('asset is null using myfile');
        var bytes = myPartyFile?.readAsBytesSync();
        excel2 = Excel.decodeBytes(bytes!);
        await savePartyNameToSearchField();
      }
    } else {
      loadPartyNameAsset();
    }
  }

  share() {
    Share.shareFiles(['${output.path}/sample.xlsx'], text: 'Updated Sheet');
  }

  Future shareParty() async {
    Share.shareFiles(
        ['${outputParty.path}/${partyName.text.replaceAll(regExp, '')}.xlsx'],
        text: '${partyName.text} Sheet');
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // Ask for permission
      await Permission.storage.request();
      return false;
    } else {
      return true;
    }
  }

  Future updatePartySheet(String parentGroup) async {
    //if (!partyNameList.contains(partyName.text)) {
    var sheet = excel2['Sheet1'];
    sheet.appendRow([partyName.text, parentGroup]);

    // Writing the modified Excel file back to disk
    var outputFile = File('${outputParty.path}/accounts.xlsx');
    outputFile.writeAsBytesSync(excel2.encode()!);
    staffPrint('refreshing... partynamelist');
    partNumberList.add(partyName.text);
    partNumberList.refresh();
    partNumberList.refresh();
  }

  updatePartNumberSheet(String itemName, String alias, String location,
      String parentGroup, String unit) async {
    //adding part number in the list--->
    //Send to New screen to add partNo

    var sheet = excel1['Sheet1'];
    sheet.appendRow([
      '${partNo.text}-$itemName',
      alias,
      location,
      parentGroup,
      unit,
    ]);

    // Writing the modified Excel file back to disk
    var outputFile = File('${output.path}/sample.xlsx');
    outputFile.writeAsBytesSync(excel1.encode()!);
    staffPrint('refreshing...');
    partNumberList.add(partNo.text);
    partNumberList.refresh();
    partNumberList.refresh();
    //updatePartNumberSheet();
  }

  saveToSearchField() {
    partNumberList.isNotEmpty ? partNumberList.clear() : null;
    int j = 0;
    for (var table in excel1.tables.keys) {
      for (var row in excel1.tables[table]!.rows) {
        ++j;
        if (j >= 2) {
          if (row[0]?.value != null) {
            map[row[0]!.value.toString()] = [
              row[2]?.value.toString() ?? "",
              row[4]?.value.toString() ?? ""
            ];
          }
        }
      }
    }

    map.forEach((k, v) => partNumberList.add(k.toString()));
    staffPrint('refreshing completed...');
    showSnackBar('Sheet Synced', purpleColor, whiteColor);
    staffPrint('refreshing list...');
    partNumberList.refresh();
    staffPrint('refreshing list. compltede..');
    loadPartyNameAsset();
  }

  savePartyNameToSearchField() {
    partyNameList.isNotEmpty ? partyNameList.clear() : null;
    i = 0;
    for (var table in excel2.tables.keys) {
      // staffPrint(table);
      // staffPrint(excel.tables[table]?.maxCols);
      // staffPrint(excel.tables[table]?.rows.length);
      for (var row in excel2.tables[table]!.rows) {
        ++i;
        if (i >= 2) {
          if (row[0]?.value != null) {
            partyNameList.add(row[0]?.value.toString());
          }
        }
      }
      //  staffPrint('list of party name is $partyNameList');
    }
    partyNameList.refresh();

    isFetching.value = false;
  }

  // changeItemNameValue(newVal) {
  //   if (map.containsKey(newVal)) {
  //     final String mapValue = map[newVal]!;
  //     itemName.text = mapValue;
  //   }
  // }

  var partNumberList = [].obs;

  Rx<String> invoiceDate = 'Select Invoice Date'.obs;
  Rx<String> billIssueDetails = 'Select Bill Issue Date'.obs;
  //Rx<DateTime?> invoiceDateText = DateTime.now().obs;
  changeInvoiceText(newVal) => invoiceDate.value = newVal;
  double height = 15;
  RxBool isEnabled = true.obs;
  RxString gstSelectrate = 'GST'.obs;
  changeGstText(newVal) => gstSelectrate.value = newVal;
  List<String> gstRate = ['GST', '5', '12', '18', '28'];

  //-------------GST TYPE---------------------------------------//
  RxString gstTypeText = 'GST'.obs;
  changeGstTypeText(newVal) {
    gstTypeText.value = newVal;
    if (gstTypeText.value == "Exempt") {
      changeGstText('GST');
    }
  }

  List<String> gstTypeRate = ['GST', 'Inclusive', 'Exclusive', 'Exempt'];

  //-------------GST TYPE---------------------------------------//

  RxString getDiscountText = 'Get Discount'.obs;
  TextEditingController partyName = TextEditingController();
  TextEditingController invoiceNo = TextEditingController();
  TextEditingController partNo = TextEditingController();
  TextEditingController mrp = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController totalAmount = TextEditingController();
  TextEditingController freightCharge = TextEditingController();

  clearThisField() {
    partyName.clear();
    invoiceNo.clear();
    partNo.clear();
    mrp.clear();
    qty.clear();
    totalAmount.clear();
    freightCharge.clear();
    changeGstTypeText('GST');
    changeGstText('GST');
    staffPrint('cleared');
    itemNameText.value = 'Item Name';
    isEnabled.value = true;
    Get.until((route) => route.isFirst);
  }

  userWantsToInsertNewItemToExisting() {
    partNo.clear();
    mrp.clear();
    qty.clear();
    totalAmount.clear();
    freightCharge.clear();
    //  changeGstTypeText('GST type');
    changeGstText('GST');
    staffPrint('cleared');
    itemNameText.value = 'Item Name';
    isEnabled.value = true;
    Get.until((route) => route.isFirst);
  }

  findExclusivDiscount() {
    staffPrint("${gstSelectrate.value} is gst value exclusive");
    // final val = double.tryParse(gstSelectrate.value)! / 100;
    // final minusAmt = (double.tryParse(totalAmount.value.text)! + val) /
    //     double.tryParse(qty.value.text)!;
    // final halfResult = (double.tryParse(mrp.value.text)! - minusAmt) /
    //     (double.tryParse(mrp.value.text))!;
    // completeResult = halfResult * 100;

    final val = (double.tryParse(totalAmount.text)! *
            double.tryParse(gstSelectrate.value)!) /
        100;
    final minusAmt =
        (double.tryParse(totalAmount.text)! + val) / double.tryParse(qty.text)!;
    final halfResult =
        (double.tryParse(mrp.text)! - minusAmt) / (double.tryParse(mrp.text))!;
    completeResult = halfResult * 100;
    final result = completeResult.toStringAsFixed(2);
    handlepartyExcelFile().then((value) => showDialog(
          // barrierDismissible: false,
          context: Get.context!,
          builder: (context) {
            return showPopup(result);
          },
        ));

    //18.888 => 18.89

    // showDialog(
    //     barrierDismissible: false,
    //     context: Get.context!,
    //     builder: ((context) => showPopup(completeResult))).then((value) {
    //   updateSheet();
    //   handlepartyExcelFile();
    // });
  }

  exclusiveGST() {
    if (gstSelectrate.value != "GST") {
      findExclusivDiscount();
    } else {
      showDialog(
          context: Get.context!,
          builder: ((context) =>
              const ErrorDialog(message: 'Please enter GST rate')));
    }
  }

  bool getNegativeField() {
    return double.tryParse(freightCharge.value.text)!.isNegative ||
        double.tryParse(mrp.value.text)!.isNegative ||
        double.tryParse(qty.value.text)!.isNegative ||
        double.tryParse(totalAmount.text)!.isNegative;
  }

  findDiscountWithoutGST() {
    final minusAmt = double.tryParse(totalAmount.value.text)! /
        double.tryParse(qty.value.text)!;
    final halfResult = (double.tryParse(mrp.value.text)! - minusAmt) /
        (double.tryParse(mrp.value.text))!;
    completeResult = halfResult * 100;
    handlepartyExcelFile().then((value) => showDialog(
        //  barrierDismissible: false,
        context: Get.context!,
        builder: (context) {
          return showPopup(completeResult.toStringAsFixed(2));
        }));
  }

  Future calculateDiscount() async {
    final regex = RegExp(r'^-?[0-9.]+$');
    if (partyName.value.text.isNotEmpty &&
        invoiceNo.value.text.isNotEmpty &&
        partNo.value.text.isNotEmpty &&
        mrp.value.text.isNotEmpty &&
        qty.value.text.isNotEmpty &&
        totalAmount.value.text.isNotEmpty &&
        freightCharge.value.text.isNotEmpty) {
      if (invoiceDate.value == "Select Invoice Date" &&
          billIssueDetails.value == "Select Bill Issue Date") {
        showDialog(
            context: Get.context!,
            builder: ((context) =>
                const ErrorDialog(message: 'Please select dates')));
      } else if (!regex.hasMatch(freightCharge.text) ||
          !regex.hasMatch(mrp.text) ||
          !regex.hasMatch(qty.text) ||
          !regex.hasMatch(totalAmount.text)) {
        showDialog(
            context: Get.context!,
            builder: ((context) =>
                const ErrorDialog(message: 'Remove special character.')));
      } else if (getNegativeField()) {
        showDialog(
            context: Get.context!,
            builder: ((context) =>
                const ErrorDialog(message: 'Fields cannot be negative')));
      } else {
        if (gstTypeText.value != 'Exclusive') {
          if (gstSelectrate.value != "GST" || gstTypeText.value == "Exempt") {
            findDiscountWithoutGST();
          } else {
            showDialog(
                context: Get.context!,
                builder: ((context) =>
                    const ErrorDialog(message: 'Please enter GST rate')));
          }
        } else {
          exclusiveGST();
        }
      }
    } else {
      showDialog(
          context: Get.context!,
          builder: ((context) =>
              const ErrorDialog(message: 'fill all blanks')));
    }
  }

  Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: _selectedDate,
    );
    return picked;
  }

  Future handlepartyExcelFile() async {
    final fileName =
        '${output.path}/${partyName.text.replaceAll(regExp, '')}.xlsx';

    staffPrint(fileName);

    // Check if the file exists in the user's phone storage
    final fileExists = await checkPartyExcelFileExists();
    staffPrint(fileExists);

    // Create the file if it doesn't exist
    if (!fileExists) {
      final workbook = Excel.createExcel();
      final sheet = workbook['Sheet1'];
      sheet.appendRow([
        'BILL SERIES',
        'BILL DATE',
        'Purc Type',
        'PARTY NAME',
        'ITC ELIGIBILITY',
        'NARRATION',
        'ITEM NAME',
        'QTY',
        'UNIT',
        'PRICE',
        'DISC%',
        'Amount'
      ]);
      await saveExcelFile(workbook, fileName);
    }
    // Load the existing file
    final bytes = await File(fileName).readAsBytes();
    final workbook = Excel.decodeBytes(bytes);
    final sheet = workbook['Sheet1'];

    // Ask the user for input and save 3 items to the Excel file
    fillExcelSheet(sheet);

    // Save the Excel file
    await saveExcelFile(workbook, fileName);
  }

  fillExcelSheet(Sheet sheet) async {
    sheet.appendRow([
      getBillSeries,
      getBillDate,
      getPurcType,
      getPartyName,
      getITCEligibility,
      getNarrationText,
      getItemName,
      getQty,
      getUnit,
      getPrice,
      getDisc,
      num.tryParse(getAmount.toStringAsFixed(2))
    ]);
    staffPrint('getAmount is $getAmount and ${getAmount.toStringAsFixed(2)}');
  }

// Helper function to save an Excel file
  Future<void> saveExcelFile(Excel workbook, String filePath) async {
    final bytes = workbook.encode();
    File path = File(filePath);
    if (path.existsSync()) {
      // File exists, open it
      staffPrint('Opening file...');
      // Do something with the file here, e.g. read data from the file

      await File(filePath).writeAsBytes(bytes!);
      showSnackBar('Entry saved to file', purpleColor, whiteColor);
    } else {
      // File does not exist, create it
      staffPrint('File not found, creating file...');
      path.createSync();
      saveExcelFile(workbook, filePath);
      // Do something with the file here, e.g. write data to the file
    }
  }

  void deleteExcelFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  showPopup(String discount) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        scrollable: true,
        title: Column(
          children: [
            Lottie.asset(
              animate: true,
              width: 200,
              fit: BoxFit.contain,
              height: 200,
              'assets/lottie/completed.json',
            ),
            const SizedBox(height: 20),
            Text(
              'Discount is $discount %',
              style:
                  kBodyText3Style().copyWith(color: blackColor, fontSize: 18),
            ),

            // ignore: unnecessary_null_comparison
            if (map[partNo.text]?[0] != null &&
                map[partNo.text]![0].toString().length >= 2)
              Column(
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Location is ${map[partNo.text]?[0]}',
                    style: kBodyText3Style()
                        .copyWith(color: blackColor, fontSize: 14),
                  ),
                ],
              ),
          ],
        ),
        actions: [
          if (!partyNameList.contains(partyName.text))
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: purpleColor.shade300),
                onPressed: () {
                  Get.find<AddNewpartyController>().name.text = partyName.text;
                  Get.to(() => const NewPartyScreen());
                },
                child: Text(
                  'Add Party Name',
                  style: kBodyText3Style()
                      .copyWith(color: whiteColor, fontSize: 16),
                ),
              ),
            ),
          if (!partNumberList.contains(partNo.text))
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: purpleColor.shade300),
                onPressed: () {
                  var controller = Get.find<AddNewItemCOntroller>();
                  controller.itemName.text = partNo.text;
                  controller.partName.text = partNo.text;
                  Get.to(() => const AddNewItemScreen());
                },
                child: Text(
                  'Add Item No.',
                  style: kBodyText3Style()
                      .copyWith(color: whiteColor, fontSize: 16),
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 75, 190, 98)),
              onPressed: () {
                //Get.back();
                shareParty();
                //showAlertTocheckUserSharedThisFile();
                //show dialog to share the existing file.
                //delete file after sharing..
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.share, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Share',
                    style: kBodyText3Style()
                        .copyWith(color: whiteColor, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 75, 190, 98)),
              onPressed: () {
                userWantsToInsertNewItemToExisting();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.navigate_next, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Next',
                    style: kBodyText3Style()
                        .copyWith(color: whiteColor, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: whiteColor,
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: Colors.red))),
              onPressed: () {
                deleteExcelFile('${outputParty.path}/${partyName.text}.xlsx');
                clearThisField();
                // deleteExcelFile('${outputParty.path}/${partyName.text}.xlsx');
                // clearThisField();
                //Get.back();
                // shareParty();
                //showAlertTocheckUserSharedThisFile();
                //show dialog to share the existing file.
                //delete file after sharing..
              },
              child: Text(
                'New Party',
                style:
                    kBodyText3Style().copyWith(color: Colors.red, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
