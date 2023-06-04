import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:staff/screen/home/controller/home_controller.dart';

import '../../../constants/app_color.dart';

class AddNewpartyController extends GetxController {
  late TextEditingController name;
  late TextEditingController gst;
  late TextEditingController address1;
  late TextEditingController address2;
  late TextEditingController phone;
  late TextEditingController cdop;
  @override
  void onInit() {
    name = TextEditingController();
    address1 = TextEditingController();
    address2 = TextEditingController();
    phone = TextEditingController();
    cdop = TextEditingController();
    gst = TextEditingController();
    super.onInit();
  }

  //---Ledger----//
  RxString ledgerText = 'Select Ledger'.obs;
  List<String> ledgerItem = ["Select Ledger", "General Ledger", "Sub ledger"];
  changeLedgerTypeText(val) {
    ledgerText.value = val;
  }

  //---GST----//
  RxString gstText = 'Select GST'.obs;
  List<String> gstItem = ["Select GST", "5%", "12%", "18%", "28%"];
  changeGstTypeText(val) {
    gstText.value = val;
  }

  //---Dealer----//
  RxString dealerText = 'Select Dealer'.obs;
  List<String> dealerItem = ["Select Dealer", "Registered", "Un-Registered"];
  changedealerTypeText(val) {
    dealerText.value = val;
  }

  //---State----//
  RxString stateText = 'Select State'.obs;
  //List<String> stateItem = ["Select Ledger", "General Ledger", "Sub ledger"];
  changeStateTypeText(val) {
    stateText.value = val;
  }

  List<String> stateItem = [
    'Select State',
    "Andaman and Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    'Chhattisgarh',
    'Dadra and Nagar Haveli',
    "Daman and Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "India",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Pondicherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamilnadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
  ];

  //---Group----//
  RxString groupText = 'Select Group'.obs;
  List<String> groupItem = [
    "Select Group",
    "Sundry Creditors",
    "Sundry Debtors"
  ];
  changegroupTypeText(val) {
    groupText.value = val;
  }

  RxBool isAdding = false.obs;

  bool isCheckFiledPass() {
    return name.text.isNotEmpty &&
            ledgerText.value != 'Select Ledger' &&
            groupText.value != "Select Group" &&
            address1.text.isNotEmpty ||
        address2.text.isNotEmpty &&
            stateText.value != "Select State" &&
            dealerText.value != "Select Dealer" &&
            phone.text.isNotEmpty &&
            phone.text.length == 10 &&
            cdop.text.isNotEmpty &&
            gst.text.isNotEmpty;
  }

  startChecking() {
    if (isCheckFiledPass()) {
      if (dealerText.value == "Registered") {
        if (gst.text.isNotEmpty) {
          startSavingUserData();
        } else {
          isAdding.value = false;
          showSnackBar("Please fill GST", purpleColor, whiteColor);
        }
      } else {
        isAdding.value = false;
        startSavingUserData();
      }
    } else {
      isAdding.value = false;
      showSnackBar("Please fill blanks properly", purpleColor, whiteColor);
    }
  }

  String get getAccountName => name.text.trim();
  String get getLedgerType => ledgerText.value;
  String get getAccountGroup => groupText.value;
  String get geAddress1 => address1.text;
  String get getAddress2 => address2.text;
  String get getAccountState => stateText.value;
  String get getDealereType => dealerText.value;
  String get getGSTText => gst.text;
  String get getMobileNo => phone.text;
  String get getCreditDays => cdop.text;
  Directory? appDocumentsDirectory;
  startSavingUserData() async {
    appDocumentsDirectory = (await getExternalStorageDirectory())!;
    staffPrint(appDocumentsDirectory?.path);
    String filePath = '${appDocumentsDirectory?.path}/newParty.xlsx';
    File myFile = File(filePath);
    if (!myFile.existsSync()) {
      staffPrint("not  exist...");
      final workbook = Excel.createExcel();
      final sheet = workbook['Sheet1'];
      sheet.appendRow([
        "ACC_NAME",
        "TYPE_OF_LEDGER",
        "ACC_GROUP",
        "ADD_1",
        "ADD_2",
        "ACC_COUNTRY",
        "ACC_STATE",
        "TYPE_OF_DEALER",
        "GST_NO",
        "ACC_MOB_NO",
        "ACC_CREDIT_DAYS_PURC"
      ]);
      await saveExcelFile(workbook, filePath);
    }
    // Load the existing file
    final bytes = await File(filePath).readAsBytes();
    final workbook = Excel.decodeBytes(bytes);
    final sheet = workbook['Sheet1'];

    // Ask the user for input and save 3 items to the Excel file
    fillExcelSheet(sheet);

    // Save the Excel file
    await saveExcelFile(workbook, filePath);
    await savePartyDataToExistingExcel();
  }

  Future<void> savePartyDataToExistingExcel() async {
    staffPrint('saving.............427');
    Get.find<HomeController>().updatePartySheet(groupText.value);
    staffPrint('updated..... sheet');
    showSnackBar("Entry Added :)", purpleColor, whiteColor);
    isAdding.value = false;
    clearField();
  }

  clearField() {
    name.clear();
    ledgerText.value = 'Select Ledger';
    groupText.value = "Select Group";
    address1.clear();
    address2.clear();
    stateText.value = 'Select State';
    dealerText.value = 'Select Dealer';
    phone.clear();
    cdop.clear();
  }

  share(String path) async {
    // ignore: deprecated_member_use
    final file = File(path);
    if (await file.exists()) {
      await Share.shareFiles([path], text: 'Export Account');
    } else {
      showSnackBar("No file exist now", purpleColor, whiteColor);
    }
  }

  // void deleteExcelFile(String filePath) async {

  fillExcelSheet(Sheet sheet) async {
    sheet.appendRow([
      getAccountName,
      getLedgerType,
      getAccountGroup,
      geAddress1,
      getAddress2,
      "India",
      getAccountState,
      getDealereType,
      getGSTText,
      getMobileNo,
      getCreditDays
    ]);
  }

  void deleteExcelFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> saveExcelFile(Excel workbook, String filePath) async {
    final bytes = workbook.encode();
    File path = File(filePath);
    if (path.existsSync()) {
      // File exists, open it
      staffPrint('Opening file...');
      // Do something with the file here, e.g. read data from the file

      await File(filePath).writeAsBytes(bytes!);
      //showSnackBar('Entry saved to file', purpleColor, whiteColor);
    } else {
      // File does not exist, create it
      staffPrint('File not found, creating file...');
      path.createSync();
      saveExcelFile(workbook, filePath);
      // Do something with the file here, e.g. write data to the file
    }
  }
}
