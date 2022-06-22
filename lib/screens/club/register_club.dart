import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/club/club_logo.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

class RegisterClub extends StatefulWidget {
  RegisterClub({Key? key}) : super(key: key);

  @override
  State<RegisterClub> createState() => _RegisterClubState();
}

class _RegisterClubState extends State<RegisterClub> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _checked = false;
  String noImageSelect = '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String error = '';
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    category.sort();
    final user = Provider.of<thisUser?>(context);
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Club Registration'),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            if (_imageFile == null) {
                              final imageFile = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => clubLogo()),
                              );
                              setState(() {
                                _imageFile = imageFile;
                              });
                            } else {
                              final imageFile = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        clubLogo(selectImage: _imageFile)),
                              );
                              setState(() {
                                _imageFile = imageFile;
                              });
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blue)),
                              height: 200,
                              child: _imageFile == null
                                  ? const Center(
                                      child: Text('No Image Selected'))
                                  : Image.file(_imageFile!, fit: BoxFit.fill)),
                        ),
                        Text(noImageSelect,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0)),
                        const SizedBox(height: 20.0),
                        buildForm(nameController, 'Club Name',
                            clubNameValidator, Icons.groups_rounded),
                        const SizedBox(height: 20.0),
                        buildLongForm(descController, 'Club Description',
                            clubDescValidator, MdiIcons.imageText),
                        const SizedBox(height: 20.0),
                        buildForm(emailController, 'Official Email',
                            emailValidator, Icons.email_sharp),
                        const SizedBox(height: 20.0),
                        categoryDropDownButton('Club Category',
                            Icons.category_sharp, category, categoryController),
                        CheckboxListTile(
                          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          dense: true,
                          title: const Text(
                            'Whoever register the Club will be the Chairman of the Club',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: _checked,
                          onChanged: (bool? value) {
                            setState(() {
                              _checked = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_imageFile == null) {
                              setState(() {
                                noImageSelect = 'Club Logo is required !';
                              });
                            } else {
                              if (_formKey.currentState!.validate()) {
                                if (_checked) {
                                  setState(() => isLoading = true);
                                  String registerDate =
                                      DateFormat('dd-MMM-yyyy')
                                          .format(DateTime.now());
                                  ClubData clubData = ClubData(
                                    club_name: nameController.text,
                                    club_email: emailController.text,
                                    club_desc: descController.text,
                                    club_category: categoryController.text,
                                    club_registerDate: registerDate,
                                    club_chairman: user!.uid!,
                                  );
                                  dynamic result =
                                      await ClubDatabaseService(uid: user.uid)
                                          .createClubData(
                                              clubData, _imageFile, context)
                                          .whenComplete(() {
                                    showSuccessSnackBar(
                                        'Club Registered !', context);
                                  }).catchError((e) => showFailedSnackBar(
                                              e.toString(), context));
                                  Navigator.of(context).pop();
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Could not register a club, please try again';
                                      isLoading = false;
                                    });
                                  }
                                } else {
                                  showFailedSnackBar(
                                      'Make sure you checked the acknowledgement',
                                      context);
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.8, 45),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  TextFormField buildForm(TextEditingController controller, String hintText,
      String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      controller: controller,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
        labelText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
  }

  TextFormField buildLongForm(TextEditingController controller, String hintText,
      String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 1,
      maxLines: null,
      controller: controller,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
        labelText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
  }

  DropdownButtonFormField2<String> categoryDropDownButton(String labelText,
      IconData icon, List dropDownItem, TextEditingController controller) {
    return DropdownButtonFormField2(
      hint: Text(labelText),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, size: 24),
        isDense: true,
        contentPadding: const EdgeInsets.only(left: 20, bottom: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: dropDownItem
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (value) {
        controller.text = value!;
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }
}
