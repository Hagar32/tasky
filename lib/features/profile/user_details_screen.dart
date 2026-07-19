import 'package:flutter/material.dart';

import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';

import '../../core/constants/storage_key.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({
    super.key,
    required this.userName,
    required this.motivationQuote,
  });

  final String userName;
  final String? motivationQuote;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late final TextEditingController motivationQuoteController;

  late final TextEditingController userNameController;

  final GlobalKey<FormState> _userDetailsKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: widget.userName);
    motivationQuoteController = TextEditingController(
      text: widget.motivationQuote,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _userDetailsKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: userNameController,
                hintText: "Usama Elgendy",
                title: "User Name",
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter User Name ";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: motivationQuoteController,
                hintText: "One task at a time. One step closer.",
                title: "Motivation Quote",
                maxLines: 5,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter Motivation Quote ";
                  }
                  return null;
                },
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),

                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 10),
                ),
                onPressed: () async {
                  if (_userDetailsKey.currentState?.validate() ?? false) {
                    await PreferencesManager().setString(
                      StorageKey.username,
                      userNameController.value.text,
                    );

                    await PreferencesManager().setString(
                      StorageKey.motivationQuote,
                      motivationQuoteController.value.text,
                    );
                    Navigator.pop(context, true);
                  }
                },
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
