import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/services/user_database.dart';
import 'package:scms/shared/constants.dart';

class ManageCommitteeMember extends StatefulWidget {
  ManageCommitteeMember({Key? key}) : super(key: key);

  @override
  State<ManageCommitteeMember> createState() => _ManageCommitteeMemberState();
}

class _ManageCommitteeMemberState extends State<ManageCommitteeMember> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String error = '';

  bool isFirstLoad = true;

  final List<String> user = ['test', 'test2'];

  //controller
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    if (isFirstLoad) {
      // nameController.text = widget.clubData.club_name!;
      // emailController.text = widget.clubData.club_email!;
      // descController.text = widget.clubData.club_desc!;
      // categoryController.text = widget.clubData.club_category!;
      isFirstLoad = false;
    }
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Edit Club'),
            body: StreamBuilder<List<UserData>>(
              stream: UserDatabaseService(uid: user!.uid).userDataList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<UserData>? userData = snapshot.data;
                  return Center(
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
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return loadingIndicator();
                }
              },
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
