import 'dart:io';
import 'dart:ui';

import 'package:contact_diary_app/contact_models.dart';
import 'package:contact_diary_app/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/app_colors.dart';
import '../theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class Add_Page extends StatefulWidget {
  Add_Page({Key? key}) : super(key: key);

  @override
  State<Add_Page> createState() => _Add_PageState();
}

class _Add_PageState extends State<Add_Page> {
  final GlobalKey<FormState> addContact = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  File? image;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    Color isDarkColor = (AppTheme.isDark == true)
        ? AppColors.primaryColorLight
        : AppColors.primaryColorDark;

    TextStyle addTextStyle = TextStyle(color: isDarkColor, fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, color: isDarkColor),
        ),
        title: Text(
          'Add',
          style: TextStyle(color: isDarkColor),
        ),
        actions: [
          InkWell(
            onTap: () {
              if (addContact.currentState!.validate()) {
                addContact.currentState!.save();

                Contacts c1 = Contacts(
                  firstName: firstName,
                  lastName: lastName,
                  phoneNumber: phoneNumber,
                  email: email,
                  image: image,
                );
                setState(() {
                  Global.allcontacts.add(c1);
                });
              }
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/", (route) => false);
            },
            child: SizedBox(
              width: 55,
              child: Icon(Icons.check, color: isDarkColor),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(13),
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey,
                    backgroundImage: (image != null) ? FileImage(image!) : null,
                    child: (image != null)
                        ? const Text("")
                        : const Text(
                            "Add",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("When You go to pick Image ?"),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                XFile? pickerFile = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  image = File(pickerFile!.path);
                                  Navigator.of(context).pop();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,
                              ),
                              child: const Text("gallery"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                XFile? pickerFile = await _picker.pickImage(
                                    source: ImageSource.camera);
                                setState(() {
                                  image = File(pickerFile!.path);
                                  Navigator.of(context).pop();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,
                              ),
                              child: const Text("Camera"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.add),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: SizedBox(
                width: double.infinity,
                child: Form(
                  key: addContact,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: _height * 0.03),
                        Text(
                          "First Name",
                          style: addTextStyle,
                        ),
                        SizedBox(height: _height * 0.005),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter First Name...";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            firstName = val;
                          },
                          controller: firstNameController,
                          decoration:
                              textFieldDecoration("Enter Your First Name..."),
                        ),
                        SizedBox(height: _height * 0.012),
                        Text(
                          "Last Name",
                          style: addTextStyle,
                        ),
                        SizedBox(height: _height * 0.005),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter Last Name...";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            lastName = val;
                          },
                          controller: lastNameController,
                          decoration:
                              textFieldDecoration("Enter Your Last Name..."),
                        ),
                        SizedBox(height: _height * 0.012),
                        Text(
                          "Phone Number",
                          style: addTextStyle,
                        ),
                        SizedBox(height: _height * 0.005),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter Phone Number...";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            phoneNumber = val;
                          },
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration:
                              textFieldDecoration("Enter Your Phone Number..."),
                        ),
                        SizedBox(height: _height * 0.012),
                        Text(
                          "Email",
                          style: addTextStyle,
                        ),
                        SizedBox(height: _height * 0.005),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter Email...";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            email = val;
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              textFieldDecoration("Enter Your Email..."),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  textFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      alignLabelWithHint: true,
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        ),
      ),
    );
  }
}
