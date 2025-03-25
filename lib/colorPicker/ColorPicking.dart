import 'package:flutter/material.dart';

import '../colorList/colorsList.dart';

class Colorpicking extends StatefulWidget {
  const Colorpicking({super.key});

  @override
  _ColorpickingState createState() => _ColorpickingState();
}

class _ColorpickingState extends State<Colorpicking> {
  int? selectedIndex; // To track the selected index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        centerTitle: true,
        title: Text("chat color", style: TextStyle(fontSize: 18, color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: GridView.builder(
          itemCount: colorNames.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns
            mainAxisExtent: 100, // Height of each grid item
          ),
          itemBuilder: (context, index) {
            Color color = colorNames.keys.elementAt(index);
            String colorName = colorNames[color]!;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index; // Update the selected index
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30, // Size of the CircleAvatar
                        backgroundColor: color,
                      ),
                      if (selectedIndex == index) // Show tick only if selected
                        const Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 40,
                        ),
                    ],
                  ),
                   SizedBox(height: 10),
                  Text(
                    colorName,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}