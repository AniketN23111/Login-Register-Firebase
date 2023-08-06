import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/home_page.dart';
import 'package:login/login_page.dart';

import 'consts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late AsyncSnapshot<User?> snapshot;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  login() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  createUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Account Created Successfully Click on Login button to Login"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The password provided is too weak."),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The account already exists for that email."),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
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
                  "Register",
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
                    else if(text.length<8)
                    {
                      return 'Length should be more than 8 Characters';
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
                SizedBox(height: size.height * 0.004),
                TextFormField(
                  obscureText: true,
                  controller: _confirmPassword,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Password is Empty';
                    }
                    else if(text.length<8)
                      {
                        return 'Length should be more than 8 Characters';
                      }
                    else if(text!=_password.text)
                      {
                        return 'Password Mismatch';
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
                SizedBox(height: size.height * 0.004),
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
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        createUserWithEmailAndPassword();
                      }
                    }),
                CupertinoButton(
                  onPressed: () {
                    login();
                  },
                  child: Container(
                    height: size.height * 0.070,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: btnColor,
                        borderRadius: BorderRadius.circular(27)),
                    child: Center(
                        child: Text("Login",
                            style: TextStyle(color: Colors.white))),
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
