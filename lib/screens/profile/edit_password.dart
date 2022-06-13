import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scms/screens/authenticate/sign_in.dart';
import 'package:scms/services/auth.dart';
import 'package:scms/shared/constants.dart';

class changePassword extends StatefulWidget {
  String user_email;
  changePassword({Key? key, required this.user_email}) : super(key: key);

  @override
  State<changePassword> createState() => changePasswordState();
}

class changePasswordState extends State<changePassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool isLoading = false;
  bool isObsure = true;
  bool checkCurrentPassword = true;
  String error = '';

  final TextEditingController oldPasswordController =
      new TextEditingController();
  final TextEditingController newPasswordController =
      new TextEditingController();
  final TextEditingController confirmPasswordController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Change Password'),
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
                        buildPasswordForm(oldPasswordController, 'Old Password',
                            oldPasswordValidator, TextInputAction.next),
                        const SizedBox(height: 20.0),
                        buildPasswordForm(newPasswordController, 'New Password',
                            newPasswordValidator, TextInputAction.next),
                        const SizedBox(height: 20.0),
                        buildPasswordForm(
                            confirmPasswordController,
                            'Confirm Password',
                            confirmPasswordValidator,
                            TextInputAction.done),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            checkCurrentPassword = await _auth.validatePassword(
                                widget.user_email, oldPasswordController.text);

                            if (_formKey.currentState!.validate() &&
                                checkCurrentPassword) {
                              setState(() => isLoading = true);
                              await _auth
                                  .changePassword(newPasswordController.text)
                                  .then((value) async {
                                Navigator.of(context).pop();
                                showSuccessSnackBar(
                                    'Password Changed Successfully', context);
                                await _auth.signOut().then((value) {
                                      showSuccessSnackBar(
                                          'Please Sign In Again', context);
                                    }).catchError((e) {
                                      showFailedSnackBar(e.toString(), context);
                                    });
                              }).catchError((e) {
                                showFailedSnackBar(e.toString(), context);
                              });
                            } else {
                              setState(() {
                                error = 'Something Wrong';
                                isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.8, 45),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                          child: const Text(
                            'Confirm',
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

  TextFormField buildPasswordForm(
      TextEditingController controller,
      String hintText,
      String? validator(value),
      TextInputAction textInputAction) {
    return TextFormField(
      controller: controller,
      obscureText: isObsure,
      textInputAction: textInputAction,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText,
          prefixIcon: const Icon(Icons.vpn_key_sharp),
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObsure = !isObsure;
                  if (textFieldFocusNode.hasPrimaryFocus) return;
                  textFieldFocusNode.canRequestFocus = false;
                });
              },
              child: Icon(isObsure ? Icons.visibility : Icons.visibility_off))),
    );
  }

  String? oldPasswordValidator(value) {
    if (value.isEmpty) {
      return 'Current password is required';
    }
    if (checkCurrentPassword) {
      return null;
    } else {
      return 'Please double check your current password';
    }
  }

  String? newPasswordValidator(value) {
    if (value.isEmpty) {
      return 'New password is required';
    }
    if (oldPasswordController.text.compareTo(value) == 0) {
      return 'New Password Cannot Same As Old Password';
    }
  }

  String? confirmPasswordValidator(value) {
    if (value.isEmpty) {
      return 'Confirm password is required';
    }
    if (newPasswordController.text.compareTo(value) == 0) {
      return null;
    } else {
      return 'Confirm Password Must Same As New Password';
    }
  }
}
