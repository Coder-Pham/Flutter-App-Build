import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../mixins/validation.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final formKey = GlobalKey<FormState>();
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.only(top: 25.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            emailField(),
            passwordField(),
            Container(margin: EdgeInsets.only(top: 20.0)),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'you@example.com',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (String value) {
        email = value;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Password',
      ),
      obscureText: true,
      validator: validatePassword,
      onSaved: (String value) {
        password = value;
      },
    );
  }

  Widget submitButton() {
    return RaisedButton(
      elevation: 10.0,
      child: Text('Submit!'),
      color: Colors.cyan[200],
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
        }
      },
    );
  }
}
