import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppin_app/constants.dart';
import 'package:shoppin_app/screens/register_page.dart';
import 'package:shoppin_app/widgets/custom_btn.dart';
import 'package:shoppin_app/widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
  Future<String> _loginAccount() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
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
      _loginFormLoading = true;
    });

    // Run the create account method
    String _loginFeedback = await _loginAccount();

    // if the string is not null, we got error while create account
    if(_loginFeedback != null){
      _alertDialogBuilder(_loginFeedback);

      // set the form to regular state [not loading]
      setState(() {
        _loginFormLoading = false;
      });
    }


  }

  // Default form loading state
  bool _loginFormLoading = false;

  // Form input field values
  String _loginEmail = "";
  String _loginPassword = "";

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
              child: Text("Welcome User,\nLogin to your account",
              textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hintText: "Email",
                  onChanged: (value){
                    _loginEmail = value;
                  },
                ),
                CustomInput(
                  hintText: "Password",
                  onChanged: (value){
                    _loginPassword = value;
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  onSubmitted: (value){
                    _submitForm();
                  },
                ),
                CustomBtn(
                  text: "Login",
                  onPressed: (){
                    _submitForm();
                  },
                  isLoading: _loginFormLoading,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CustomBtn(
                text: "Create New Account",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => RegisterPage()
                  ));
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
