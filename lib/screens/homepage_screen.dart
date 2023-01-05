import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:free_quizme/screens/create_card_screen.dart';
import 'package:free_quizme/services/auth_service.dart';
import 'package:free_quizme/services/card_service.dart';
import 'package:free_quizme/widgets/collection_card_widget.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String? _collectionName;
  final _formKey = GlobalKey<FormState>();
  final _collectionNameTextFormController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final cardService = Provider.of<CardService>(context);
    final authService = Provider.of<AuthenticationService>(context);
    return authService.currentUser == null
        ? const Scaffold(
            body: Center(
              child: Text(
                'You are logged out.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text('QCards'),
              actions: [
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                  icon: const Icon(Icons.person),
                ),
              ],
            ),
            body: SafeArea(
              minimum: const EdgeInsets.all(8),
              child: FutureBuilder(
                future: cardService.getUserCollections(
                    userId: FirebaseAuth.instance.currentUser!.uid),
                builder: (context,
                    AsyncSnapshot<List<Map<String, String>>> snapshot) {
                  List<Widget> subjects = [];
                  if (snapshot.hasData) {
                    for (var element in snapshot.data!) {
                      subjects.add(
                        CollectionCard(
                          subjectName: element['subjectName'].toString(),
                          count: element['count'].toString(),
                        ),
                      );
                    }
                  }
                  if (snapshot.hasError) {
                    //TODO: write to log file or user database log
                    print(snapshot.error);
                  }
                  return ListView(
                    children: subjects,
                  );
                },
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
                            decoration: const InputDecoration(
                              label: Text('Name'),
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
                              setState(
                                () {
                                  _collectionName =
                                      _collectionNameTextFormController.text;
                                },
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateCardsScreen(
                                      subjectName: _collectionName),
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
                          child: const Text('Create'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              child: const Icon(Icons.library_add_rounded),
            ),
            endDrawer: Drawer(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      await authService.logout();
                    },
                    child: const Icon(Icons.logout),
                  ),
                ],
              ),
            ),
          );
  }
}
