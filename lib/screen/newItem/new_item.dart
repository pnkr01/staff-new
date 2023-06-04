import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_color.dart';
import '../../custom_textfield.dart';
import '../home/controller/add_new_item_controller.dart';

class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({Key? key}) : super(key: key);

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  var controller = Get.find<AddNewItemCOntroller>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        centerTitle: true,
        title: const Text('Add Item'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                const SizedBox(height: 20),
                StaffFormField(
                  type: TextInputType.name,
                  labelText: 'Item Name',
                  hintText: 'Ex: 5',
                  borderColor: Colors.purple,
                  cursorColor: Colors.lightBlueAccent,
                  hintColor: greyColor,
                  isObscureText: false,
                  controller: controller.itemName,
                ),
                const SizedBox(height: 20),
                StaffFormField(
                  type: TextInputType.name,
                  labelText: 'Part Number',
                  hintText: 'Ex: 5',
                  borderColor: Colors.purple,
                  cursorColor: Colors.lightBlueAccent,
                  hintColor: greyColor,
                  isObscureText: false,
                  controller: controller.partName,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: purpleColor)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        iconEnabledColor: purpleColor,
                        isExpanded: true,
                        value: controller.groupText.value,
                        items: controller.groupItem
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: Text(
                                value,
                                style: kBodyText3Style()
                                    .copyWith(color: purpleColor),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          staffPrint(newValue);
                          controller.changedealerTypeText(newValue);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: purpleColor)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        iconEnabledColor: purpleColor,
                        isExpanded: true,
                        value: controller.unitText.value,
                        items: controller.unitList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: Text(
                                value,
                                style: kBodyText3Style()
                                    .copyWith(color: purpleColor),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          staffPrint(newValue);
                          controller.changeUnitTypeText(newValue);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: purpleColor)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        iconEnabledColor: purpleColor,
                        isExpanded: true,
                        value: controller.taxText.value,
                        items: controller.taxList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: Text(
                                value,
                                style: kBodyText3Style()
                                    .copyWith(color: purpleColor),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          staffPrint(newValue);
                          controller.changeTaxTypeText(newValue);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                StaffFormField(
                  type: TextInputType.phone,
                  labelText: 'HSN Code',
                  hintText: 'Ex: 5',
                  borderColor: Colors.purple,
                  cursorColor: Colors.lightBlueAccent,
                  hintColor: greyColor,
                  isObscureText: false,
                  controller: controller.hsnCode,
                ),
                const SizedBox(height: 20),
                StaffFormField(
                  type: TextInputType.phone,
                  labelText: 'MRP',
                  hintText: 'Ex: 5',
                  borderColor: Colors.purple,
                  cursorColor: Colors.lightBlueAccent,
                  hintColor: greyColor,
                  isObscureText: false,
                  controller: controller.mrp,
                ),
                const SizedBox(height: 20),
                StaffFormField(
                  type: TextInputType.name,
                  labelText: 'Location',
                  hintText: 'Ex: 5',
                  borderColor: Colors.purple,
                  cursorColor: Colors.lightBlueAccent,
                  hintColor: greyColor,
                  isObscureText: false,
                  controller: controller.location,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: purpleColor),
                      onPressed: () {
                        controller.startCheckingTap();
                      },
                      child: Obx(
                        () => controller.isAdding.value
                            ? const SizedBox(
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                    strokeWidth: 1,
                                  ),
                                ),
                              )
                            : const Text(
                                'Add ',
                                style: TextStyle(fontSize: 18),
                              ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
