
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/kCard.dart';
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
    return kCard(
      child: Column(
        children: [
          kListTile(
              title: Text("Theme"),
              trailing: MyPopUpMenu(
                  icon: icons.arrowForward(context),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<myPop>(
                        value: myPop.off,
                        child: Text(("Off")),
                      ),
                      const PopupMenuItem<myPop>(
                        value: myPop.darkTheme ,
                        child: Text(("Dark Theme")),
                      ),
                      const PopupMenuItem<myPop>(
                        value: myPop.system ,
                        child: Text(("System")),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (!mounted) return;
                    if (value == myPop.off) {
                      widget.widget.onThemeChange?.call(MyTheme.appTheme, ThemeMode.light);
                    } else if (value == myPop.darkTheme) {
                      widget.widget.onThemeChange?.call(MyTheme.darkTheme, ThemeMode.dark);
                    } else{
                      widget.widget.onThemeChange?.call(MyTheme.appTheme, ThemeMode.system);
                    }
                  }
              )
          ),
          const divider(),
          GestureDetector(
            onTap: () async {
              final selectedColor = await Navigator.of(context).pushNamed("pickColor");
              if (selectedColor != null && selectedColor is Color) {
                // Update the global ValueNotifier
                selectedThemeColor.value = selectedColor;
              }
            },
            child: kListTile(
              title: const Text("Chat Theme"),
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
