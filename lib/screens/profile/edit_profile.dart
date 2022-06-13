import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/user.dart';
import 'package:scms/services/auth.dart';
import 'package:scms/services/user_database.dart';
import 'package:scms/shared/constants.dart';

class EditProfile extends StatefulWidget {
  UserData userData;
  EditProfile({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var phoneFormatter = new MaskTextInputFormatter(
      mask: '###-########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final List<String> genderGroup = ['Male', 'Female', 'Not Set'];
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController matricController = TextEditingController();
  TextEditingController HPnoController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  //address controller
  TextEditingController street1Controller = TextEditingController();
  TextEditingController street2Controller = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);

    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Edit Profile'),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                  child: StreamBuilder<UserData>(
                      stream: DatabaseService(uid: user!.uid).userData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // UserData? userData = snapshot.data;
                          nameController.text = widget.userData.user_name!;
                          lastnameController.text =
                              widget.userData.user_lastName!;
                          widget.userData.user_gender!.isEmpty
                              ? genderController.text = genderGroup.elementAt(2)
                              : genderController.text =
                                  widget.userData.user_gender!;
                          matricController.text =
                              widget.userData.user_matricNo!;
                          HPnoController.text = widget.userData.user_HPno!;
                          dobController.text = widget.userData.user_dob!;
                          return Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  buildForm(nameController, 'Name',
                                      firstNameValidator),
                                  const SizedBox(height: 20.0),
                                  buildForm(lastnameController, 'Last Name',
                                      lastNameValidator),
                                  const SizedBox(height: 20.0),
                                  buildForm(matricController, 'Matric No',
                                      matricNoValidator),
                                  const SizedBox(height: 20.0),
                                  buildphoneForm(
                                      HPnoController, phoneNoValidator),
                                  const SizedBox(height: 20.0),
                                  buildDropDownButton(),
                                  const SizedBox(height: 20.0),
                                  buildDateForm(
                                      dobController, dobValidator, context)
                                ],
                              ));
                        } else {
                          return loadingIndicator();
                        }
                      }),
                ),
              ),
            ),
          );
  }

  DropdownButtonFormField2<String> buildDropDownButton() {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Gender',
        prefixIcon: Icon(MdiIcons.genderMaleFemale, size: 24),
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 20, right: 10),
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
      items: genderGroup
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      value: genderController.text,
      onChanged: (value) =>
          setState(() => genderController.text = value.toString()),
    );
  }

  TextFormField buildForm(TextEditingController controller, String hintText,
      String? validator(value)) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText,
          prefixIcon: Icon(
            Icons.account_circle_rounded,
          )),
    );
  }

  TextFormField buildphoneForm(
      TextEditingController controller, String? validator(value)) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      textInputAction: TextInputAction.next,
      inputFormatters: [phoneFormatter],
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: 'Phone Number',
          prefixIcon: Icon(Icons.phone_android_outlined)),
    );
  }

  TextFormField buildDateForm(TextEditingController controller,
      String? validator(value), BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: validator,
      onTap: () async {
        final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 365 * 100)),
            lastDate: DateTime.now());
        if (pickedDate != null && pickedDate != widget.userData.user_dob) {
          String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
          controller.text = formattedDate;
        }
      },
      onChanged: (value) {
        setState(() => controller.text = value);
      },
      decoration: textInputDecoration.copyWith(
          labelText: 'Date of Birth',
          prefixIcon: Icon(Icons.date_range_outlined)),
    );
  }

  // String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
}
