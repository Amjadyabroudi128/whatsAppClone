import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';

class Imagescreen extends StatefulWidget {
  final String date;
  final senderName;
  final String time;
  const Imagescreen({super.key, required this.date, required this.senderName, required this.time});

  @override
  State<Imagescreen> createState() => _ImagescreenState();
}

class _ImagescreenState extends State<Imagescreen> {
  final TextStyle dates = TextStyle(fontSize: 13);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text("${widget.senderName}", style: dates,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.date, style: dates,),
                BoxSpacing(mWidth: 7,),
                Text(widget.time, style: dates,)
              ],
            )
            // Text(widget.date, style: TextStyle(fontSize: 13),),
          ],
        ),
      ),
    );
  }
}
