import 'package:flutter/material.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/contacts/contacts.dart';
import 'package:whatsappclone/features/recentChats/recentChat.dart';
import 'package:whatsappclone/features/welcomeScreen/welcome.dart';

import '../Settings/SettingsScreen.dart';

class Bottomnavbar extends StatefulWidget {
  final Function(ThemeData)? onThemeChange; // Theme callback
  const Bottomnavbar({super.key, this.onThemeChange});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _selectedIndex = 2;
  final _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _widgetOptions.addAll([
      Contacts(),
      recentChat(),
      SettingScreen(onThemeChange: widget.onThemeChange),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void dispose() {
    // Clean up any listeners or references here.
    super.dispose();
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

