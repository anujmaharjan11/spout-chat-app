import 'package:chat_help_project/components/home.dart';
import 'package:chat_help_project/components/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _emailController = TextEditingController();

  late final TextEditingController _passwordController =
      TextEditingController();

  late FirebaseAuth auth = FirebaseAuth.instance;

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ChatHome()));
  }

  @override
  void initState() {
    super.initState();
    getAdmin("admin");
  }

  Future<void> getAdmin(String role) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    print(snapshot.docs
        .map((e) => auth.currentUser?.uid == e['uid'] && e["role"] != "admin"));
  }

  Future handleLogin(BuildContext context) async {
    try {
      // QuerySnapshot<Map<String, dynamic>> snapshot =
      //     await FirebaseFirestore.instance.collection('users').get();
      // bool isAdmin = snapshot.docs.any((doc) =>  doc.data()['role'] == 'customer');
      //
      // // bool isAdmin = false;
      // // for (var doc in snapshot.docs) {
      // //   if (doc.data()['role'] == 'admin') {
      // //     isAdmin = true;
      // //   }
      // // }
      //
      // print(isAdmin);

      // if (isAdmin ==  false) {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      _navigateToNextScreen(context);
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print('User not permitted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Help Chat',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    handleLogin(context);
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Register()));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
