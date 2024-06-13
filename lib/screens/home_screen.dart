import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/screens/login_screen.dart';
import 'package:todo_list/services/firebase_services.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final CollectionReference _items =
      FirebaseFirestore.instance.collection('items');

  final CollectionReference _user =
      FirebaseFirestore.instance.collection('users');

  late TabController _tabController;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  // ---------------------------------------------------------

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Create New Todo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Title', hintText: 'Enter the task'),
                ),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter the description'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;
                      final String description = _descController.text;

                      if (description.isNotEmpty) {
                        await _items.add({
                          "userId": _currentUser!.uid,
                          "name": name,
                          "description": description,
                          "timestamp": FieldValue.serverTimestamp(),
                          "completed": false,
                        });
                        _nameController.text = '';
                        _descController.text = '';

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Add"))
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _descController.text = documentSnapshot['description'];
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Update your items",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Title', hintText: 'Add title'),
                ),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                      labelText: 'Description', hintText: 'Add description'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;
                      final String description = _descController.text;

                      if (description.isNotEmpty) {
                        await _items.doc(documentSnapshot!.id).update({
                          "name": name,
                          "description": description,
                        });
                        _nameController.text = '';
                        _descController.text = '';

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Update"))
              ],
            ),
          ),
        );
      },
    );
  }
//-----------------------------------------------------------------

  Future<void> _nameupdate([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Update your Name",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration:
                      InputDecoration(labelText: 'Name', hintText: 'Add name'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = _nameController.text;

                      if (name.isNotEmpty) {
                        try {
                          if (documentSnapshot != null) {
                            await _user.doc(documentSnapshot.id).update({
                              "name": name,
                            });
                            _nameController.text = '';
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Error: Document snapshot is null"),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error updating name: $e"),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Name cannot be empty"),
                          ),
                        );
                      }
                    },
                    child: Text("Update"))
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(String productID) async {
    await _items.doc(productID).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have successfully deleted an item")));
  }

  Future<void> _toggleCompleted(DocumentSnapshot documentSnapshot) async {
    await _items.doc(documentSnapshot.id).update({
      'completed': !documentSnapshot['completed'],
    });
  }

  Widget _buildTaskList(
      AsyncSnapshot<QuerySnapshot> streamSnapshot, bool completed) {
    if (streamSnapshot.hasData) {
      final docs = streamSnapshot.data!.docs
          .where((doc) =>
              doc['userId'] == _currentUser!.uid &&
              doc['completed'] == completed)
          .toList();

      return ListView.builder(
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final DocumentSnapshot documentSnapshot = docs[index];

          Timestamp? timestamp = documentSnapshot['timestamp'] as Timestamp?;
          DateTime? dateTime = timestamp?.toDate();
          String formattedDate = dateTime != null
              ? DateFormat.yMMMd().add_jm().format(dateTime)
              : 'N/A';
          return Card(
            color: Color.fromARGB(255, 234, 234, 233),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Title :- ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          documentSnapshot['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Description :- ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          documentSnapshot
                                  .data()
                                  .toString()
                                  .contains('description')
                              ? documentSnapshot['description']
                              : '',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Created at :-",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: completed
                        ? [
                            IconButton(
                              color: Colors.black,
                              onPressed: () => _delete(documentSnapshot.id),
                              icon: Icon(Icons.delete),
                            ),
                          ]
                        : [
                            IconButton(
                              color: Colors.black,
                              onPressed: () => _update(documentSnapshot),
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              color: Colors.black,
                              onPressed: () => _delete(documentSnapshot.id),
                              icon: Icon(Icons.delete),
                            ),
                            ElevatedButton(
                                onPressed: () =>
                                    _toggleCompleted(documentSnapshot),
                                child: Text("Completed")),
                          ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseServices.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              },
              icon: Icon(Icons.logout))
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data != null) {
                  var userDoc = snapshot.data!;
                  if (userDoc["Image_URL"] != null &&
                      userDoc["Image_URL"].isNotEmpty) {
                    return CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          userDoc["Image_URL"],
                          fit: BoxFit.cover,
                          width: 40.0,
                          height: 40.0,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Icon(Icons.error);
                  }
                }
                return CircularProgressIndicator();
              },
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text('My Todo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.pending_actions),
              text: 'Pending',
            ),
            Tab(
              icon: Icon(Icons.done),
              text: 'Completed',
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("userId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        UserAccountsDrawerHeader(
                          accountName: Text(
                            _currentUser?.displayName ??
                                '${snapshot.data!.docs[index]["name"]}',
                          ),
                          accountEmail: Text(
                            _currentUser?.email ??
                                '${snapshot.data!.docs[index]["email"]}',
                          ),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.network(
                                snapshot.data!.docs[index]["Image_URL"],
                                fit: BoxFit.cover,
                                width: 90.0,
                                height: 90.0,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.supervised_user_circle),
                          trailing: InkWell(
                              onTap: () {
                                _nameupdate(snapshot.data!.docs[index]);
                              },
                              child: Icon(Icons.edit)),
                          title: Text('${snapshot.data!.docs[index]["name"]}'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text('${snapshot.data!.docs[index]["email"]}'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StreamBuilder(
            stream: _items.orderBy('timestamp', descending: true).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return _buildTaskList(streamSnapshot, false);
            },
          ),
          StreamBuilder(
            stream: _items.orderBy('timestamp', descending: true).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return _buildTaskList(streamSnapshot, true);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 234, 234, 233),
        onPressed: () => _create(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
