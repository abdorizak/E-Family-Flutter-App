import 'dart:convert';

FamilyMember familyMemberFromJson(String str) =>
    FamilyMember.fromJson(json.decode(str));

String familyMemberToJson(FamilyMember data) => json.encode(data.toJson());

class FamilyMember {
  FamilyMember({
    required this.uid,
    required this.name,
    required this.img,
  });

  String uid;
  String name;
  String img;

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        uid: json["uid"],
        name: json["name"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "img": img,
      };
}
