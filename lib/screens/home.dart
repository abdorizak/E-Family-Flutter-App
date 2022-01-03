import 'package:cool_alert/cool_alert.dart';
import 'package:e_family_app/modals/person.dart';
import 'package:e_family_app/screens/addFamilymeb.dart';
import 'package:e_family_app/screens/login.dart';
import 'package:e_family_app/screens/parent_description.dart';
import 'package:e_family_app/widgets/parentCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var eFamilyCollection = FirebaseFirestore.instance.collection('family');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-Family App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          CircleAvatar(backgroundColor: Colors.redAccent),
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'All Parents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
                stream: eFamilyCollection
                    .where('type', isEqualTo: 'Big Parent')
                    .where('isTopLevel', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var _member = snapshot.data!.docs;
                    return Container(
                      width: double.infinity,
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _member.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                eFamilyCollection
                                    .where('type',
                                        isEqualTo: _member[index].get('name'))
                                    .get()
                                    .then((_childs) => {
                                          if (_childs.docs.length > 0)
                                            {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ParentDetailScreen(
                                                            parent:
                                                                _member[index],
                                                          )))
                                            }
                                          else
                                            {
                                              CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.warning,
                                                  text:
                                                      'This Member Has No Child Registred')
                                            }
                                        });
                              },
                              child: BigParents(
                                img: _member[index].get('image'),
                                isChild: false,
                                name: _member[index].get('name'),
                              ),
                            );
                          }),
                    );
                  } else {
                    return LinearProgressIndicator();
                  }
                }),
            SizedBox(height: 15),
            Text(
              'Any Other Staff',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: eFamilyCollection
                      .where('type', isEqualTo: 'Big Parent')
                      .where('isTopLevel', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var _simParent = snapshot.data!.docs;
                      return GridView.builder(
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 200,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  eFamilyCollection
                                      .where('type',
                                          isEqualTo:
                                              _simParent[index].get('name'))
                                      .get()
                                      .then((_childs) => {
                                            if (_childs.docs.length > 0)
                                              {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ParentDetailScreen(
                                                              parent:
                                                                  _simParent[
                                                                      index],
                                                            )))
                                              }
                                            else
                                              {
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.warning,
                                                    text:
                                                        'This Member Has No Child Registred')
                                              }
                                          });
                                },
                                child: SimParent(
                                  img: _simParent[index].get('image'),
                                  isChild: false,
                                  name: _simParent[index].get('name'),
                                ));
                          });
                    } else {
                      return LinearProgressIndicator();
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminLogin()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BigParents extends StatelessWidget {
  final String img;
  final String name;
  final bool isChild;
  const BigParents(
      {Key? key, required this.img, required this.name, required this.isChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.only(right: 10),
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(img))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(name,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class SimParent extends StatelessWidget {
  final String img;
  final String name;
  final bool isChild;
  const SimParent({
    Key? key,
    required this.img,
    required this.name,
    required this.isChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(img))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(name,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: isChild ? 16 : 21, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
