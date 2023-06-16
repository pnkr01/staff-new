import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/app_color.dart';
import 'home_controller.dart';

class AddNewItemCOntroller extends GetxController {
  late TextEditingController itemName;
  late TextEditingController partName;
  late TextEditingController hsnCode;
  late TextEditingController mrp;
  late TextEditingController location;

  @override
  void onInit() {
    itemName = TextEditingController();
    partName = TextEditingController();
    hsnCode = TextEditingController();
    mrp = TextEditingController();
    location = TextEditingController();
    super.onInit();
  }

  RxString groupText = 'Select Group'.obs;
  List<String> groupItem = [
    "Select Group",
    "ABC",
    "ACTIVE GOLD",
    "ADHESIVE",
    "ADICO",
    "ADITYA",
    "AIR",
    "ALASKA",
    "ALLIED",
    "ALPOIL",
    "AMFIL",
    "AMW",
    "ANABOND",
    "ANUPAM",
    "APLS",
    "ARB",
    "ASK",
    "ASPA",
    "ASTRAL",
    "ATUL",
    "AUTL",
    "AUTOCOMP",
    "AUTOLEK",
    "AUTOPAL",
    "AYUB",
    "BANCO",
    "BGL",
    "BHARAT",
    "BHARATBNEZ",
    "BIMITE",
    "BINTAX",
    "BOSCH",
    "BRAKES INDIA",
    "BRAKES INDIA LTD",
    "CA",
    "CALEX",
    "CAMPA",
    "CAROT",
    "CASTROL",
    "CEEKAY",
    "CHILLER ITEM",
    "CLAMP ITEM",
    "CMX",
    "COMPO",
    "CONE",
    "CONTINENTAL",
    "COSMIC",
    "CUMMINS",
    "DAICO",
    "DD",
    "DEC",
    "DELITE",
    "DELUX",
    "DEMM",
    "DEVENDRA",
    "DONALDSON",
    "DYNASEAL",
    "EICHER",
    "ELCHICO",
    "ELECTRICAL",
    "ELF",
    "ELOFIC",
    "EMERY",
    "ENG ITEMS",
    "EVEREST",
    "EVL",
    "EXIDE",
    "FAG",
    "FATAFAT",
    "FENNER",
    "FERODO",
    "FG",
    "FILTRUM",
    "FINOLEX",
    "FLEXO",
    "FUSI",
    "GABRIEL",
    "GAJARA",
    "GASKET",
    "GEAR BOX GB30",
    "GEAR BOX GB40 ITEM",
    "GEAR ITEM",
    "General",
    "GENTLEMAN",
    "GIBRALTOR",
    "GOETZ",
    "GOGO",
    "GRR",
    "GS",
    "GULF",
    "HARISH",
    "HELLA",
    "HISPIN",
    "HP",
    "HS",
    "INSURANCE",
    "IPL",
    "JAGAN",
    "JAI",
    "JAY",
    "JAYCO",
    "JNM",
    "KAFILA",
    "KAMCO",
    "KBX",
    "KCI",
    "KD",
    "KGN",
    "KIRLOSKAR",
    "KKI",
    "KNORR BREMSE",
    "KROSS",
    "LAMINA",
    "LEYPARTS",
    "LFAF",
    "LIPE",
    "LISPART",
    "LUBRICANTS",
    "LUCAS",
    "LUK",
    "LUMAN",
    "LUMAX",
    "MAHINDRA",
    "MAK",
    "MANN",
    "MARCOPOLO",
    "MARX",
    "MAXMOL",
    "MBL",
    "MEI",
    "MENON",
    "MERITOR",
    "MFC",
    "MICO",
    "MICO LUBES",
    "MICRO LINE",
    "MILES",
    "MILLARD",
    "MINDA",
    "MNR",
    "MOBIL",
    "MORPAR",
    "MOTHER SON",
    "MSL",
    "MTL",
    "NBC",
    "NEOLITE",
    "NICE",
    "NIKKO",
    "NRB",
    "NUTBOLT",
    "NUTEK",
    "NYEON",
    "OAYKAY",
    "ORBIT",
    "PARKASH",
    "PARTSMART",
    "PBG",
    "PC",
    "Pcs",
    "PENSOL",
    "PENTA",
    "PHILIPS",
    "PIONEER",
    "PIPE ITEM",
    "PIX",
    "PKG ITEMS",
    "PRABHU",
    "PRICOL",
    "PRIZOL",
    "PROLIFE",
    "PROPSHAFT",
    "PUROLATOR",
    "RADHE",
    "RANBRO",
    "RANE",
    "RANE CLUTCH",
    "RANE CROSS",
    "RANE ENG",
    "RANE TRW",
    "RBL",
    "RIDER",
    "RIVON",
    "RKI",
    "RMP",
    "ROOTS",
    "RSB",
    "SADHU",
    "SAMRAT",
    "SERVO",
    "Set",
    "SKF",
    "SMB",
    "SOCKET",
    "SONICO",
    "SONNET",
    "SORL",
    "SPANNER",
    "SPG",
    "SPICER",
    "SRMT",
    "STL",
    "SUKUN",
    "SUNNY",
    "SUPER SEAL",
    "SUPER TARUS",
    "SVL",
    "SWATI GOLD",
    "TALBROS",
    "TANATAN",
    "TAPARIA",
    "TBC",
    "TEXSPIN",
    "TGP",
    "TGP LUBE",
    "TIGER POWER",
    "TIMKEN",
    "TOOLS",
    "TOYO",
    "TRENDY",
    "TVS",
    "U CAP",
    "VALEO",
    "VALVOLINE",
    "VAN",
    "VEEDOL",
    "VEETHREE",
    "VESCO",
    "VIR",
    "VIR GREASE",
    "WABCO",
    "WAHAN",
    "WAXPOL",
    "WIPER",
    "WIPEX",
    "WURTH",
    "YATRIK",
    "YORK",
    "ZEUS",
    "ZF",
  ];
  changedealerTypeText(val) {
    groupText.value = val;
  }

