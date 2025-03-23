import 'package:flutter/material.dart';

import '../../../components/popUpMenu.dart';
import '../../../core/appTheme.dart';
import '../../../core/icons.dart';
import '../../../enums/enums.dart';
import '../SettingsScreen.dart';

class themeCard extends StatelessWidget {
  const themeCard({
    super.key,
    required this.mounted,
    required this.widget,
  });

  final bool mounted;
  final SettingScreen widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
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
                // if (!mounted) return; // Prevent operations if widget is not active

                if (value == myPop.off) {
                  widget.onThemeChange?.call(myTheme.appTheme);
                } else if (value == myPop.darkTheme) {
                  widget.onThemeChange?.call(myTheme.darkTheme);
                } else {
                  widget.onThemeChange?.call(ThemeData());
                }
              }
          )
      ),
    );
  }
}
