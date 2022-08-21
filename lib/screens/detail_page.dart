import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global.dart';
import '../main.dart';
import '../resources/app_colors.dart';
import '../theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';

class Detail_Page extends StatefulWidget {
  Detail_Page({Key? key}) : super(key: key);

  @override
  State<Detail_Page> createState() => _Detail_PageState();
}

class _Detail_PageState extends State<Detail_Page> {
  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;

    Color isDarkColor = (AppTheme.isDark == true)
        ? AppColors.primaryColorLight
        : AppColors.primaryColorDark;

    final GlobalKey<FormState> emailDetail = GlobalKey<FormState>();

    final TextEditingController emailSubjectController =
        TextEditingController();
    final TextEditingController emailBodyController = TextEditingController();

    String? emailSubject;
    String? emailBody;
    TextStyle addTextStyle = TextStyle(color: isDarkColor, fontSize: 18);

    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, color: isDarkColor),
        ),
        title: Text(
          'Contacts',
          style: TextStyle(color: isDarkColor),
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                AppTheme.isDark = !AppTheme.isDark;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => myApp(),
                  ),
                );
              });
            },
            child: SizedBox(
              width: 55,
              child: Icon(Icons.circle, color: isDarkColor),
            ),
          ),
          InkWell(
            onTap: () {},
            child: SizedBox(
              width: 55,
              child: Icon(Icons.more_vert, color: isDarkColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              // const Spacer(),
              SizedBox(height: 25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(flex: 7),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    backgroundImage: (res.image != null)
                        ? FileImage(res.image as File)
                        : null,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Global.allcontacts.remove(res);

                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/", (route) => false);
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed("edit_page", arguments: res);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  Text(
                    "${res.firstName} ${res.lastName}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "+91 ${res.phoneNumber}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () async {
                          Uri url = Uri.parse("tel:+91${res.phoneNumber}");
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Can't call..."),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        mini: true,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.call),
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () async {
                          Uri url = Uri.parse("sms:+91${res.phoneNumber}");
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Can't Message..."),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        mini: true,
                        backgroundColor: Colors.amber,
                        child: const Icon(Icons.message),
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: SingleChildScrollView(
                                child: Form(
                                  key: emailDetail,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: _height * 0.04),
                                      Text(
                                        "Subject",
                                        style: addTextStyle,
                                      ),
                                      SizedBox(height: _height * 0.02),
                                      TextFormField(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Enter Subject...";
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {
                                          setState(() {
                                            emailSubject = val;
                                          });
                                        },
                                        controller: emailSubjectController,
                                        decoration: textFieldDecoration(
                                            "Enter Subject"),
                                      ),
                                      SizedBox(height: _height * 0.03),
                                      Text(
                                        "Body",
                                        style: addTextStyle,
                                      ),
                                      SizedBox(height: _height * 0.02),
                                      TextFormField(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Enter Body...";
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {
                                          setState(() {
                                            emailBody = val;
                                          });
                                        },
                                        controller: emailBodyController,
                                        decoration:
                                            textFieldDecoration("Enter Body"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              title: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Enter Email Details",
                                  style: TextStyle(
                                      color: isDarkColor, fontSize: 22),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (emailDetail.currentState!.validate()) {
                                      emailDetail.currentState!.save();

                                      Navigator.of(context).pop();

                                      Uri url = Uri.parse(
                                        "mailto:${res.email}?subject=$emailSubject&body=$emailBody",
                                      );

                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text("Can't email..."),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue,
                                  ),
                                  child: const Text("Send"),
                                ),
                              ],
                            ),
                          );
                        },
                        mini: true,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.email),
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          setState(() async {
                            await Share.share(
                                "Name : ${res.firstName} ${res.lastName} \nPhone : ${res.phoneNumber}");
                          });
                        },
                        mini: true,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.share),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ],
              ),
              // const Spacer(flex: 5),
            ],
          ),
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
