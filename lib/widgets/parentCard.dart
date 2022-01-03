import 'package:flutter/material.dart';

class ParentCard extends StatelessWidget {
  final String name;
  final String userImage;
  const ParentCard({
    Key? key,
    required this.name,
    required this.userImage,
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
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(userImage))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6, top: 6),
            padding: EdgeInsets.only(right: 6, left: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(userImage),
                      )),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 2),
                      Text(
                        name,
                        maxLines: 2,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, height: 1.1),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ))
              ],
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
