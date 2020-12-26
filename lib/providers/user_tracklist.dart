// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'models/tracklist_artist.dart';
// import 'models/tracklist_album.dart';
// import 'models/tracklist.dart'


// // class TracklistData {
// //   final List<UserTracklist> data;

// //   TracklistData({this.data});
// // }

// // class UserTracklist {
// //   final int id;
// //   final String title;
// //   final List<TracklistArtist> artistList;
// //   final List<TracklistAlbum> albumList;
// //   final String preview;

// //   UserTracklist(
// //       {this.id, this.title, this.artistList, this.albumList, this.preview});
// // }

// // class Tracklist with ChangeNotifier {
// //   List<UserTracklist> _tracklist = [];

// //   List<UserTracklist> get tracklist {
// //     return [..._tracklist];
// //   }

//   Future<void> getTracklist(String tracklistUrl) async {
//     //   final url = tracklistUrl;
//     //   print(url);
//     //   try {
//     //     final response = await http.get(url);
//     //     final List<TracklistData> loadedTracklist = [];
//     //     final extractedData = json.decode(response
//     //         .body); //okay got all of this now save it in array and display it.
//     //     print(extractedData);
//     //     if (extractedData == null) {
//     //       return;
//     //     }
//     //     loadedTracklist.add(
//     //       TracklistData(
//     //         data: (extractedData['data'] as List<dynamic>)
//     //             .map(
//     //               (item) => UserTracklist(
//     //                 id: item['id'],
//     //                 title: item['title'],
//     //                 preview: item['preview'],
//     //                 artistList: (item['artist'] as List<dynamic>)
//     //                     .map(
//     //                       (artist) => TracklistArtist(
//     //                         id: artist['id'],
//     //                         name: artist['name'],
//     //                       ),
//     //                     )
//     //                     .toList(),
//     //                 albumList: (item['album'] as List<dynamic>)
//     //                     .map(
//     //                       (album) => TracklistAlbum(
//     //                         id: album['id'],
//     //                         title: album['title'],
//     //                         coverMedium: album['coverMedium'],
//     //                       ),
//     //                     )
//     //                     .toList(),
//     //               ),
//     //             )
//     //             .toList(),
//     //       ),
//     //     );
//     //     _tracklist = loadedTracklist;
//     //     print(_tracklist);
//     //     notifyListeners();
//     //   } catch (error) {
//     //     throw error;
//     //   }

//     final url = tracklistUrl;
//     print(url);
//     try {
//       final response = await http.get(url);
//       final List<UserTracklist> loadedTracklist = [];
//       Map<String, dynamic> extractedData = json.decode(response
//           .body); //okay got all of this now save it in array and display it.
//       List<dynamic> data = extractedData['data']; // extract "data" from json
//       print('this data second ${data[0]['title']}'); //has to be an index
//       if (data == null) {
//         return;
//       }
//       loadedTracklist.add(
//         //kinda weird cuz im already taking out data so maybe without it
//         UserTracklist(
//           id: data[0]['id'],
//           title: data[0]['title'],
//           preview: data[0]['preview'],
//           artistList: (data[0]['artist'] as List<dynamic>)   //tu sie cos psuje zle ta liste odpalam
//               .map(
//                 (artist) => TracklistArtist(
//                   id: artist['id'],
//                   name: artist['name'],
//                 ),
//               )
//               .toList(),
//           // albumList: (data[0]['album'] as List<dynamic>)
//           //     .map(
//           //       (album) => TracklistAlbum(
//           //         id: album['id'],
//           //         title: album['title'],
//           //         coverMedium: album['coverMedium'],
//           //       ),
//           //     )
//           //     .toList(),
//         ),
//       );
//       _tracklist = loadedTracklist;
//       print(_tracklist);
//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }
// }
