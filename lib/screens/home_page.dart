import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants.dart';
import 'package:shopping_app/screens/bottom_tabs.dart';
import 'package:shopping_app/services/firebase_services.dart';
import 'package:shopping_app/tabs/home_tab.dart';
import 'package:shopping_app/tabs/saved_tab.dart';
import 'package:shopping_app/tabs/search_tab.dart';

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseServices _firebaseServices = FirebaseServices();

  PageController _tabsPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabsPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomTabs(selectedTab: _selectedTab,
      tabPressed: (num){
        _tabsPageController.animateToPage(
            num,
            duration: Duration(microseconds: 300),
            curve: Curves.easeOutCubic);
      },
      ),

      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              controller: _tabsPageController,
                onPageChanged: (num){
                 setState(() {
                   _selectedTab = num;
                 });
                },
                children: [
                  HomeTab(),
                 SearchTab(),
                 SaveTab(),
                ],
            ),
          ),

        ],
      )
    );
  }
}
