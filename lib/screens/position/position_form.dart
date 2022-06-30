import 'package:flutter/material.dart';
import 'package:scms/models/access_right.dart';
import 'package:scms/models/club.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

class PositionForm extends StatefulWidget {
  final String club_ID;
  final PositionData? positionData;
  final List<accessRight>? accessData;
  final List<function>? functionList;
  PositionForm(
      {Key? key,
      required this.club_ID,
      this.positionData,
      this.accessData,
      required this.functionList})
      : super(key: key);
  @override
  State<PositionForm> createState() => _PositionFormState();
}

class _PositionFormState extends State<PositionForm> {
  final _formKey = GlobalKey<FormState>();
  List<accessRight> tempAccessRight = [];
  bool isLoading = false;
  bool isFirstLoad = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController seqController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ListView buildListFunction() {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.functionList!.length,
        itemBuilder: (context, index) {
          return rowItem(widget.positionData, widget.functionList![index]);
        },
      );
    }

    if (isFirstLoad && widget.positionData != null) {
      tempAccessRight.addAll(widget.accessData!);
      nameController.text = widget.positionData!.position_name!;
      seqController.text = widget.positionData!.seq_number!;
      isFirstLoad = false;
    }
    if (isLoading) {
      return loadingIndicator();
    } else {
      return Scaffold(
        appBar: buildAppBar(context,
            widget.positionData == null ? 'Create Position' : 'Edit Position'),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      buildForm(nameController, 'Position Name',
                          positionNameValidator, Icons.group_add),
                      const SizedBox(height: 20.0),
                      buildNumberForm(
                          seqController, 'Sequence Number', Icons.numbers),
                    ],
                  ),
                ),
              ),
              Wrap(children: [buildListFunction()]),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.positionData == null) {
                      setState(() => isLoading = true);
                      PositionData newposition = PositionData(
                          position_name: nameController.text,
                          seq_number: seqController.text);
                      await ClubDatabaseService(cid: widget.club_ID)
                          .createPosition(newposition, tempAccessRight)
                          .whenComplete(() {
                        Navigator.of(context).pop();
                        showSuccessSnackBar('Position Created', context);
                      }).catchError(
                              (e) => showFailedSnackBar(e.toString(), context));
                    } else {
                      setState(() => isLoading = true);
                      PositionData newposition = PositionData(
                          position_name: nameController.text,
                          seq_number: seqController.text);
                      await ClubDatabaseService(
                        pid: widget.positionData!.position_ID,
                      )
                          .updatePosition(newposition, tempAccessRight)
                          .whenComplete(() {
                        Navigator.of(context).pop();
                        showSuccessSnackBar('Position Updated', context);
                      }).catchError(
                              (e) => showFailedSnackBar(e.toString(), context));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      );
    }
  }

  accessRight? getAccessData(
      accessRight? accessData, List<function> functionList) {
    for (var i = 0; i < functionList.length; i++) {
      if (functionList[i].function_ID == accessData!.function_ID) {
        return accessData;
      }
    }
    return null;
  }

  TextFormField buildForm(TextEditingController controller, String hintText,
      String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
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

  TextFormField buildNumberForm(
      TextEditingController controller, String hintText, IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      controller: controller,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  String? positionNameValidator(value) =>
      value!.isEmpty ? 'Position Name is required !' : null;

  Widget rowItem(
    PositionData? positionData,
    function? functionData,
  ) {
    //split the code
    final accessRightCode = functionData!.access_right_code!.split(',');

    final Map<int, String> accessCode = {
      for (int i = 0; i < accessRightCode.length; i++) i: accessRightCode[i]
    };

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 20.0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: checkHaveFunction(functionData.function_ID),
                  onChanged: (bool? value) {
                    setState(() {
                      addDataIntoTempAccessDataForFunction(
                          functionData.function_ID, value);
                    });
                  },
                ),
                Text('${functionData.function_name}'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        hasAccessCode(
                          functionData.function_ID!,
                          accessCode[0],
                        ),
                        Text(accessCode[0] ?? '')
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        hasAccessCode(
                          functionData.function_ID!,
                          accessCode[1],
                        ),
                        Text(accessCode[1] ?? '')
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        hasAccessCode(
                          functionData.function_ID!,
                          accessCode[2],
                        ),
                        Text(accessCode[2] ?? '')
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        hasAccessCode(
                          functionData.function_ID!,
                          accessCode[3],
                        ),
                        Text(accessCode[3] ?? '')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget hasAccessCode(String function_ID, accessCode) {
    if (accessCode != null) {
      return Checkbox(
        value: checkCurrentData(function_ID, accessCode),
        onChanged: (bool? value) {
          setState(() {
            addDataIntoTempAccessData(function_ID, accessCode, value);
          });
        },
      );
    }
    return Container();
  }

  bool checkHaveFunction(function_ID) {
    var datas = tempAccessRight.where((r) => r.function_ID == function_ID);
    return datas.length > 0 ? true : false;
  }

  void addDataIntoTempAccessDataForFunction(functionId, isChecked) {
    if (isChecked) {
      var function =
          widget.functionList!.where((r) => r.function_ID == functionId).first;
      var data = accessRight(
          function_ID: functionId,
          access_right_code: function.access_right_code);
      tempAccessRight.add(data);
    } else {
      var data =
          tempAccessRight.where((r) => r.function_ID == functionId).first;
      tempAccessRight.remove(data);
    }
  }

  void addDataIntoTempAccessData(functionId, String accessCode, isChecked) {
    var currentAccessRight;
    if (tempAccessRight.length > 0) {
      var list = tempAccessRight.where((r) => r.function_ID == functionId);
      currentAccessRight = list.length > 0 ? list.first : null;
    }
    if (isChecked) {
      if (currentAccessRight != null) {
        currentAccessRight.access_right_code =
            '${currentAccessRight.access_right_code!}, $accessCode';
      } else {
        var data =
            accessRight(function_ID: functionId, access_right_code: accessCode);
        tempAccessRight.add(data);
      }
    } else {
      if (currentAccessRight != null) {
        final accessRightCode =
            currentAccessRight.access_right_code!.split(',');
        if (accessRightCode.length == 1) {
          tempAccessRight.remove(currentAccessRight);
        } else {
          accessRightCode.remove(accessCode);
          String text = accessRightCode.join(",");
          currentAccessRight.access_right_code = text.replaceAll(' ', '');
        }
      }
    }
  }

  bool checkCurrentData(functionId, accessCode) {
    if (tempAccessRight == null || tempAccessRight.length <= 0) {
      return false;
    } else {
      var list = tempAccessRight.where((r) => r.function_ID == functionId);
      var currenctAccessRight =
          (list != null && list.length > 0) ? list.first : null;
      if (currenctAccessRight == null) {
        return false;
      } else {
        final accessRightCode =
            currenctAccessRight.access_right_code!.split(',');

        for (var arc = 0; arc < accessRightCode.length; arc++) {
          if (accessRightCode[arc].trim() == accessCode) return true;
        }
      }
    }
    return false;
  }
}
