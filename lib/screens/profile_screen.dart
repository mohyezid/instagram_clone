import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/resources/firestore_method.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils.dart/colors.dart';
import 'package:instagram/utils.dart/utils.dart';
import 'package:instagram/widget/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postlen = 0;
  int followers = 0;
  int following = 0;
  bool isfollowing = false;
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isloading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      userData = usersnap.data()!;
      postlen = postSnap.docs.length;
      followers = usersnap.data()!['followers'].length;
      following = usersnap.data()!['following'].length;
      isfollowing = usersnap
          .data()!['following']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.red,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildstatcol(postlen, "posts"),
                                  buildstatcol(followers, "followers"),
                                  buildstatcol(following, "following"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          widget.uid
                                      ? FollowButton(
                                          function: () async {
                                            await AuthMethods().signOut();
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()));
                                          },
                                          backgroundColor:
                                              mobileBackgroundColor,
                                          borderColor: Colors.grey,
                                          textColor: primaryColor,
                                          txt: 'Sign out')
                                      : isfollowing
                                          ? FollowButton(
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid']);
                                                setState(() {
                                                  isfollowing = false;
                                                  followers -= 1;
                                                });
                                              },
                                              backgroundColor: Colors.white,
                                              borderColor: Colors.grey,
                                              textColor: Colors.black,
                                              txt: 'Unfollow')
                                          : FollowButton(
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid']);
                                                setState(() {
                                                  isfollowing = true;
                                                  followers += 1;
                                                });
                                              },
                                              backgroundColor: Colors.blue,
                                              borderColor: Colors.blue,
                                              textColor: Colors.white,
                                              txt: 'Follow')
                                ],
                              ),
                            ]),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        return Container(
                          child: Image(
                            image: NetworkImage(
                                snapshot.data!.docs[index]['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildstatcol(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
