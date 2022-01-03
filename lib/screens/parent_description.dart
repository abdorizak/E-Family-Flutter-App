import 'package:cool_alert/cool_alert.dart';
import 'package:e_family_app/screens/home.dart';
import 'package:e_family_app/utilits/contant.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ParentDetailScreen extends StatefulWidget {
  final parent;
  const ParentDetailScreen({Key? key, required this.parent}) : super(key: key);

  @override
  _ParentDetailScreenState createState() => _ParentDetailScreenState();
}

class _ParentDetailScreenState extends State<ParentDetailScreen> {
  var _familyCollection = FirebaseFirestore.instance.collection('family');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: kBlackColor,
              image: DecorationImage(
                  alignment: Alignment.topLeft,
                  fit: BoxFit.fitWidth,
                  colorFilter: ColorFilter.mode(kBlackColor, BlendMode.color),
                  image: NetworkImage(widget.parent.get('image')))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 5, bottom: 10, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: kRedColor,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 30,
                            )),
                      ],
                    ),
                    SizedBox(height: 170),
                    ClipPath(
                      clipper: BestSellerClipper(),
                      child: Container(
                        color: kGreenColor,
                        padding: EdgeInsets.only(
                            left: 10, top: 5, right: 20, bottom: 5),
                        child: Text(
                          widget.parent.get('name'),
                          style: kHeadingextStyle,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(60)),
                  color: kBlackWithOColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 20, right: 8, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("All His/Her Childs",
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot>(
                          stream: _familyCollection
                              .where('type',
                                  isEqualTo: widget.parent.get('name'))
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var _childrens = snapshot.data!.docs;
                              return Expanded(
                                  child: Container(
                                width: double.infinity,
                                child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisExtent: 190,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemCount: _childrens.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          _familyCollection
                                              .where('type',
                                                  isEqualTo: _childrens[index]
                                                      .get('name'))
                                              .get()
                                              .then((_childs) => {
                                                    if (_childs.docs.length > 0)
                                                      {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ParentDetailScreen(
                                                                          parent:
                                                                              _childrens[index],
                                                                        )))
                                                      }
                                                    else
                                                      {
                                                        CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType
                                                                .warning,
                                                            text:
                                                                'This Member Has No Child Registred')
                                                      }
                                                  });
                                        },
                                        child: SimParent(
                                          img: _childrens[index].get('image'),
                                          isChild: true,
                                          name: _childrens[index].get('name'),
                                        ),
                                      );
                                    }),
                              ));
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class BestSellerClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
