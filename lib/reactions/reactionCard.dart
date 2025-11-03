import 'package:flutter/material.dart';
import 'package:whatsappclone/components/kCard.dart';

import 'ReactionList.dart';

class ReactionCard extends StatelessWidget {
  final void Function(String emoji)? onReactionTap;

  const ReactionCard({super.key, this.onReactionTap});

  @override
  Widget build(BuildContext context) {
    return kCard(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: reactionList.entries.map((entry) {
              return GestureDetector(
                onTap: () => onReactionTap?.call(entry.value),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 24),
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
