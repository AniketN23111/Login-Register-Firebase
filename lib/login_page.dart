import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/home_page.dart';
import 'package:login/signup.dart';

import 'consts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late AsyncSnapshot<User?> snapshot;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );

      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No user found for that email."),
          ),
        );
      } else if (e.code == 'wrong-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong Password Provided For theUser"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [c1, c2],
        )),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: OverflowBar(
              overflowAlignment: OverflowBarAlignment.center,
              overflowSpacing: 10,
              children: [
                Image.asset('assets/back.png'),
                Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: size.height * 0.004),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _email,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Email is Empty';
                    }
                    else if(!text.contains("@") || (!text.contains(".")))
                    {
                      return 'Please Enter Valid Email Address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.mail),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(37.0),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.004),
                TextFormField(
                  obscureText: true,
                  controller: _password,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Password is Empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.remove_red_eye_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(37.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    'Dont have Account',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white),
                  ),
                ),
                CupertinoButton(
                    child: Container(
                      height: size.height * 0.070,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: btnColor,
                          borderRadius: BorderRadius.circular(27)),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            )
                          : Center(
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signInWithEmailAndPassword();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
