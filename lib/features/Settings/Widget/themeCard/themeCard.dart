import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/dividerWidget.dart';

import '../../../../components/iconButton.dart';
import '../../../../components/popUpMenu.dart';
import '../../../../core/appTheme.dart';
import '../../../../core/icons.dart';
import '../../../../enums/enums.dart';
import '../../../../globalState.dart';
import '../../SettingsScreen.dart';

class themeCard extends StatefulWidget {
  const themeCard({
    super.key,
    required this.mounted,
    required this.widget,
  });

  final bool mounted;
  final SettingScreen widget;

  @override
  State<themeCard> createState() => _themeCardState();
}

class _themeCardState extends State<themeCard> {
  Color themeColor = Colors.white; // Default theme color

  void openColorPicker() async {
    final selectedColor = await Navigator.of(context).pushNamed("pickColor");

    if (selectedColor != null && selectedColor is Color) {
      setState(() {
        themeColor = selectedColor; // Update the theme color dynamically
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          kListTile(
              title: Text("Theme"),
              trailing: MyPopUpMenu(
                  icon: icons.arrowForward,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<myPop>(
                        value: myPop.off,
                        child: Text(("Off")),
                      ),
                      PopupMenuItem<myPop>(
                        value: myPop.darkTheme ,
                        child: Text(("Dark Theme")),
                      ),
                      PopupMenuItem<myPop>(
                        value: myPop.system,
                        child: Text(("System theme")),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (!mounted) return;
                    if (value == myPop.off) {
                      widget.widget.onThemeChange?.call(myTheme.appTheme);
                    } else if (value == myPop.darkTheme) {
                      widget.widget.onThemeChange?.call(myTheme.darkTheme);
                    } else {
                      widget.widget.onThemeChange?.call(ThemeData());
                    }
                  }
              )
          ),
          divider(),
          GestureDetector(
            onTap: () async {
              final selectedColor = await Navigator.of(context).pushNamed("pickColor");
              if (selectedColor != null && selectedColor is Color) {
                // Update the global ValueNotifier
                selectedThemeColor.value = selectedColor;
              }
            },
            child: kListTile(
              title: Text("Chat Theme"),
              trailing: kIconButton(
                onPressed: () {},
                myIcon: icons.colors,
              ),
            ),
          )

        ],
      ),
    );
  }
}
