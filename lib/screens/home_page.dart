import 'dart:io';

import 'package:contact_diary_app/main.dart';
import 'package:contact_diary_app/resources/app_colors.dart';
import 'package:contact_diary_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global.dart';

class Home_Page extends StatefulWidget {
  Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    Color isDarkColor = (AppTheme.isDark == true)
        ? AppColors.primaryColorLight
        : AppColors.primaryColorDark;
    return Scaffold(
      appBar: AppBar(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("add_page");
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        alignment: Alignment.center,
        child: (Global.allcontacts.isEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_box_outlined,
                    size: 100,
                  ),
                  Text(
                    "You do not have any contact yet.",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              )
            : ListView.builder(
                itemCount: Global.allcontacts.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pushNamed("detail_page",
                            arguments: Global.allcontacts[i]);
                      });
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: (Global.allcontacts[i].image != null)
                            ? FileImage(Global.allcontacts[i].image as File)
                            : null,
                      ),
                      title: Text(
                        "${Global.allcontacts[i].firstName} ${Global.allcontacts[i].lastName}",
                      ),
                      subtitle:
                          Text("+91 ${Global.allcontacts[i].phoneNumber}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.call, color: Colors.green),
                        onPressed: () async {
                          Uri url = Uri.parse(
                              "tel:+91${Global.allcontacts[i].phoneNumber}");
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
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
