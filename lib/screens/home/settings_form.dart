import 'package:brew_crew/Shared/constants.dart';
import 'package:brew_crew/Shared/loading.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    //Menu that appears in the BottomSheet at home.dart
    //Create a form to enter the name, choose the sugar, and select the strength
    //Within the form create a column to organize elements inside it, like in a linear layout.
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your brew.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: userData?.name,
                    decoration: textInputDecoration('Enter a name'),
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration('Select amount of sugar'),
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _currentSugars = value as String?);
                    },
                  ),
                  //Slider
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Slider(
                      value:
                          (_currentStrength ?? userData?.strength)!.toDouble(),
                      activeColor: Colors.brown[_currentStrength ?? 100],
                      inactiveColor: Colors.brown[_currentStrength ?? 100],
                      min: 100,
                      max: 900,
                      divisions: 8,
                      onChanged: (val) => setState(() {
                        _currentStrength = val.round();
                      }),
                    ),
                  ),
                  //button
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await DatabaseService(uid: user.uid).updateUserData(
                                _currentSugars ?? userData?.sugars,
                                _currentName ?? userData?.name,
                                _currentStrength ?? userData?.strength);
                            Navigator.pop(context);
                          }
                        }),
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
