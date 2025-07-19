
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/contacts/contacts.dart';
import 'package:whatsappclone/features/recentChats/recentChat.dart';
import 'package:whatsappclone/features/welcomeScreen/welcome.dart';

import '../Settings/SettingsScreen.dart';

class Bottomnavbar extends StatefulWidget {
  final void Function(ThemeData, ThemeMode)? onThemeChange;
  const Bottomnavbar({super.key, this.onThemeChange});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _selectedIndex = 2;
  final _widgetOptions = [];
  final FirebaseService service = FirebaseService();
  @override
  void initState() {
    super.initState();
    _widgetOptions.addAll([
      Contacts(),
      RecentChatsScreen(),
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
        bottomNavigationBar: StreamBuilder<int>(
          stream: service.getTotalUnreadCount(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            final unreadCount = snapshot.data ?? 0;

            return BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: icons.contacts,
                  label: 'Contacts',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      icons.chats,
                      if (unreadCount > 0)
                        Positioned(
                          right: -12,
                          top: -15,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 23, minHeight: 25),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
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
            );
          },
        ),
      ),
    );
  }
}
