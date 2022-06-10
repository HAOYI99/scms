import 'package:flutter/material.dart';
import 'package:scms/services/auth.dart';
import 'package:scms/shared/constants.dart';

class SignIn extends StatefulWidget {
  final toggleView;

  SignIn({Key? key, this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool isLoading = false;
  bool isObsure = true;

  //text field state
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        const Text(
                          'Welcome to SCMS',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),
                        SizedBox(height: 20.0),
                        buildEmailForm(emailController, 'Email'),
                        SizedBox(height: 20.0),
                        buildPasswordForm(passwordController, 'Password'),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);
                              dynamic result =
                                  await _auth.signInWithEmailAndPassword(
                                      emailController.text,
                                      passwordController.text);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not sign in with those credentials';
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
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: const TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Don't have an account ? "),
                            GestureDetector(
                              onTap: () {
                                widget.toggleView();
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  TextFormField buildEmailForm(
      TextEditingController controller, String hintText) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: emailValidator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          hintText: hintText, prefixIcon: const Icon(Icons.mail_sharp)),
    );
  }

  TextFormField buildPasswordForm(
      TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      obscureText: isObsure,
      textInputAction: TextInputAction.done,
      validator: passwordValidator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          hintText: hintText,
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
}
