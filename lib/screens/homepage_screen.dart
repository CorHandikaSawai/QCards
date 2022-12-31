import 'package:flutter/material.dart';
import 'package:free_quizme/screens/create_card_screen.dart';
import 'package:free_quizme/services/qa_cards_service.dart';
import 'package:free_quizme/widgets/collection_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _collectionName;
  final _formKey = GlobalKey<FormState>();
  final _collectionNameTextFormController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QCards'),
        actions: [
          IconButton(
            onPressed: () => print('Profile setting'),
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(8),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () =>
                  CardService().getUserCollections(userId: 'userid'),
              child: Text('Get all Collections Test'),
            ),
            CollectionCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('New Collection'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _collectionNameTextFormController,
                      decoration: InputDecoration(
                        label: Text('Name:'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Cannot be empty!';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _collectionName =
                              _collectionNameTextFormController.text;
                        });
                        //TODO: Navigate to create cards screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateCardsScreen(
                                collectionName: _collectionName),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    child: Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Icon(Icons.library_add_rounded),
      ),
    );
  }
}
