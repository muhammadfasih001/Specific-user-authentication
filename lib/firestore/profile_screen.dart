import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_profileauth/authentication/login_screen.dart';
import 'package:flutter_profileauth/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("users");
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
      Utils().toastMessage("Sign Out");

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xffFFFFFF)),
    );
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu_open,
                  color: Color.fromRGBO(5, 50, 150, 1),
                ),
              );
            },
          ),
          title: const Text(
            "H O M E",
            style: TextStyle(
              color: Color.fromRGBO(5, 50, 150, 1),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Color.fromRGBO(5, 50, 150, 1),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        drawer: Drawer(
          width: 320,
          backgroundColor: Colors.white,
          child: DrawerHeader(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: [
                //profile lsit tile
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Color.fromRGBO(5, 50, 150, 1),
                  ),
                  title: const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromRGBO(5, 50, 150, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                      color: Color.fromRGBO(5, 50, 150, 1),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("id",
                          isEqualTo:
                              userId) // Replace "userId" with the actual field name in your Firestore documents.
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      Utils().toastMessage(
                          "An error occured: ${snapshot.error.toString()}");
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      Utils().toastMessage("No data available");
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot dataIndex = snapshot.data!.docs[index];

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.person_pin_rounded,
                                  color: Color.fromRGBO(5, 50, 150, 1),
                                ),
                                title: Text(dataIndex["id"]),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: Color.fromRGBO(5, 50, 150, 1),
                                ),
                                title: Text(dataIndex["username"]),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.alternate_email,
                                  color: Color.fromRGBO(5, 50, 150, 1),
                                ),
                                title: Text(dataIndex["email"]),
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.phone,
                                  color: Color.fromRGBO(5, 50, 150, 1),
                                ),
                                title: Text(dataIndex["contact"]),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
