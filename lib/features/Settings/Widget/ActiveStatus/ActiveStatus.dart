import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/kCard.dart';

class ActiveStatus extends StatelessWidget {
  const ActiveStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Status"),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BoxSpacing(myHeight: 18),
            Text(
              "Who can see when I am online",
              style: TextStyle(color: Colors.grey[400], fontSize: 17),
              ),

            const BoxSpacing(myHeight: 10),
            const kCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("EveryOne"),
                    divider(),
                    Text("NoBody")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _StatusOption extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool isSelected;
//
//   const _StatusOption({
//     required this.label,
//     required this.icon,
//     this.isSelected = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return InkWell(
//       onTap: () {}, // add logic later
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
//         child: Row(
//           children: [
//             Icon(icon, color: isSelected ? theme.colorScheme.primary : Colors.grey),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isSelected ? theme.colorScheme.primary : Colors.black87,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                 ),
//               ),
//             ),
//             if (isSelected)
//               Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 22),
//           ],
//         ),
//       ),
//     );
//   }
// }
