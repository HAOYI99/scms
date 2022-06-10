import 'package:flutter/material.dart';
import 'package:scms/services/auth.dart';
import 'package:scms/shared/constants.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isObsure = true;

  final TextEditingController firstNameController = TextEditingController(text: 'test');
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController matricNoController = TextEditingController();
  final TextEditingController PhoneNoController = TextEditingController();
  final TextEditingController GenderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Edit Profile Information',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
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
                        
                        const SizedBox(height: 20.0),
                        
                        const SizedBox(height: 20.0),
                        
                        const SizedBox(height: 20.0),
                        
                        const SizedBox(height: 20.0),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     if (_formKey.currentState!.validate()) {
                        //       setState(() => isLoading = true);
                        //       dynamic result =
                        //           await _auth.registerWithEmailAndPassword(
                        //               emailController.text,
                        //               passwordController.text,
                        //               firstNameController.text,
                        //               lastNameController.text);
                        //       if (result == null) {
                        //         setState(() {
                        //           error = 'Please supply a valid email';
                        //           isLoading = false;
                        //         });
                        //       }
                        //     }
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     fixedSize: Size(
                        //         MediaQuery.of(context).size.width * 0.8, 45),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20.0)),
                        //   ),
                        //   child: const Text(
                        //     'Sign Up',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // ),
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


  TextFormField buildTextForm(TextEditingController controller, String hintText,
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
          hintText: hintText, prefixIcon: Icon(Icons.account_circle_rounded)),
    );
  }
  
}
