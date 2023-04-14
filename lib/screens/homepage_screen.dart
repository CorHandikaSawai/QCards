import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qcards/screens/create_card_screen.dart';
import 'package:qcards/screens/login_user_screen.dart';
import 'package:qcards/services/auth_service.dart';
import 'package:qcards/services/card_service.dart';
import 'package:qcards/widgets/collection_card_widget.dart';

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
  final List<String> _sortingList = <String>['Recent', 'A-Z', 'Z-A'];
  late String _sortValue;
  List<CollectionCard> subjects = [];

  @override
  void initState() {
    super.initState();
    _sortValue = _sortingList.first;
  }

  @override
  Widget build(BuildContext context) {
    final cardService = Provider.of<CardService>(context);
    final authService = Provider.of<AuthenticationService>(context);
    return FirebaseAuth.instance.currentUser == null
        ? LoginUserScreen()
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
                future: cardService.getUserSubjects(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  sortValue: _sortValue,
                ),
                builder: (context,
                    AsyncSnapshot<List<Map<String, String>>> snapshot) {
                  if (snapshot.hasData) {
                    subjects = [];
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          value: _sortValue,
                          items: _sortingList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _sortValue = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: subjects,
                        ),
                      ),
                    ],
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
                            maxLength: 25,
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Row(
                                      children: [
                                        const CircularProgressIndicator(),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 7),
                                          child: const Text("Loading..."),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              if (await cardService.exists(
                                  subjectName:
                                      _collectionNameTextFormController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Collection Already Exists. Change the name or edit the existing one'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateCardsScreen(
                                        subjectName:
                                            _collectionNameTextFormController
                                                .text),
                                  ),
                                );
                              }
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
            endDrawer: SafeArea(
              child: Drawer(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        FirebaseAuth.instance.currentUser!.displayName == null
                            ? FirebaseAuth.instance.currentUser!.email
                                .toString()
                            : FirebaseAuth.instance.currentUser!.displayName
                                .toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await authService.logout();
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