  RxString unitText = "Select Unit".obs;
  List<String> unitList = [
    "Select Unit",
    "Dozen",
    "FT",
    "Gms",
    "INCH",
    "Kgs.",
    "LTR",
    "Metre",
    "N.A.",
    "Pcs",
    "ROLL",
    "Set",
    "Tonne",
  ];
  changeUnitTypeText(val) {
    unitText.value = val;
  }

  RxString taxText = "Select Tax".obs;
  List<String> taxList = [
    "Select Tax",
    "12%",
    "18%",
    "28%",
    "5%",
  ];
  changeTaxTypeText(val) {
    taxText.value = val;
  }

  RxBool isAdding = false.obs;

  bool checkallokay() {
    return itemName.text.isNotEmpty &&
        partName.text.isNotEmpty &&
        groupText.value != "Select Group" &&
        unitText.value != "Select Unit" &&
        taxText.value != "Select Tax" &&
        hsnCode.text.isNotEmpty &&
        mrp.text.isNotEmpty &&
        location.text.isNotEmpty;
  }

  startCheckingTap() {
    if (checkallokay()) {
      startSavingUserData();
    } else {
      isAdding.value = false;
      showSnackBar("check all fields", purpleColor, whiteColor);
    }
  }

  String get getItemName => itemName.text.trim();
  String get getItemAlias => partName.text.trim();
  String get getGroupText => groupText.value;
  String get getUnitText => unitText.value;
  String get getTaxCategory => taxText.value;
  String get getHsnCode => hsnCode.text.trim();
  String get getMrpText => mrp.text.trim();
  String get getLocationText => location.text.trim();
  Directory? appDocumentsDirectory;
  startSavingUserData() async {
    appDocumentsDirectory = await getExternalStorageDirectory();
    String filePath = '${appDocumentsDirectory!.path}/newItem.xlsx';
    File myFile = File(filePath);
    if (!myFile.existsSync()) {
      final workbook = Excel.createExcel();
      final sheet = workbook['Sheet1'];
      sheet.appendRow([
        "Item_Name",
        "Item_Alias",
        "Item_Group",
        "Item_Main_Unit",
        "Tax_Category",
        "HSN",
        "MRP",
        "Loc",
        "MRP wise details",
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
    await saveItemNoDataToExistingExcel();
  }

  Future<void> saveItemNoDataToExistingExcel() async {
    staffPrint('saving.............371');
    Get.find<HomeController>().updatePartNumberSheet(
      getItemName,
      getItemAlias,
      getLocationText,
      getGroupText,
      getUnitText,
    );
    staffPrint('updated..... sheet');
    showSnackBar("Entry Added :)", purpleColor, whiteColor);
    isAdding.value = false;
    clearField();
  }

  clearField() {
    itemName.clear();
    partName.clear();
    groupText.value = 'Select Group';
    unitText.value = "Select Unit";
    taxText.value = "Select Tax";
    hsnCode.clear();
    mrp.clear();
    location.clear();
  }

  fillExcelSheet(Sheet sheet) async {
    sheet.appendRow([
      getItemName,
      getItemAlias,
      getGroupText,
      getUnitText,
      getTaxCategory,
      getHsnCode,
      num.tryParse(getMrpText),
      getLocationText,
      "Y"
    ]);
  }

  share(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await Share.shareFiles([path], text: 'Export Item');
    } else {
      showSnackBar("No file exist now", purpleColor, whiteColor);
    }
    // ignore: deprecated_member_use
  }

  void deleteExcelFile(String filePath) async {
    final file = File(filePath);
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
      showSnackBar('Entry saved to file', purpleColor, whiteColor);
    } else {
      // File does not exist, create it
      staffPrint('File not found, creating file...');
      path.createSync();
      saveExcelFile(workbook, filePath);
      // Do something with the file here, e.g. write data to the file
    }
  }
}
