import 'package:flutter/material.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/contacts/contacts.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    Contacts(),
    Text("chats"),
    Text('Search Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: icons.contacts,
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: icons.chats,
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: icons.settings,
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: myColors.selecteditem,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
