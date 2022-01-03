import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:e_family_app/screens/parent_description.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddFamilyMember extends StatefulWidget {
  const AddFamilyMember({Key? key}) : super(key: key);

  @override
  _AddFamilyMemberState createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  late String name;
  String? imgUrl;
  bool isLoading = false;
  File? image;
  List<String> _familyMemberList = ['Big Parent'];
  var _familyCollection = FirebaseFirestore.instance.collection('family');

  String dropdownValue = 'Big Parent';
  String level = 'Middle Level';
  final _formKey = GlobalKey<FormState>();
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Image Not Picked');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'xman@gmail.com', password: '1234567890');
    _familyCollection.get().then((_family) => {
          if (_family.docs.length > 0)
            {
              for (var i = 0; i < _family.docs.length; i++)
                {
                  print(_family.docs[i].get('name')),
                  addToFamilyMem(_family.docs[i].get('name')),
                }
            }
        });
  }

  addToFamilyMem(name) {
    _familyMemberList.add(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('E-Family'),
        ),
        body: !isLoading
            ? ListView(
                padding: EdgeInsets.all(12),
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Add New Member',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 17),
                  Text(
                    'Image',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 6,
                                blurRadius: 8,
                                offset:
                                    Offset(0, 5), // changes position of shadow
                              ),
                            ],
                            border: Border.all(),
                          ),
                          width: double.infinity,
                          height: 300,
                          child: image != null
                              ? Image.file(
                                  image!,
                                  fit: BoxFit.fill,
                                )
                              : Image(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(
                                      'https://cdn4.vectorstock.com/i/1000x1000/39/58/unknown-male-person-eps-10-vector-13383958.jpg')))),
                  SizedBox(height: 20),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            validator: (_name) {
                              if (_name!.isNotEmpty) {
                                name = _name;
                              } else {
                                return 'Enter Name';
                              }
                            },
                            onSaved: (_name) {
                              name = _name!;
                            },
                            decoration: InputDecoration(
                                labelText: 'Member Name',
                                hintText: 'Enter Name',
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: Colors.grey)),
                            padding: EdgeInsets.all(5),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              // elevation: 16,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: _familyMemberList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: Colors.grey)),
                            padding: EdgeInsets.all(5),
                            child: DropdownButton<String>(
                              value: level,
                              // elevation: 16,
                              onChanged: (String? newValue) {
                                setState(() {
                                  level = newValue!;
                                });
                              },
                              items: <String>[
                                'Top Level',
                                'Middle Level'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () async {
                                    var isTopLevel = false;
                                    if (level == 'Top Level') isTopLevel = true;
                                    _formKey.currentState!.save();
                                    if (_formKey.currentState!.validate()) {
                                      Reference _imgUpldRef = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('family/${Uuid().v1()}');

                                      var _task = _imgUpldRef.putFile(image!);
                                      setState(() {
                                        isLoading = true;
                                      });
                                      _task.whenComplete(() async {
                                        imgUrl = await _task.snapshot.ref
                                            .getDownloadURL();
                                        setState(() {
                                          isLoading = false;
                                        });
                                        _familyCollection
                                            .add({
                                              'name': name,
                                              'type': dropdownValue,
                                              'isTopLevel': isTopLevel,
                                              'image': imgUrl == null
                                                  ? 'https://st3.depositphotos.com/3581215/18899/v/600/depositphotos_188994514-stock-illustration-vector-illustration-male-silhouette-profile.jpg'
                                                  : imgUrl
                                            })
                                            .then((_memFamily) => {
                                                  _memFamily.update(
                                                      {'uid': _memFamily.id})
                                                })
                                            .then((value) {
                                              CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.success,
                                                text:
                                                    "The Member was successful Registred!",
                                              ).then((value) =>
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddFamilyMember())));
                                            });
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          )
                        ],
                      ))
                ],
              )
            : Center(child: CircularProgressIndicator()));
  }
}
