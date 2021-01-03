import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        this.id,
        this.name,
        this.lastname,
        this.firstname,
        this.email,
        this.status,
        this.birthday,
        this.inscriptionDate,
        this.gender,
        this.link,
        this.picture,
        this.pictureSmall,
        this.pictureMedium,
        this.pictureBig,
        this.pictureXl,
        this.country,
        this.lang,
        this.isKid,
        this.explicitContentLevel,
        this.explicitContentLevelsAvailable,
        this.tracklist,
        this.type,
    });

    int id;
    String name;
    String lastname;
    String firstname;
    String email;
    int status;
    String birthday;
    DateTime inscriptionDate;
    String gender;
    String link;
    String picture;
    String pictureSmall;
    String pictureMedium;
    String pictureBig;
    String pictureXl;
    String country;
    String lang;
    bool isKid;
    String explicitContentLevel;
    List<String> explicitContentLevelsAvailable;
    String tracklist;
    String type;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        email: json["email"],
        status: json["status"],
        birthday: json["birthday"],
        inscriptionDate: DateTime.parse(json["inscription_date"]),
        gender: json["gender"],
        link: json["link"],
        picture: json["picture"],
        pictureSmall: json["picture_small"],
        pictureMedium: json["picture_medium"],
        pictureBig: json["picture_big"],
        pictureXl: json["picture_xl"],
        country: json["country"],
        lang: json["lang"],
        isKid: json["is_kid"],
        explicitContentLevel: json["explicit_content_level"],
        explicitContentLevelsAvailable: List<String>.from(json["explicit_content_levels_available"].map((x) => x)),
        tracklist: json["tracklist"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "firstname": firstname,
        "email": email,
        "status": status,
        "birthday": birthday,
        "inscription_date": "${inscriptionDate.year.toString().padLeft(4, '0')}-${inscriptionDate.month.toString().padLeft(2, '0')}-${inscriptionDate.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "link": link,
        "picture": picture,
        "picture_small": pictureSmall,
        "picture_medium": pictureMedium,
        "picture_big": pictureBig,
        "picture_xl": pictureXl,
        "country": country,
        "lang": lang,
        "is_kid": isKid,
        "explicit_content_level": explicitContentLevel,
        "explicit_content_levels_available": List<dynamic>.from(explicitContentLevelsAvailable.map((x) => x)),
        "tracklist": tracklist,
        "type": type,
    };
}
