import 'package:flutter/material.dart';
import 'package:scms/services/auth.dart';
import 'package:scms/shared/constants.dart';

class Register extends StatefulWidget {
  final toggleView;

  const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool isLoading = false;
  bool isObsure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Registration',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  widget.toggleView();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.blue),
              ),
            ),
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
                        buildEmailForm(
                            emailController, 'Email', emailValidator),
                        const SizedBox(height: 20.0),
                        buildNameForm(firstNameController, 'First Name',
                            firstNameValidator),
                        const SizedBox(height: 20.0),
                        buildNameForm(
                            lastNameController, 'Last Name', lastNameValidator),
                        const SizedBox(height: 20.0),
                        buildPasswordForm(passwordController, 'Password',
                            passwordValidator, TextInputAction.next),
                        const SizedBox(height: 20.0),
                        buildPasswordForm(
                            confirmPasswordController,
                            'Confirm Password',
                            confirmPasswordValidator,
                            TextInputAction.done),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      emailController.text,
                                      passwordController.text,
                                      firstNameController.text,
                                      lastNameController.text);
                              if (result == null) {
                                setState(() {
                                  error = 'Please supply a valid email';
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
                            'Sign Up',
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

  TextFormField buildEmailForm(TextEditingController controller,
      String hintText, String? validator(value)) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: const Icon(Icons.mail_sharp)),
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

  TextFormField buildNameForm(TextEditingController controller, String hintText,
      String? validator(value)) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: const Icon(Icons.account_circle_rounded)),
    );
  }

  String? confirmPasswordValidator(value) {
    if (value.isEmpty) {
      return 'Confirm password is required';
    }
    if (passwordController.text.compareTo(value) == 0) {
      return null;
    } else {
      return 'Confirm Password Must Same As Password';
    }
  }
}
