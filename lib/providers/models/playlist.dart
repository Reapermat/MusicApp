import 'dart:convert';

Playlist playlistFromJson(String str) => Playlist.fromJson(json.decode(str));

String playlistToJson(Playlist data) => json.encode(data.toJson());

class Playlist {
  Playlist({
    this.data,
    this.checksum,
    this.total,
  });

  List<Datum> data;
  String checksum;
  int total;

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        checksum: json["checksum"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "checksum": checksum,
        "total": total,
      };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.duration,
    this.public,
    this.isLovedTrack,
    this.collaborative,
    this.nbTracks,
    this.fans,
    this.link,
    this.picture,
    this.pictureSmall,
    this.pictureMedium,
    this.pictureBig,
    this.pictureXl,
    this.checksum,
    this.tracklist,
    this.creationDate,
    this.md5Image,
    this.timeAdd,
    this.timeMod,
    this.creator,
    this.type,
  });

  int id;
  String title;
  int duration;
  bool public;
  bool isLovedTrack;
  bool collaborative;
  int nbTracks;
  int fans;
  String link;
  String picture;
  String pictureSmall;
  String pictureMedium;
  String pictureBig;
  String pictureXl;
  String checksum;
  String tracklist;
  DateTime creationDate;
  String md5Image;
  int timeAdd;
  int timeMod;
  Creator creator;
  String type;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        duration: json["duration"],
        public: json["public"],
        isLovedTrack: json["is_loved_track"],
        collaborative: json["collaborative"],
        nbTracks: json["nb_tracks"],
        fans: json["fans"],
        link: json["link"],
        picture: json["picture"],
        pictureSmall: json["picture_small"],
        pictureMedium: json["picture_medium"],
        pictureBig: json["picture_big"],
        pictureXl: json["picture_xl"],
        checksum: json["checksum"],
        tracklist: json["tracklist"],
        creationDate: DateTime.parse(json["creation_date"]),
        md5Image: json["md5_image"],
        timeAdd: json["time_add"],
        timeMod: json["time_mod"],
        creator: Creator.fromJson(json["creator"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "duration": duration,
        "public": public,
        "is_loved_track": isLovedTrack,
        "collaborative": collaborative,
        "nb_tracks": nbTracks,
        "fans": fans,
        "link": link,
        "picture": picture,
        "picture_small": pictureSmall,
        "picture_medium": pictureMedium,
        "picture_big": pictureBig,
        "picture_xl": pictureXl,
        "checksum": checksum,
        "tracklist": tracklist,
        "creation_date": creationDate.toIso8601String(),
        "md5_image": md5Image,
        "time_add": timeAdd,
        "time_mod": timeMod,
        "creator": creator.toJson(),
        "type": type,
      };
}

class Creator {
  Creator({
    this.id,
    this.name,
    this.tracklist,
    this.type,
  });

  int id;
  String name;
  String tracklist;
  String type;

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["id"],
        name: json["name"],
        tracklist: json["tracklist"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tracklist": tracklist,
        "type": type,
      };
}
