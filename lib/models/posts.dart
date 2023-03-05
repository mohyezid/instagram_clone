import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String desc;
  final String uid;
  final String postId;
  final String username;
  final datePublished;
  final String postUrl;
  final String profImg;
  final likes;
  const Post(
      {required this.desc,
      required this.datePublished,
      required this.postId,
      required this.likes,
      required this.postUrl,
      required this.profImg,
      required this.uid,
      required this.username});

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'description': desc,
        'postId': postId,
        'datePublished': datePublished,
        'profImg': profImg,
        'likes': likes,
        'postUrl': postUrl
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        username: snapshot["username"],
        uid: snapshot["uid"],
        desc: snapshot["description"],
        postUrl: snapshot["postUrl"],
        likes: snapshot["likes"],
        profImg: snapshot["profImg"],
        datePublished: snapshot["datePublished"],
        postId: snapshot['postId']);
  }
}
