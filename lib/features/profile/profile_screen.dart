import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';

import 'package:tasky/features/profile/user_details_screen.dart';
import 'package:tasky/features/welcome/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String motivationQuote;
  String? userImagePath;
  bool isLoading = true;


  @override
  void initState() {
    _loadUserData();

    super.initState();
  }

  void _loadUserData() async {
    setState(() {
      username = PreferencesManager().getString("username") ?? "";
      motivationQuote =
          PreferencesManager().getString("motivationQuote") ??
          "One task at a time. One step closer.";
      userImagePath = PreferencesManager().getString("user_image");

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 5,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      "My Profile",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,

                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            backgroundImage: userImagePath == null
                                ? AssetImage("assets/images/logo.png")
                                : FileImage(File(userImagePath!)),
                          ),
                          GestureDetector(
                            onTap: () async {
                              showImageSourceDialog(context, (XFile file) {
                                setState(() {
                                  userImagePath = file.path;
                                  _saveImage(file);
                                });
                              });
                            },
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(100),
                                border: BoxBorder.all(
                                  color: ThemeController.isDark()
                                      ? Colors.transparent
                                      : Color(0xFFD1DAD6),
                                ),
                              ),
                              child: Icon(Icons.camera_alt, size: 20),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        username,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(height: 4),
                      Text(
                        motivationQuote,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Profile Info",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                SizedBox(height: 24),
                ListTile(
                  onTap: () async {
                    final bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => UserDetailsScreen(
                          userName: username,
                          motivationQuote: motivationQuote,
                        ),
                      ),
                    );
                    if (result != null && result == true) {
                      _loadUserData();
                    }
                  },

                  leading: CustomSvgPicture(
                    path: "assets/images/profile_icon.svg",
                  ),
                  title: Text("User Details"),

                  trailing: CustomSvgPicture(
                    path: "assets/images/arrow-right_icon.svg",
                  ),
                ),
                Divider(),
                SizedBox(height: 8),
                ListTile(
                  leading: CustomSvgPicture(
                    path: "assets/images/dark_mood_icon.svg",
                  ),
                  title: Text("Dark Mode"),

                  trailing: ValueListenableBuilder<ThemeMode>(
                    valueListenable: ThemeController.themeNotifier,
                    builder: (context, value, Widget? child) {
                      return Switch(
                        value: value == ThemeMode.dark,
                        onChanged: (bool value) async {
                          ThemeController.toggleTheme();
                        },
                      );
                    },
                  ),
                ),
                Divider(),
                SizedBox(height: 8),
                ListTile(
                  onTap: () async {
                    PreferencesManager().remove("username");
                    PreferencesManager().remove("motivationQuote");
                    PreferencesManager().remove("tasks");

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => WelcomeScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },

                  leading: CustomSvgPicture(
                    path: "assets/images/logout_icon.svg",
                  ),
                  title: Text("Log Out"),
                  trailing: CustomSvgPicture(
                    path: "assets/images/arrow-right_icon.svg",
                  ),
                ),
                // Divider(),
              ],
            ),
          );
  }

  void _saveImage(XFile file) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final newFile = await File(
      file.path,
    ).copy("${appDirectory.path}/${file.name}");
    PreferencesManager().setString("user_image", newFile.path);
  }

  void showImageSourceDialog(
    BuildContext context,
    Function(XFile) selectedImage,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            "Select Image Source",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(16),
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  selectedImage(image);
                }
              },
              child: Row(
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text("Camera"),
                ],
              ),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(16),
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  selectedImage(image);
                }
              },
              child: Row(
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 8),
                  Text("Gallery"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
