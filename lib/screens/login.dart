import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_family_app/screens/addFamilymeb.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  var _adminPanel = FirebaseFirestore.instance.collection("adminPanel");
  late String email;
  late String password;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1532224589403-0e70ee166b49?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1575&q=80'))),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(20),
              margin:
                  EdgeInsets.only(top: 70, bottom: 130, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "E-Family App",
                      style: GoogleFonts.dancingScript(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text("Welcome Back"),
                    SizedBox(height: 50),
                    TextFormField(
                      validator: (email) {
                        if (email!.isEmpty) {
                          return 'Enter a valid  email';
                        }
                      },
                      onSaved: (_email) {
                        setState(() {
                          email = _email!;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pinkAccent)),
                          suffixIcon: Icon(Icons.email),
                          labelText: "Email Address"),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      validator: (password) {
                        if (password!.isEmpty) return 'Enter Password';
                        if (password.isNotEmpty) {
                          if (password.length < 7) {
                            return "password is less then8";
                          }
                        }
                      },
                      onSaved: (_password) {
                        setState(() {
                          password = _password!;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pinkAccent)),
                          suffixIcon: Icon(Icons.lock),
                          labelText: "Password"),
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          _adminPanel
                              .where('email', isEqualTo: email)
                              .where('password', isEqualTo: password)
                              .get()
                              .then((value) => {
                                    if (value.docs.length == 1)
                                      {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddFamilyMember())),
                                        email = email,
                                        password = password,
                                      }
                                    else
                                      {}
                                  });

                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Dashboard(
                          //               email: email,
                          //               password: password,
                          //             )));
                          // email = '';
                          // password = '';
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
