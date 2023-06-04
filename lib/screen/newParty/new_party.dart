import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_color.dart';
import '../../custom_textfield.dart';
import '../home/controller/add_new_party_controller.dart';

class NewPartyScreen extends GetView<AddNewpartyController> {
  const NewPartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: purpleColor,
        title: const Text('New Party'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              StaffFormField(
                type: TextInputType.name,
                labelText: 'Name',
                hintText: 'Ex: 52',
                borderColor: Colors.purple,
                cursorColor: Colors.lightBlueAccent,
                hintColor: greyColor,
                isObscureText: false,
                controller: controller.name,
              ),
              const SizedBox(height: 14),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: purpleColor)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      iconEnabledColor: purpleColor,
                      isExpanded: true,
                      // Step 3.
                      value: controller.ledgerText.value,
                      // Step 4.
                      items: controller.ledgerItem
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
                      // Step 5.
                      onChanged: (newValue) {
                        staffPrint(newValue);
                        controller.changeLedgerTypeText(newValue);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: purpleColor)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      iconEnabledColor: purpleColor,
                      isExpanded: true,
                      // Step 3.
                      value: controller.groupText.value,
                      // Step 4.
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
                      // Step 5.
                      onChanged: (newValue) {
                        staffPrint(newValue);
                        controller.changegroupTypeText(newValue);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              StaffFormField(
                type: TextInputType.streetAddress,
                labelText: 'Address 1',
                hintText: 'Enter address',
                borderColor: Colors.purple,
                cursorColor: Colors.lightBlueAccent,
                hintColor: greyColor,
                isObscureText: false,
                controller: controller.address1,
              ),
              const SizedBox(height: 20),
              StaffFormField(
                type: TextInputType.streetAddress,
                labelText: 'Address 2',
                hintText: 'Enter address',
                borderColor: Colors.purple,
                cursorColor: Colors.lightBlueAccent,
                hintColor: greyColor,
                isObscureText: false,
                controller: controller.address2,
              ),
              const SizedBox(height: 20),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: purpleColor)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      iconEnabledColor: purpleColor,
                      isExpanded: true,
                      // Step 3.
                      value: controller.stateText.value,
                      // Step 4.
                      items: controller.stateItem
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
                      // Step 5.
                      onChanged: (newValue) {
                        staffPrint(newValue);
                        controller.changeStateTypeText(newValue);
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
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: purpleColor)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      iconEnabledColor: purpleColor,
                      isExpanded: true,
                      // Step 3.
                      value: controller.dealerText.value,
                      // Step 4.
                      items: controller.dealerItem
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
                      // Step 5.
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
                () => Visibility(
                  visible: controller.dealerText.value == "Registered",
                  child: Column(
                    children: [
                      StaffFormField(
                          type: TextInputType.name,
                          labelText: 'Gst No.',
                          hintText: 'Ex: A2NM55C',
                          borderColor: Colors.purple,
                          cursorColor: Colors.lightBlueAccent,
                          hintColor: greyColor,
                          isObscureText: false,
                          controller: controller.gst),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              StaffFormField(
                type: TextInputType.phone,
                labelText: 'Phone',
                hintText: 'Ex: 6299261622',
                borderColor: Colors.purple,
                cursorColor: Colors.lightBlueAccent,
                hintColor: greyColor,
                isObscureText: false,
                controller: controller.phone,
              ),
              const SizedBox(height: 20),
              StaffFormField(
                type: TextInputType.phone,
                labelText: 'CR Period',
                hintText: 'Ex: 5',
                borderColor: Colors.purple,
                cursorColor: Colors.lightBlueAccent,
                hintColor: greyColor,
                isObscureText: false,
                controller: controller.cdop,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {
                    controller.isAdding.value = true;
                    controller.startChecking();
                  },
                  child: Obx(() => controller.isAdding.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: whiteColor,
                            strokeWidth: 1,
                          ),
                        )
                      : const Text(
                          "Add",
                          style: TextStyle(fontSize: 18),
                        )),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
