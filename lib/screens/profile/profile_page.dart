import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controller/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();
  final TextEditingController userNameController = TextEditingController();
  final _profileNameFormKey = GlobalKey<FormState>();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<String?> _loadProfileData() async {
    try {
      // Assuming this function fetches some user profile data (e.g., name or URL)
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(authService.currentUser()!.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userNameController.text = userData['name'];
        });
        return userData['name'];
      }
    } catch (e) {
      // print('Error loading profile data: $e');
    }
    return null; // Return null if no data is found or there's an error
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Form(
        key: _profileNameFormKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller:
                  TextEditingController(text: authService.currentUser()!.email),
              enabled: false, // This makes the field non-editable
              // readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name cannot be empty';
                }
                return null;
              },
              controller: userNameController,
              // enabled: false, // This makes the field non-editable
              // readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_profileNameFormKey.currentState!.validate()) {
                    await saveUserName();
                  }
                },
                child: const Text("Save"))
          ]),
        ),
      ),
    );
  }

  // Function to save the name
  Future<void> saveUserName() async {
    String name = userNameController.text;

    if (name.isNotEmpty) {
      await fireStore
          .collection('Users')
          .doc(authService.currentUser()!.uid)
          .update({'name': name});
      userNameController.clear();
      Navigator.pop(context);
    }
  }
}
