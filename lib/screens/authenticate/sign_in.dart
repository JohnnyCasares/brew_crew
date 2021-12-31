import 'package:brew_crew/Shared/constants.dart';
import 'package:brew_crew/Shared/loading.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';

//Widget
class SignIn extends StatefulWidget {
  final Function? toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

//state object
class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign in to Brew Crew'),
              actions: [
                TextButton(
                  onPressed: () {
                    widget.toggleView!();
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    //Username Text field
                    TextFormField(
                      decoration: textInputDecoration('Email'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Password Text Field
                    TextFormField(
                      decoration: textInputDecoration('Password'),
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ characters long'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Button Sign in
                    ElevatedButton(
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth
                              .signInWithEmailAndPassowrd(email, password);
                          if (result == null) {
                            setState(() {
                              error = "Couldn't sign in with those credentials";
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
