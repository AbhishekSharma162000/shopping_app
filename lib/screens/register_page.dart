import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppin_app/screens/login_page.dart';
import 'package:shoppin_app/widgets/custom_btn.dart';
import 'package:shoppin_app/widgets/custom_input.dart';

import '../constants.dart';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  //create a new user account
  Future<String> _createAccount() async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password'){
        return "The password provided is too weak";
      } else if (e.code == 'email-already-in-use'){
        return "The account is already exists for that email";
      }
      return e.message;
    } catch(e){
      return e.toString();
    }
  }

  void _submitForm() async {
    // set the form to loading state
    setState(() {
      _registerFormLoading = true;
    });

    // Run the create account method
    String _createAccountFeedback = await _createAccount();

    // if the string is not null, we got error while create account
    if(_createAccountFeedback != null){
      _alertDialogBuilder(_createAccountFeedback);

      // set the form to regular state [not loading]
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      // the String was null, user is logged in
      Navigator.pop(context);
    }


  }

  // Default form loading state
  bool _registerFormLoading = false;

  // Form input field values
  String _registerEmail = "";
  String _registerPassword = "";

  // Focus Node for input field
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 24),
                  child: Text("Create A New Account",
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                ),
                Column(
                  children: [
                    CustomInput(
                      hintText: "Email",
                      onChanged: (value){
                        _registerEmail = value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,

                    ),
                    CustomInput(
                      hintText: "Password",
                      onChanged: (value){
                        _registerPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value){
                        _submitForm();
                      },
                    ),
                    CustomBtn(
                      text: "Create New Account",
                      onPressed: (){
                        _submitForm();
                      },
                     isLoading : _registerFormLoading,

                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CustomBtn(
                    text: "Back To Login",
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    outlineBtn: true,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
