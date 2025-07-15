import 'package:flutter/material.dart';

/// A form widget for creating or editing a single flashcard.
/// It allows users to input a question and answer, and supports dismissal.
class CardFormWidget extends StatefulWidget {
  CardFormWidget({
    super.key,
    this.initialAnswer,
    this.initialQuestion,
    this.cardId,
    this.isUpdated,
  });

  /// Controller for the question text field
  final TextEditingController questionFieldController = TextEditingController();

  /// Controller for the answer text field
  final TextEditingController answerFieldController = TextEditingController();

  /// Initial values passed to pre-fill the form (used when editing)
  final String? initialQuestion;
  final String? initialAnswer;

  /// Unique ID of the card (used for tracking and dismissing)
  final String? cardId;

  /// Indicates whether this card has been updated
  bool? isUpdated;

  @override
  State<CardFormWidget> createState() => _CardFormWidgetState();
}

class _CardFormWidgetState extends State<CardFormWidget> {
  var counter = 0; // Not used currently, but could be useful for debugging

  @override
  void initState() {
    // Pre-fill the form fields with initial values if available
    if (widget.initialQuestion != null) {
      widget.questionFieldController.text = widget.initialQuestion!;
    }
    if (widget.initialAnswer != null) {
      widget.answerFieldController.text = widget.initialAnswer!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String?>(widget.cardId), // Ensures unique identification
      onDismissed: (direction) {
        // Clear the form on dismissal and mark as updated
        widget.isUpdated = true;
        widget.questionFieldController.text = "";
        widget.answerFieldController.text = "";
      },
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: 600), // You can adjust this
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(10.0),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  // Label for Question input
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: const Text('Question'),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      if (value == widget.questionFieldController.text) {
                        widget.isUpdated = false;
                      } else {
                        widget.isUpdated = true;
                      }
                    },
                    controller: widget.questionFieldController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 3000,
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: const Text('Answer'),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      if (value == widget.questionFieldController.text) {
                        widget.isUpdated = false;
                      } else {
                        widget.isUpdated = true;
                      }
                    },
                    controller: widget.answerFieldController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 3000,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
