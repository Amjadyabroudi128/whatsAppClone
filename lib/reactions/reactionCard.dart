import 'package:flutter/material.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'ReactionList.dart';

class ReactionCard extends StatelessWidget {
  final void Function(String emoji)? onReactionTap;

  const ReactionCard({super.key, this.onReactionTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: kCard(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: reactionList.entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onReactionTap?.call(entry.value);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.15),
                    ),
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
