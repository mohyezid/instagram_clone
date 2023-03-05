import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils.dart/colors.dart';
import 'package:instagram/utils.dart/gloal_var.dart';
import 'package:instagram/widget/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MediaQuery.of(context).size.width > webScreenSize
          ? webBackgroundColor
          : mobileBackgroundColor,
      appBar: MediaQuery.of(context).size.width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.messenger_outline))
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(
                    horizontal:
                        MediaQuery.of(context).size.width > webScreenSize
                            ? MediaQuery.of(context).size.width * 0.3
                            : 0,
                    vertical: MediaQuery.of(context).size.width > webScreenSize
                        ? 15
                        : 0),
                child: PostCard(
                  snap: snapshot.data!.docs[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
