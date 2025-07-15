// Widget that represents a single collection card in the grid.
// Shows subject name, card count, and edit/delete buttons.

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:qcards/screens/edit_card_screen.dart';
import 'package:qcards/screens/homepage_screen.dart';
import 'package:qcards/screens/study_screen.dart';
import 'package:qcards/services/card_service.dart';

class CollectionCard extends StatefulWidget {
  final String subjectName;
  final String count;

  const CollectionCard({
    Key? key,
    required this.subjectName,
    required this.count,
  }) : super(key: key);

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  /// Shows a confirmation dialog for "delete" or "edit"
  void _showDialog(String action, BuildContext context, userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('${action[0].toUpperCase()}${action.substring(1)}'),
        content: Text(
            '${action[0].toUpperCase()}${action.substring(1)} this collection?'),
        actions: [
          TextButton(
            onPressed: () async {
              // Show loading while performing action
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 7),
                      Text("Loading..."),
                    ],
                  ),
                ),
              );

              if (action == 'delete') {
                // Delete and return to homepage
                await CardService()
                    .deleteCollection(
                        subjectName: widget.subjectName, userId: userId)
                    .then((_) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomePageScreen()),
                          (route) => false,
                        ));
                Navigator.of(context).pop(); // Close dialog
              }

              if (action == 'edit') {
                // Fetch cards and go to EditCardsScreen
                await CardService()
                    .getCardsFromSubject(
                        subjectName: widget.subjectName, userId: userId)
                    .then((cards) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditCardsScreen(
                              subjectName: widget.subjectName,
                              cards: cards,
                            ),
                          ),
                          (route) => false,
                        ));
              }
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // 👆 Tap opens StudyScreen for this collection
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudyScreen(
              subjectName: widget.subjectName,
              userId: FirebaseAuth.instance.currentUser!.uid,
            ),
          ),
        );
      },

      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 🧠 Collection name
                    Text(
                      widget.subjectName,
                      style: TextStyle(
                        fontSize: min(18.sp, 22),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),

                    // 🧠 Card count label
                    Text(
                      '${widget.count} ${int.parse(widget.count) > 1 ? 'cards' : 'card'}',
                      style: TextStyle(
                        fontSize: min(16.sp, 20),
                        color: Colors.grey[700],
                      ),
                    ),

                    const Spacer(), // ✅ Pushes the buttons to the bottom

                    // ✏️🗑️ Edit/Delete Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 18.sp,
                          onPressed: () => _showDialog(
                            'delete',
                            context,
                            FirebaseAuth.instance.currentUser!.uid,
                          ),
                          icon: Icon(Icons.delete,
                              color: Colors.redAccent, size: 12.sp),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 18.sp,
                          onPressed: () => _showDialog(
                            'edit',
                            context,
                            FirebaseAuth.instance.currentUser!.uid,
                          ),
                          icon: Icon(Icons.edit,
                              color: Colors.blueAccent, size: 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
