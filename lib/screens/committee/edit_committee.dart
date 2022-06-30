import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

class EditCommittee extends StatefulWidget {
  List<PositionData> positionList;
  CommitteeData thisMemberData;
  UserData userData;
  EditCommittee(
      {Key? key,
      required this.positionList,
      required this.thisMemberData,
      required this.userData})
      : super(key: key);

  @override
  State<EditCommittee> createState() => _EditCommitteeState();
}

class _EditCommitteeState extends State<EditCommittee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPositionController = TextEditingController();
  TextEditingController newPostionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isFirstLoad = true;
  bool isLoading = false;
  String newPositionID = '';
  @override
  Widget build(BuildContext context) {
    if (isFirstLoad) {
      nameController.text =
          '${widget.userData.user_name!} ${widget.userData.user_lastName}';
      for (var i = 0; i < widget.positionList.length; i++) {
        if (widget.thisMemberData.position_ID ==
            widget.positionList[i].position_ID) {
          oldPositionController.text = widget.positionList[i].position_name!;
        }
      }
    }
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(
                context, "Edit ${widget.userData.user_name}'s Position"),
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
                          buildDisableForm(
                              nameController, "Member's Name", Icons.person),
                          const SizedBox(height: 20.0),
                          buildDisableForm(oldPositionController,
                              'Old Position', Icons.work_history),
                          const SizedBox(height: 20.0),
                          buildDropDownButton('New Position', Icons.work,
                              widget.positionList, newPostionController),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isLoading = true);
                                await ClubDatabaseService(
                                        cmid:
                                            widget.thisMemberData.committee_ID)
                                    .updateCommitteeData(newPositionID)
                                    .whenComplete(() {
                                  showSuccessSnackBar(
                                      'Committee Updated Successfully !',
                                      context);
                                  Navigator.of(context).pop();
                                }).catchError((e) => showFailedSnackBar(
                                        e.toString(), context));
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
                      ))),
            )),
          );
  }

  TextFormField buildDisableForm(
      TextEditingController controller, String hintText, IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.text,
      enabled: false,
      textInputAction: TextInputAction.next,
      controller: controller,
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  DropdownButtonFormField2<String> buildDropDownButton(
      String labelText,
      IconData icon,
      List<PositionData> dropDownItem,
      TextEditingController controller) {
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
      validator: (value) => value == null ? 'Must Select A Position' : null,
      items: dropDownItem
          .map((item) => DropdownMenuItem<String>(
                value: item.position_ID,
                child: Text(
                  item.position_name!,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      onChanged: (value) {
        controller.text = value!;
        newPositionID = value.toString();
        print(newPositionID);
      },
    );
  }
}
