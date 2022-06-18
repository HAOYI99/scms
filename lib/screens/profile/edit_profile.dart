import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/user.dart';
import 'package:scms/services/user_database.dart';
import 'package:scms/shared/constants.dart';

class EditProfile extends StatefulWidget {
  UserData userData;
  EditProfile({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var phoneFormatter = MaskTextInputFormatter(
      mask: '###-########', filter: {"#": RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();
  final List<String> genderGroup = ['', 'Male', 'Female'];
  final List<String> stateGroup = [
    '',
    'Johor',
    'Kedah',
    'Kelantan',
    'Malacca',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
    'Kuala Lumpur',
    'Labuan',
    'Putrajaya'
  ];
  bool isLoading = false;
  String error = '';

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

  bool isFirstLoad = true;
  @override
  Widget build(BuildContext context) {
    double horizontalSpace = MediaQuery.of(context).size.width * 0.05;
    final user = Provider.of<thisUser?>(context);
    if (isFirstLoad) {
      nameController.text = widget.userData.user_name!;
      lastnameController.text = widget.userData.user_lastName!;
      widget.userData.user_gender!.isEmpty
          ? genderController.text = genderGroup.elementAt(0)
          : genderController.text = widget.userData.user_gender!;
      matricController.text = widget.userData.user_matricNo!;
      HPnoController.text = widget.userData.user_HPno!;
      dobController.text = widget.userData.user_dob!;
      street1Controller.text = widget.userData.user_addStreet1!;
      street2Controller.text = widget.userData.user_addStreet2!;
      postcodeController.text = widget.userData.user_addPostcode!;
      cityController.text = widget.userData.user_addCity!;
      widget.userData.user_addState!.isEmpty
          ? stateController.text = stateGroup.elementAt(0)
          : stateController.text = widget.userData.user_addState!;
      isFirstLoad = false;
    }
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Edit Profile'),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildForm(nameController, 'Name',
                                firstNameValidator, Icons.person),
                            const SizedBox(height: 20.0),
                            buildForm(lastnameController, 'Last Name',
                                lastNameValidator, Icons.person),
                            const SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    child: buildForm(
                                        matricController,
                                        'Matric No',
                                        matricNoValidator,
                                        MdiIcons.cardAccountDetailsOutline)),
                                SizedBox(width: horizontalSpace),
                                Flexible(
                                    child: buildDropDownButton(
                                        'Gender',
                                        MdiIcons.genderMaleFemale,
                                        genderGroup,
                                        genderController)),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            buildphoneForm(HPnoController, phoneNoValidator),
                            const SizedBox(height: 20.0),
                            buildDateForm(dobController, dobValidator),

                            //address here
                            buildDivider('Address'),

                            buildForm(street1Controller, 'Street 1',
                                streetValidator, Icons.home_outlined),
                            const SizedBox(height: 20.0),
                            buildForm(street2Controller, 'Street 2',
                                streetValidator, Icons.home_outlined),
                            const SizedBox(height: 20.0),
                            buildForm(cityController, 'City', cityValidator,
                                Icons.location_city_outlined),
                            const SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    child: buildNumberForm(
                                        postcodeController,
                                        'Postcode',
                                        postcodeValidator,
                                        Icons.location_on_outlined)),
                                SizedBox(width: horizontalSpace),
                                Flexible(
                                    child: buildDropDownButton(
                                        'State',
                                        Icons.flag_outlined,
                                        stateGroup,
                                        stateController))
                              ],
                            ),
                            Text(error,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14.0)),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  UserData updatedUserdata = UserData();
                                  updatedUserdata.user_name =
                                      nameController.text;
                                  updatedUserdata.user_lastName =
                                      lastnameController.text;
                                  updatedUserdata.user_matricNo =
                                      matricController.text;
                                  updatedUserdata.user_gender =
                                      genderController.text;
                                  updatedUserdata.user_HPno =
                                      HPnoController.text;
                                  updatedUserdata.user_dob = dobController.text;
                                  updatedUserdata.user_addStreet1 =
                                      street1Controller.text;
                                  updatedUserdata.user_addStreet2 =
                                      street2Controller.text;
                                  updatedUserdata.user_addCity =
                                      cityController.text;
                                  updatedUserdata.user_addPostcode =
                                      postcodeController.text;
                                  updatedUserdata.user_addState =
                                      stateController.text;
                                  dynamic result =
                                      await UserDatabaseService(uid: user!.uid)
                                          .updateUserData(updatedUserdata)
                                          .whenComplete(() {
                                    showSuccessSnackBar(
                                        'Profile Updated Successfully !',
                                        context);
                                    Navigator.of(context).pop();
                                  }).catchError((e) => showFailedSnackBar(
                                              e.toString(), context));
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Could not update profile, please try again';
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.8,
                                    45),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ))),
              ),
            ),
          );
  }

  Row buildDivider(String label) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: const Divider(color: Colors.black38, height: 36)),
      ),
      Text(label),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: const Divider(color: Colors.black38, height: 36)),
      ),
    ]);
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
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  TextFormField buildNumberForm(TextEditingController controller,
      String hintText, String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: controller,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  TextFormField buildphoneForm(
      TextEditingController controller, String? validator(value)) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: controller,
      inputFormatters: [phoneFormatter],
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: 'Phone Number',
          prefixIcon: const Icon(Icons.phone_android_outlined)),
    );
  }

  TextFormField buildDateForm(
      TextEditingController controller, String? validator(value)) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: validator,
      onTap: () async {
        final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
            lastDate: DateTime.now());
        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
          controller.text = formattedDate;
          print('converted date$formattedDate');
        }
      },
      onSaved: (value) {
        controller.text = value!;
        print('onsaved date${controller.text}');
      },
      decoration: textInputDecoration.copyWith(
          labelText: 'Date of Birth',
          prefixIcon: const Icon(Icons.date_range_outlined)),
    );
  }

  DropdownButtonFormField2<String> buildDropDownButton(String labelText,
      IconData icon, List dropDownItem, TextEditingController controller) {
    return DropdownButtonFormField2(
      hint: Text(labelText),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, size: 24),
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
    );
  }

  String? dobValidator(value) {
    return null;
  }
}
