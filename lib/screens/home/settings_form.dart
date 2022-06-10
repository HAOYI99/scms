import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/user.dart';
import 'package:scms/services/database.dart';
import 'package:scms/shared/constants.dart';

class SettingsForm extends StatefulWidget {
  SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData =  snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                // children: <Widget>[
                //   Text('Update your brew settings',
                //       style: TextStyle(fontSize: 18.0)),
                //   SizedBox(
                //     height: 20.0,
                //   ),
                //   TextFormField(
                //     initialValue: userData!.user_ID,
                //     decoration: textInputDecoration,
                //     validator: (value) =>
                //         value!.isEmpty ? 'Please enter a name' : null,
                //     onChanged: (value) => setState(() => _currentName = value),
                //   ),
                //   SizedBox(
                //     height: 20.0,
                //   ),
                //   //dropdown
                //   DropdownButtonFormField(
                //     decoration: textInputDecoration,
                //     value: _currentSugars ?? userData.sugar,
                //     items: sugars.map((sugar) {
                //       return DropdownMenuItem(
                //           value: sugar, child: Text('$sugar sugars'));
                //     }).toList(),
                //     onChanged: (value) =>
                //         setState(() => _currentSugars = value.toString()),
                //   ),
                //   //slider
                //   Slider(
                //     min: 100.0,
                //     max: 900.0,
                //     divisions: 8,
                //     value: (_currentStrength ?? userData.strength)!.toDouble(),
                //     activeColor: Colors.brown[_currentStrength ?? 100],
                //     inactiveColor: Colors.brown[_currentStrength ?? 100],
                //     onChanged: (value) =>
                //         setState(() => _currentStrength = value.round()),
                //   ),
                //   ElevatedButton(
                //     onPressed: () async {
                //       if(_formKey.currentState!.validate()){
                //         await DatabaseService(uid: user.uid).updateUserData(
                //           _currentSugars ?? userData.sugar.toString(), 
                //           _currentName ?? userData.name.toString(), 
                //           _currentStrength ?? userData.strength!.toInt(),
                //         );
                //         Navigator.pop(context);
                //       }
                //       // updateUserData();
                //     },
                //     style: ButtonStyle(
                //         backgroundColor:
                //             MaterialStateProperty.all(Colors.pink[400])),
                //     child:
                //         Text('Update', style: TextStyle(color: Colors.white)),
                //   )
                // ],
              ),
            );
          } else {
            return loadingIndicator();
          }
        });
  }
}
