import 'package:flutter/material.dart';
import 'package:flutter_push_notification/Firebase/service_firebase.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  ServiceFirebase serviceFirebase = ServiceFirebase();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200,Colors.green.shade400],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  labelText: "User Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  prefixIcon: const Icon(Icons.person)
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  prefixIcon: const Icon(Icons.email)
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  prefixIcon: const Icon(Icons.lock)
              ),
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: () {
                if(passwordController.text.length >= 6) {
                  serviceFirebase.signUp(
                    usernameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  ).then((value) => Navigator.pop(context));
                  
                }
              },
              child: Container(
                height: 51,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(colors: [
                      Colors.deepPurple.shade600,
                      Colors.deepPurple.shade400,
                      Colors.deepPurple.shade300,
                    ])),
                child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 18),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
