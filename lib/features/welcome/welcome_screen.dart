import 'package:flutter/material.dart';

import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';

import 'package:tasky/core/widgets/custom_text_form_field.dart';

import 'package:tasky/features/navigation/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSvgPicture.withoutColor(
                      path: "assets/images/logo.svg",
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Tasky",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(height: 118),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To Tasky ",

                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(width: 8),
                    CustomSvgPicture.withoutColor(
                      path: "assets/images/waving_hand.svg",
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Your productivity journey starts here.",
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall!.copyWith(fontSize: 16),
                ),
                SizedBox(height: 24),

                CustomSvgPicture.withoutColor(
                  path: "assets/images/welcome.svg",
                  height: 215,
                  width: 200,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 28),

                      CustomTextFormField(
                        title: "Full Name",
                        controller: controller,
                        hintText: "e.g. Sarah Khalid",
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Full Name";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState?.validate() ?? false) {
                            await PreferencesManager().setString(
                              "username",
                              controller.value.text,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => MainScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please Enter Your Full Name"),
                              ),
                            );
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            MediaQuery.of(context).size.width,
                            40,
                          ),

                          padding: EdgeInsets.symmetric(
                            horizontal: 112,
                            vertical: 10,
                          ),
                        ),
                        child: Text("Let’s Get Started"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
