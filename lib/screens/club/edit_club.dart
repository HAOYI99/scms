import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scms/models/club.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

class EditClub extends StatefulWidget {
  ClubData clubData;
  EditClub({Key? key, required this.clubData}) : super(key: key);

  @override
  State<EditClub> createState() => _EditClubState();
}

class _EditClubState extends State<EditClub> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String error = '';

  bool isFirstLoad = true;

  final List<String> category = ['test', 'test2'];

  //controller
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (isFirstLoad) {
      nameController.text = widget.clubData.club_name!;
      emailController.text = widget.clubData.club_email!;
      descController.text = widget.clubData.club_desc!;
      categoryController.text = widget.clubData.club_category!;
      isFirstLoad = false;
    }
    return isLoading
        ? loadingIndicator() 
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Edit Club'),
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
                        Text(error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0)),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);
                              ClubData updatedClubData = ClubData();
                              updatedClubData.club_ID = widget.clubData.club_ID;
                              updatedClubData.club_name = nameController.text;
                              updatedClubData.club_desc = descController.text;
                              updatedClubData.club_email = emailController.text;
                              updatedClubData.club_category =
                                  categoryController.text;
                              dynamic result = await ClubDatabaseService()
                                  .updateClubData(updatedClubData)
                                  .whenComplete(() {
                                showSuccessSnackBar(
                                    'Club Updated Successfully !', context);
                                Navigator.of(context).pop();
                              }).catchError((e) => showFailedSnackBar(
                                      e.toString(), context));
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not update club, please try again';
                                  isLoading = false;
                                });
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
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
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
      value: controller.text,
      onChanged: (value) {
        controller.text = value!;
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }
}
