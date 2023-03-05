import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/utils.dart/gloal_var.dart';

import '../utils.dart/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  String username = '';
  int page = 0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    getUsername();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void naviagtionTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      page = page;
    });
  }

  void pagechanegd(int rpage) {
    setState(() {
      page = rpage;
    });
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 32,
          ),
          actions: [
            IconButton(
                onPressed: () => naviagtionTapped(0),
                icon: Icon(
                  Icons.home,
                  color: page == 0 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () => naviagtionTapped(1),
                icon: Icon(Icons.search,
                    color: page == 1 ? primaryColor : secondaryColor)),
            IconButton(
                onPressed: () => naviagtionTapped(2),
                icon: Icon(Icons.add_a_photo,
                    color: page == 2 ? primaryColor : secondaryColor)),
            IconButton(
                onPressed: () => naviagtionTapped(3),
                icon: Icon(Icons.favorite,
                    color: page == 3 ? primaryColor : secondaryColor)),
            IconButton(
                onPressed: () => naviagtionTapped(4),
                icon: Icon(Icons.person,
                    color: page == 4 ? primaryColor : secondaryColor))
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: homeScreenItems,
          controller: pageController,
          onPageChanged: pagechanegd,
        ));
  }
}
