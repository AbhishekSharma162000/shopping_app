import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {

  final int selectedTab;
  final Function(int) tabPressed;

  BottomTabs({this.selectedTab, this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;



  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;
    return Container(

      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            spreadRadius: 1,
            blurRadius: 30
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(icon: Icons.home_outlined,
            selected: _selectedTab == 0 ? true : false,
            onPressed: (){
            setState(() {
              widget.tabPressed(0);
            });
            },
          ),
          BottomTabBtn(icon: Icons.search,
            selected: _selectedTab == 1? true : false,
            onPressed: (){
              setState(() {
                widget.tabPressed(1);
              });
            },
          ),
          BottomTabBtn(icon: Icons.bookmark_border_outlined ,
            selected: _selectedTab == 2 ? true : false,
            onPressed: (){
              setState(() {
                widget.tabPressed(2);
              });
            },
          ),
          BottomTabBtn(icon: Icons.logout ,
            selected: _selectedTab == 3 ? true : false,
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {

  final IconData icon;
  final bool selected;
  final Function onPressed;

  const BottomTabBtn({this.icon, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {

    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color:  _selected ? Theme.of(context).accentColor : Colors.transparent,
              width: 2
            )
          )
        ),
        child: Icon(
          icon,
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
    );
  }
}

