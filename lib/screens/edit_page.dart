import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../contact_models.dart';
import '../global.dart';
import '../main.dart';
import '../resources/app_colors.dart';
import '../theme/app_theme.dart';

class Edit_Page extends StatefulWidget {
  const Edit_Page({Key? key}) : super(key: key);

  @override
  State<Edit_Page> createState() => _Edit_PageState();
}

class _Edit_PageState extends State<Edit_Page> {
  final GlobalKey<FormState> editContact = GlobalKey<FormState>();

  final TextEditingController editFirstNameController = TextEditingController();
  final TextEditingController editLastNameController = TextEditingController();
  final TextEditingController editPhoneNumberController =
      TextEditingController();
  final TextEditingController editEmailController = TextEditingController();

  String? editFirstName;
  String? editLastName;
  String? editPhoneNumber;
  String? editEmail;
  File? editImage;

  final ImagePicker _picker = ImagePicker();

  bool itRun = true;

  @override
  Widget build(BuildContext context) {
    Color isDarkColor = (AppTheme.isDark == true)
        ? AppColors.primaryColorLight
        : AppColors.primaryColorDark;

    dynamic res = ModalRoute.of(context)!.settings.arguments;

    if (itRun == true) {
      editFirstNameController.text = res.firstName;
      editLastNameController.text = res.lastName;
      editPhoneNumberController.text = res.phoneNumber;
      editEmailController.text = res.email;
    }

    itRun = false;

    double _height = MediaQuery.of(context).size.height;

    TextStyle editTextStyle = TextStyle(color: isDarkColor, fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, color: isDarkColor),
        ),
        title: Text(
          'Edit Contact',
          style: TextStyle(color: isDarkColor),
        ),
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Are You Shore Want To Upgrade Contact ?"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        editFirstNameController.clear();
                        editLastNameController.clear();
                        editPhoneNumberController.clear();
                        editEmailController.clear();

                        setState(() {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil("/", (route) => false);

                          editFirstName = "";
                          editLastName = "";
                          editPhoneNumber = "";
                          editEmail = "";
                          editImage = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (editContact.currentState!.validate()) {
                          editContact.currentState!.save();

                          Contacts c = Contacts(
                            firstName: editFirstName,
                            lastName: editLastName,
                            phoneNumber: editPhoneNumber,
                            email: editEmail,
                            image: (editImage != null) ? editImage : res.image,
                          );

                          int i = Global.allcontacts.indexOf(res);
                          Global.allcontacts[i] = c;

                          setState(() {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => myApp(),
                              ),
                            );

                            editFirstName = "";
                            editLastName = "";
                            editPhoneNumber = "";
                            editEmail = "";
                            editImage = null;
                          });

                          editFirstNameController.clear();
                          editLastNameController.clear();
                          editPhoneNumberController.clear();
                          editEmailController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                      child: const Text("Upgrade"),
                    ),
                  ],
                ),
              );
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
                    backgroundImage: (editImage != null)
                        ? FileImage(editImage!)
                        : (res.image != null)
                            ? FileImage(res.image!)
                            : null,
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
                                  editImage = File(pickerFile!.path);
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
                                  editImage = File(pickerFile!.path);
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
                  key: editContact,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: _height * 0.03),
                        Text(
                          "First Name",
                          style: editTextStyle,
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
                            editFirstName = val;
                          },
                          controller: editFirstNameController,
                          decoration:
                              textFieldDecoration("Enter Your First Name..."),
                        ),
                        SizedBox(height: _height * 0.012),
                        Text(
                          "Last Name",
                          style: editTextStyle,
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
                            editLastName = val;
                          },
                          controller: editLastNameController,
                          decoration:
                              textFieldDecoration("Enter Your Last Name..."),
                        ),
                        SizedBox(height: _height * 0.012),
                        Text(
                          "Phone Number",
                          style: editTextStyle,
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
                            editPhoneNumber = val;
                          },
                          keyboardType: TextInputType.number,
                          controller: editPhoneNumberController,
                          decoration:
                              textFieldDecoration("Enter Your Phone Number..."),
                        ),
                        SizedBox(height: _height * 0.012),
                        Text(
                          "Email",
                          style: editTextStyle,
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
                            editEmail = val;
                          },
                          controller: editEmailController,
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
