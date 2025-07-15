/// Homepage of QCards.
/// Displays the user's collections, sorted by selected option.
/// Allows creating new collections and logging out.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:qcards/screens/create_card_screen.dart';
import 'package:qcards/screens/login_user_screen.dart';
import 'package:qcards/services/auth_service.dart';
import 'package:qcards/services/card_service.dart';
import 'package:qcards/widgets/collection_card_widget.dart';

import '../services/user_preference_service.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // Form input and helpers
  String? _collectionName;
  final _formKey = GlobalKey<FormState>();
  final _collectionNameTextFormController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sorting logic
  final List<String> _sortingList = <String>['Recent', 'A-Z', 'Z-A'];
  late String _sortValue;
  List<CollectionCard> subjects = [];

  @override
  void initState() {
    super.initState();
    _sortValue = _sortingList.first; // default sort = "Recent"
  }

  @override
  Widget build(BuildContext context) {
    final cardService = Provider.of<CardService>(context);
    final authService = Provider.of<AuthenticationService>(context);

    // Redirect unauthenticated users to login
    if (FirebaseAuth.instance.currentUser == null) return LoginUserScreen();

    return Scaffold(
      key: _scaffoldKey,

      // 🧠 App bar with account drawer
      appBar: AppBar(
        title: const Text('QCards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, size: 32),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),

      // 🧠 Main content with collections
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: cardService.getUserSubjects(
            userId: FirebaseAuth.instance.currentUser!.uid,
            sortValue: _sortValue,
          ),
          builder:
              (context, AsyncSnapshot<List<Map<String, String>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasData) {
              // Build the list of collection cards
              subjects = snapshot.data!.map((item) {
                return CollectionCard(
                  subjectName: item['subjectName'].toString(),
                  count: item['count'].toString(),
                );
              }).toList();
            }

            if (snapshot.hasError) {
              // 🔧 Could be logged to an external service
              print(snapshot.error);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧠 Sort dropdown
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    value: _sortValue,
                    items: _sortingList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: const TextStyle(fontSize: 18)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _sortValue = value!;
                      });
                    },
                  ),
                ),

                // 🧠 Display collection cards
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(12.w),
                    itemCount: subjects.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      return subjects[index];
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // ➕ Floating Action Button for new collection
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.library_add_rounded),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('New Collection'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🧠 Input for new collection name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      maxLength: 25,
                      controller: _collectionNameTextFormController,
                      decoration: const InputDecoration(label: Text('Name')),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Cannot be empty!'
                          : null,
                    ),
                  ),
                ),

                // 🧠 Create button logic
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Show loading dialog
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(width: 7),
                                Text("Loading..."),
                              ],
                            ),
                          ),
                        );

                        final name = _collectionNameTextFormController.text;

                        // Check if collection already exists
                        if (await cardService.exists(subjectName: name)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Collection Already Exists. Change the name or edit the existing one'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          Navigator.of(context).pop(); // Close loading dialog
                        } else {
                          // Go to create cards screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CreateCardsScreen(subjectName: name),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // 👤 Right drawer with user info and logout
      // endDrawer: SafeArea(
      //   child: Drawer(
      //     child: Padding(
      //       padding: const EdgeInsets.all(18),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           // Show display name or fallback to email
      //           Text(
      //             FirebaseAuth.instance.currentUser!.displayName ??
      //                 FirebaseAuth.instance.currentUser!.email!,
      //             style: const TextStyle(fontSize: 18),
      //           ),

      //           // 🔄 Theme switch
      //           Consumer<UserPreference>(
      //             builder: (context, userPref, _) {
      //               final isDark = userPref.theme.brightness == Brightness.dark;
      //               return SwitchListTile(
      //                 title: const Text("Dark Mode"),
      //                 value: isDark,
      //                 onChanged: (_) => userPref.setTheme(),
      //               );
      //             },
      //           ),

      //           // 🚪 Logout button
      //           TextButton(
      //             onPressed: () async {
      //               await authService.logout();
      //             },
      //             child: const Text(
      //               'Logout',
      //               style: TextStyle(color: Colors.redAccent, fontSize: 18),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
