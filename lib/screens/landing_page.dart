import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/screens/home_page.dart';
import 'package:shopping_app/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder:  (context, snapshot){

          //If snapshot has error
          if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.hasError}"),
              ),
            );
          }

          // Connection initalized - Firebase App is runnig
          if(snapshot.connectionState == ConnectionState.done){

            //StreamBuilder can check the login state live
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, streamsnapshot){
                //If stream_snapshot has error
                if(streamsnapshot.hasError){
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${streamsnapshot.hasError}"),
                    ),
                  );
                }

                // connection state active - Do the user login check inside
                // if statement
                if(streamsnapshot.connectionState == ConnectionState.active){

                  // Get the user
                  User _user = streamsnapshot.data;

                  // if the user is null, we're not logged in
                  if(_user == null){
                    return LoginPage();
                  }else{
                    return HomePage();
                  }
                }

                // Checking the auth state - Loading
                return Scaffold(
                  body: Center(
                    child: Text("Checking Authentication...."),
                  ),
                );
              },
            );
          }

          // Connecting to Firebase - Loading
          return Scaffold(
            body: Center(
              child: Text("Initialization App.."),
            ),
          );
        }
    );
  }
}