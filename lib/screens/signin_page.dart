import 'package:flutter/material.dart';
import 'package:flutter_push_notification/Firebase/service_firebase.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
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
                obscureText: true,
                controller: passwordController,
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
                  ServiceFirebase().signIn(emailController.text.trim(), passwordController.text.trim()).then((value){
                    setState(() {

                    });
                  });

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
                        "Sign In",
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
                  const Text("Don't have a account ?",style: TextStyle(fontSize: 18),),
                  TextButton(
                    child: const Text("Sign Up", style: TextStyle(fontSize: 18),),
                    onPressed: (){
                      Navigator.pushNamed(context, '/signup');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
